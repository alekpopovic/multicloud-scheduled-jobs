from __future__ import annotations

from pathlib import Path
from typing import Any

from .config import SUPPORTED_CLOUDS, WorkloadConfig


PLACEHOLDER_VALUES = {
    "",
    "REPLACE_WITH_PROVIDER_IMAGE",
    "my-gcp-project-id",
    "00000000-0000-0000-0000-000000000000",
    "vpc-xxxxxxxxxxxxxxxxx",
}


def validate_cloud(cloud: str) -> None:
    if cloud not in SUPPORTED_CLOUDS:
        raise ValueError(f"cloud must be one of {', '.join(SUPPORTED_CLOUDS)}.")


def validate_name(name: str) -> None:
    if not name:
        raise ValueError("name is required.")
    allowed = set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_")
    if any(char not in allowed for char in name):
        raise ValueError("name may contain only letters, numbers, hyphen, and underscore.")


def validate_repo_root(repo_root: Path) -> None:
    module_dir = repo_root / "modules" / "multicloud" / "scheduled-batch-job"
    if not module_dir.is_dir():
        raise ValueError(f"Repo root does not contain {module_dir}.")


def validate_workload(config: WorkloadConfig) -> None:
    validate_cloud(config.cloud)
    validate_name(config.name)
    if _is_placeholder(config.container_image):
        raise ValueError("container_image must be configured before rendering or applying.")

    if config.cloud == "aws":
        _require(config.aws_config, "vpc_id", "aws.vpc_id")
        subnet_ids = config.aws_config.get("subnet_ids", [])
        if not isinstance(subnet_ids, list) or not subnet_ids:
            raise ValueError("aws.subnet_ids must contain at least one subnet ID.")
    elif config.cloud == "gcp":
        _require(config.gcp_config, "project_id", "gcp.project_id")
    elif config.cloud == "azure":
        _require(config.azure_config, "subscription_id", "azure.subscription_id")
        _require(config.azure_config, "resource_group_name", "azure.resource_group_name")
        if (
            config.azure_config.get("public_address_provisioning_type")
            == "NoPublicIPAddresses"
            and not config.azure_config.get("subnet_id")
        ):
            raise ValueError(
                "azure.subnet_id is required when public_address_provisioning_type is NoPublicIPAddresses."
            )


def _require(mapping: dict[str, Any], key: str, label: str) -> None:
    if _is_placeholder(mapping.get(key)):
        raise ValueError(f"{label} must be configured.")


def _is_placeholder(value: Any) -> bool:
    return value is None or str(value) in PLACEHOLDER_VALUES
