from __future__ import annotations

import json
import os
from dataclasses import dataclass
from pathlib import Path

from .config import WorkloadConfig
from .templates import render_template


@dataclass(frozen=True)
class Deployment:
    path: Path
    module_source: str


TEMPLATE_FILES = {
    "versions.tf": "versions.tf.tmpl",
    "providers.tf": "providers.tf.tmpl",
    "variables.tf": "variables.tf.tmpl",
    "main.tf": "main.tf.tmpl",
    "outputs.tf": "outputs.tf.tmpl",
    "terraform.tfvars.json": "terraform.tfvars.json.tmpl",
}


def deployment_path(deployments_dir: Path, cloud: str, name: str) -> Path:
    return deployments_dir / cloud / name


def render_deployment(
    *,
    repo_root: Path,
    deployments_dir: Path,
    config: WorkloadConfig,
) -> Deployment:
    target = deployment_path(deployments_dir, config.cloud, config.name)
    target.mkdir(parents=True, exist_ok=True)

    module_path = repo_root / "modules" / "multicloud" / "scheduled-batch-job"
    module_source = _module_source(target, module_path)
    tfvars_json = json.dumps(_tfvars(config), indent=2, sort_keys=True)
    values = {
        "module_source": module_source,
        "tfvars_json": tfvars_json,
    }

    for output_name, template_name in TEMPLATE_FILES.items():
        (target / output_name).write_text(
            render_template(template_name, values),
            encoding="utf-8",
        )

    return Deployment(path=target, module_source=module_source)


def list_deployments(deployments_dir: Path) -> list[Path]:
    if not deployments_dir.exists():
        return []
    return sorted(path for path in deployments_dir.glob("*/*") if path.is_dir())


def _module_source(target: Path, module_path: Path) -> str:
    return os.path.relpath(module_path.resolve(), target.resolve())


def _tfvars(config: WorkloadConfig) -> dict[str, object]:
    return {
        "cloud_provider": config.cloud,
        "name": config.name,
        "container_image": config.container_image,
        "container_command": config.container_command,
        "environment_variables": config.environment_variables,
        "schedule_expression": config.schedule_expression,
        "schedule_timezone": config.schedule_timezone,
        "tags": config.tags,
        "aws_region": config.aws_region,
        "aws_config": config.aws_config,
        "gcp_config": config.gcp_config,
        "azure_config": config.azure_config,
        "scheduler_input": config.scheduler_input,
        "enable_command_override_from_scheduler_input": config.enable_command_override_from_scheduler_input,
    }
