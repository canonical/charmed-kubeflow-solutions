# Scripts

## `charms_promotions.py`

Promotes charm revisions from a Juju status export to a higher risk channel (`beta` → `candidate` → `stable`).

### What it reads

- `--format text`: a `juju status` text output (full output is fine, not just the apps table)
- `--format yaml`: a status YAML with `applications.*.charm-name/charm-rev/charm-channel`

### Quick usage

From the `scripts/` directory:

```bash
python charms_promotions.py --file status.txt --format text --promote-to candidate --dry-run
```

Run for real:

```bash
python charms_promotions.py --file status.txt --format text --promote-to candidate --apply
```

Exclude charms (space-separated):

```bash
python charms_promotions.py --file status.txt --format text --promote-to candidate --dry-run --exclude mysql-k8s
```

### Notes

- Default mode is dry-run: it prints `charmcraft release ...` commands.
- Dry-run still calls `charmcraft status` to resolve exact revisions/resources.
- If you do not have access to a charm package, the script prints a warning and skips it.
- Passing `--exclude` replaces the default exclude list.
