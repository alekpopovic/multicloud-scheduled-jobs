import tempfile
import unittest
from pathlib import Path

from scheduled_batch_cli.config import build_workload_config, example_config
from scheduled_batch_cli.deployment import render_deployment


class RenderTests(unittest.TestCase):
    def test_render_writes_expected_files(self):
        config = example_config()
        config["profiles"]["default"]["defaults"]["container_image"] = "example/image:latest"
        workload = build_workload_config(
            config,
            profile="default",
            cloud="azure",
            name="daily-import",
        )

        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            module_dir = root / "modules" / "multicloud" / "scheduled-batch-job"
            module_dir.mkdir(parents=True)
            deployment = render_deployment(
                repo_root=root,
                deployments_dir=root / "deployments",
                config=workload,
            )

            self.assertTrue((deployment.path / "main.tf").exists())
            self.assertTrue((deployment.path / "terraform.tfvars.json").exists())
            self.assertIn(
                "modules/multicloud/scheduled-batch-job",
                (deployment.path / "main.tf").read_text(encoding="utf-8"),
            )


if __name__ == "__main__":
    unittest.main()
