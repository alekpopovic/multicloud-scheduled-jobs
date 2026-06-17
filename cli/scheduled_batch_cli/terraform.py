from __future__ import annotations

import json
import shutil
import subprocess
from pathlib import Path
from typing import Any


class TerraformError(RuntimeError):
    pass


def terraform_binary() -> str | None:
    return shutil.which("terraform")


def require_terraform() -> str:
    binary = terraform_binary()
    if binary is None:
        raise TerraformError("terraform binary was not found in PATH.")
    return binary


def run_terraform(
    deployment_dir: Path,
    args: list[str],
    *,
    verbose: bool = False,
) -> subprocess.CompletedProcess[str]:
    binary = require_terraform()
    command = [binary, *args]
    if verbose:
        print(f"+ {' '.join(command)} (cwd={deployment_dir})")
    return subprocess.run(command, cwd=deployment_dir, check=True, text=True)


def init(deployment_dir: Path, *, verbose: bool = False) -> None:
    run_terraform(deployment_dir, ["init"], verbose=verbose)


def plan(deployment_dir: Path, *, verbose: bool = False) -> None:
    run_terraform(deployment_dir, ["plan", "-var-file=terraform.tfvars.json"], verbose=verbose)


def apply(deployment_dir: Path, *, auto_approve: bool, verbose: bool = False) -> None:
    args = ["apply", "-var-file=terraform.tfvars.json"]
    if auto_approve:
        args.append("-auto-approve")
    run_terraform(deployment_dir, args, verbose=verbose)


def destroy(deployment_dir: Path, *, auto_approve: bool, verbose: bool = False) -> None:
    args = ["destroy", "-var-file=terraform.tfvars.json"]
    if auto_approve:
        args.append("-auto-approve")
    run_terraform(deployment_dir, args, verbose=verbose)


def output_json(deployment_dir: Path, *, verbose: bool = False) -> dict[str, Any]:
    binary = require_terraform()
    command = [binary, "output", "-json"]
    if verbose:
        print(f"+ {' '.join(command)} (cwd={deployment_dir})")
    result = subprocess.run(
        command,
        cwd=deployment_dir,
        check=True,
        text=True,
        capture_output=True,
    )
    return json.loads(result.stdout or "{}")
