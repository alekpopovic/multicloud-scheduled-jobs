from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any


DEFAULT_CONFIG_PATH = Path.home() / ".scheduled-batch" / "config.json"
DEFAULT_PROFILE = "default"
SUPPORTED_CLOUDS = ("aws", "gcp", "azure")


@dataclass(frozen=True)
class ConfigPaths:
    config_path: Path
    deployments_dir: Path
    repo_root: Path


@dataclass(frozen=True)
class WorkloadConfig:
    cloud: str
    name: str
    container_image: str
    container_command: list[str]
    environment_variables: dict[str, str]
    schedule_expression: str | None
    schedule_timezone: str
    tags: dict[str, str]
    aws_region: str
    aws_config: dict[str, Any]
    gcp_config: dict[str, Any]
    azure_config: dict[str, Any]
    scheduler_input: dict[str, Any]
    enable_command_override_from_scheduler_input: bool


def example_config() -> dict[str, Any]:
    return {
        "profiles": {
            "default": {
                "defaults": {
                    "container_image": "REPLACE_WITH_PROVIDER_IMAGE",
                    "container_command": [
                        "sh",
                        "-c",
                        "echo Hello from scheduled batch; date; env",
                    ],
                    "environment_variables": {
                        "APP_ENV": "dev",
                        "LOG_LEVEL": "info",
                    },
                    "schedule_expression": None,
                    "schedule_timezone": "Europe/Belgrade",
                    "tags": {
                        "project": "scheduled-batch",
                        "env": "dev",
                    },
                    "scheduler_input": {},
                    "enable_command_override_from_scheduler_input": False,
                },
                "aws": {
                    "aws_region": "eu-central-1",
                    "vpc_id": "vpc-xxxxxxxxxxxxxxxxx",
                    "subnet_ids": [
                        "subnet-aaaaaaaaaaaaaaaaa",
                        "subnet-bbbbbbbbbbbbbbbbb",
                    ],
                    "assign_public_ip": False,
                },
                "gcp": {
                    "project_id": "my-gcp-project-id",
                    "region": "europe-west1",
                },
                "azure": {
                    "subscription_id": "00000000-0000-0000-0000-000000000000",
                    "resource_group_name": "rg-scheduled-batch-azure",
                    "location": "westeurope",
                    "recurrence_frequency": "Day",
                    "recurrence_interval": 1,
                    "recurrence_time_zone": "Central Europe Standard Time",
                    "recurrence_hours": [3],
                    "recurrence_minutes": [0],
                },
            }
        }
    }


def write_example_config(path: Path) -> bool:
    if path.exists():
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(example_config(), indent=2) + "\n", encoding="utf-8")
    return True


def load_config(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError("Config root must be a JSON object.")
    return data


def profile_config(config: dict[str, Any], profile: str) -> dict[str, Any]:
    profiles = config.get("profiles")
    if not isinstance(profiles, dict):
        raise ValueError('Config must contain a "profiles" object.')
    selected = profiles.get(profile)
    if not isinstance(selected, dict):
        raise ValueError(f'Profile "{profile}" was not found in config.')
    return selected


def build_workload_config(
    config: dict[str, Any],
    *,
    profile: str,
    cloud: str,
    name: str,
) -> WorkloadConfig:
    selected = profile_config(config, profile)
    defaults = selected.get("defaults", {})
    if not isinstance(defaults, dict):
        raise ValueError(f'Profile "{profile}" defaults must be an object.')

    cloud_config = selected.get(cloud, {})
    if not isinstance(cloud_config, dict):
        raise ValueError(f'Profile "{profile}" cloud config "{cloud}" must be an object.')

    container_image = str(
        cloud_config.get("container_image", defaults.get("container_image", ""))
    )
    container_command = cloud_config.get(
        "container_command",
        defaults.get("container_command", ["sh", "-c", "echo Hello from scheduled batch"]),
    )
    if not isinstance(container_command, list):
        raise ValueError("container_command must be a list of strings.")

    environment_variables = cloud_config.get(
        "environment_variables",
        defaults.get("environment_variables", {}),
    )
    tags = cloud_config.get("tags", defaults.get("tags", {}))
    scheduler_input = cloud_config.get("scheduler_input", defaults.get("scheduler_input", {}))

    aws_region = str(cloud_config.get("aws_region", selected.get("aws", {}).get("aws_region", "eu-central-1")))

    return WorkloadConfig(
        cloud=cloud,
        name=name,
        container_image=container_image,
        container_command=[str(item) for item in container_command],
        environment_variables=_string_map(environment_variables, "environment_variables"),
        schedule_expression=cloud_config.get(
            "schedule_expression",
            defaults.get("schedule_expression"),
        ),
        schedule_timezone=str(
            cloud_config.get("schedule_timezone", defaults.get("schedule_timezone", "Europe/Belgrade"))
        ),
        tags=_string_map(tags, "tags"),
        aws_region=aws_region,
        aws_config=dict(selected.get("aws", {})),
        gcp_config=dict(selected.get("gcp", {})),
        azure_config=dict(selected.get("azure", {})),
        scheduler_input=dict(scheduler_input),
        enable_command_override_from_scheduler_input=bool(
            cloud_config.get(
                "enable_command_override_from_scheduler_input",
                defaults.get("enable_command_override_from_scheduler_input", False),
            )
        ),
    )


def _string_map(value: Any, name: str) -> dict[str, str]:
    if not isinstance(value, dict):
        raise ValueError(f"{name} must be an object.")
    return {str(key): str(item) for key, item in value.items()}
