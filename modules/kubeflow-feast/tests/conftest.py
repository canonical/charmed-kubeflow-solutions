# tests/integration/conftest.py

import jubilant
import pytest

MODEL_NAME = "kubeflow"

@pytest.fixture(scope="module")
def juju(request: pytest.FixtureRequest):
    
    def print_debug_log(juju_instance: jubilant.Juju):
        if request.session.testsfailed:
            print(f"[DEBUG] Fetching debug log for model: {juju_instance.model}")
            log = juju_instance.debug_log(limit=1000)
            print(log, end="")

    juju_instance = jubilant.Juju()
    juju_instance.add_model(MODEL_NAME)

    try:
        yield juju_instance
    finally:
        print_debug_log(juju_instance)
