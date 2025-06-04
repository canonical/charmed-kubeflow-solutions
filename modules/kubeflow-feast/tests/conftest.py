# tests/integration/conftest.py

import jubilant
import pytest


@pytest.fixture(scope="module")
def juju(request: pytest.FixtureRequest):
    keep_models = bool(request.config.getoption("--keep-models"))
    model_name = request.config.getoption("--model")

    def print_debug_log(juju_instance: jubilant.Juju):
        if request.session.testsfailed:
            print(f"[DEBUG] Fetching debug log for model: {juju_instance.model}")
            log = juju_instance.debug_log(limit=1000)
            print(log, end="")

    if model_name:
        juju_instance = jubilant.Juju(model=model_name)
        try:
            yield juju_instance
        finally:
            print_debug_log(juju_instance)
    else:
        with jubilant.temp_model(keep=keep_models) as juju_instance:
            try:
                yield juju_instance
            finally:
                print_debug_log(juju_instance)


def pytest_addoption(parser):
    parser.addoption(
        "--keep-models",
        action="store_true",
        default=False,
        help="keep temporarily-created models",
    )
    parser.addoption(
        "--model",
        action="store",
        help="Juju model to use; if not provided, a new model "
        "will be created for each test which requires one",
        default=None,
    )
