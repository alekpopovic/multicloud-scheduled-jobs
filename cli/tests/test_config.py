import unittest

from scheduled_batch_cli.config import build_workload_config, example_config


class ConfigTests(unittest.TestCase):
    def test_build_default_aws_workload(self):
        workload = build_workload_config(
            example_config(),
            profile="default",
            cloud="aws",
            name="daily-import",
        )

        self.assertEqual(workload.cloud, "aws")
        self.assertEqual(workload.name, "daily-import")
        self.assertEqual(workload.aws_region, "eu-central-1")
        self.assertIn("vpc_id", workload.aws_config)


if __name__ == "__main__":
    unittest.main()
