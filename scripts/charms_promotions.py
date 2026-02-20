import json
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import yaml
from IPython.core.oinspect import Bundle

RISKS = {"edge": 1, "beta": 2, "candidate": 3, "stable": 4}

class Charm:

    def __init__(self, name: str, revision: int, channel: str):
        self.name = name
        self.revision = revision
        self.channel = channel

        self._status: dict | None = None

    def __str__(self):
        return f"{self.name}:{self.channel}({self.revision})"

    def __repr__(self):
        return self.__str__()

    def get_status(self, channel: Optional[str] = None, revision: Optional[int] = None):

        if not self._status:
            output = subprocess.check_output(
                ["charmcraft", "status", self.name, "--format", "json"]
            )

            self._status = json.loads(output.decode("utf-8"))

        items = [
            mapping["base"] | release
            for track in self._status
            for mapping in track["mappings"]
            for release in mapping["releases"]
            if mapping["base"]
            if (not channel or channel == release["channel"]) and (
                        not revision or revision == release["revision"])
        ]

        return items


    def promote_version(self, risk: str, dry_run: bool = True):
        if risk not in RISKS.keys():
            raise ValueError("The risk is not recognized")

        items = self.get_status(revision=self.revision, channel=self.channel)

        if len(items) > 1:
            raise ValueError(f"Multiple items found: {items}")

        if len(items) == 0:
            raise ValueError(f"No item found")

        item = items[0]

        _channel = Path(item["channel"])
        risk_from = str(_channel.name)

        if risk_from not in RISKS.keys():
            raise ValueError("The revision does not belong to a risk channel")

        if RISKS[risk] <= RISKS[risk_from]:
            raise ValueError("I cannot promote to a lower risk")

        channel_to = str(_channel.parent / risk)

        cmds = (
                ["charmcraft", "release", self.name, f"--channel={channel_to}",
                 f"--revision={self.revision}"] +
                [f"--resource={resource['name']}:{resource['revision']}" for
                 resource in item["resources"]]
        )

        if dry_run:
            return cmds

        return subprocess.check_output(cmds).decode("utf-8")


from enum import Enum

class Format(str,Enum):
    TEXT = "text"
    YAML = "yaml"

@dataclass
class Bundle:

    charms: list[Charm]

    @classmethod
    def from_status(cls, content: str, format: Format = "text"):
        parsers = {
            Format.TEXT: TextParser,
            Format.YAML: YAMLParser
        }

        return parsers[format].parse(content)


class YAMLParser:

    @staticmethod
    def parse(content: str):
        data = yaml.safe_load(content)

        return Bundle([
            Charm(app["charm-name"], int(app["charm-rev"]), app["charm-channel"])
            for _, app in data["applications"].items()
        ])


class TextParser:
    word_with_leading_spaces = re.compile("^\s*[^\s]+")

    @staticmethod
    def extract_first_word(mystring):
        m = TextParser.word_with_leading_spaces.match(mystring)
        if m:
            return mystring[m.start():m.end()]
        return ""

    @staticmethod
    def parse_line(line, indices):
        return [line[start:end].strip() for start, end in indices]

    @staticmethod
    def parse(content: str):

        lines = content.split("\n")

        white_spaces = re.compile("\s+\s+")

        # Get header
        header = lines[0]

        # First guess of width based on headers
        ends=[s.end() for s in white_spaces.finditer(header)]
        indices = list(zip([0]+ends, ends+[-1]))

        # Columns names
        columns = TextParser.parse_line(header, indices)

        # Second guess of width based on maximum width of values
        # This is due to the fact that some columns the text extends to before the start
        # of the columns header (text aligned right)
        widths = [len(column) for column in columns]
        for line in lines[1:]:

            widths = list(map(max,zip(
                widths,
                [len(TextParser.extract_first_word(line[start:end])) for start, end in indices]
            )))

        # New guess
        ends = [start+width for (start,_), width in zip(indices, widths)]

        indices = list(zip([0]+ends[:-1], ends[:-1]+[-1]))

        data = [
            dict(zip(columns, TextParser.parse_line(line, indices)))
            for line in lines[1:]
        ]

        # pd.DataFrame([TextParser.parse_line(line, indices) for line in lines[1:]], columns= columns)
        return Bundle([
            Charm(item["Charm"], int(item["Rev"]), item["Channel"])
            for item in data
            if item["Charm"]
        ])


if __name__ == "__main__":

    # with open("./scripts/status.txt") as fid:
    #     bundle = Bundle.from_status(fid.read(), Format.TEXT)

    # with open("./scripts/status.yaml") as fid:
    #     bundle = Bundle.from_status(fid.read(), Format.YAML)

    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument("--file", required=True)
    parser.add_argument("--apply", default=False, action="store_true")
    parser.add_argument("--format", choices=("text", "yaml"), default="text")
    parser.add_argument("--promote-to", choices=("beta", "candidate", "stable"), default="beta")
    parser.add_argument("--exclude", nargs="*", default=["mysql-k8s"])
    args = parser.parse_args()

    with open(args.file) as fid:
        bundle = Bundle.from_status(fid.read(), args.format)

    for charm in bundle.charms:
        if not charm.name in args.exclude:
            print(charm.promote_version(args.promote_to, not args.apply))










    
