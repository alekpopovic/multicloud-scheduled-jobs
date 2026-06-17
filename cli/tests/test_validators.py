import unittest

from scheduled_batch_cli.validators import validate_cloud, validate_name


class ValidatorTests(unittest.TestCase):
    def test_validate_cloud_accepts_supported_clouds(self):
        for cloud in ("aws", "gcp", "azure"):
            validate_cloud(cloud)

    def test_validate_cloud_rejects_unknown_cloud(self):
        with self.assertRaises(ValueError):
            validate_cloud("other")

    def test_validate_name_rejects_spaces(self):
        with self.assertRaises(ValueError):
            validate_name("daily import")


if __name__ == "__main__":
    unittest.main()
