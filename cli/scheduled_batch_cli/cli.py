from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from .config import (
    DEFAULT_CONFIG_PATH,
    DEFAULT_PROFILE,
    SUPPORTED_CLOUDS,
    build_workload_config,
    load_config,
    write_example_config,
)
from .deployment import deployment_path, list_deployments, render_deployment
from .terraform import TerraformError, apply, destroy, init, output_json, plan, terraform_binary
from .validators import validate_cloud, validate_repo_root, validate_workload


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    try:
        return int(args.func(args) or 0)
    except (OSError, ValueError, TerraformError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="scheduled-batch")
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG_PATH)
    parser.add_argument("--repo-root", type=Path, default=None)
    parser.add_argument("--deployments-dir", type=Path, default=Path("deployments"))
    parser.add_argument("--profile", default=DEFAULT_PROFILE)
    parser.add_argument("--verbose", action="store_true")

    subparsers = parser.add_subparsers(required=True)

    init_config_parser = subparsers.add_parser("init-config")
    init_config_parser.set_defaults(func=cmd_init_config)

    for command_name, func in {
        "create": cmd_create,
        "plan": cmd_plan,
        "render": cmd_render,
    }.items():
        command_parser = subparsers.add_parser(command_name)
        add_workload_args(command_parser)
        if command_name == "create":
            command_parser.add_argument("--yes", action="store_true")
        command_parser.set_defaults(func=func)

    destroy_parser = subparsers.add_parser("destroy")
    add_workload_args(destroy_parser)
    destroy_parser.add_argument("--yes", action="store_true")
    destroy_parser.set_defaults(func=cmd_destroy)

    outputs_parser = subparsers.add_parser("outputs")
    add_workload_args(outputs_parser)
    outputs_parser.set_defaults(func=cmd_outputs)

    list_parser = subparsers.add_parser("list")
    list_parser.set_defaults(func=cmd_list)

    doctor_parser = subparsers.add_parser("doctor")
    doctor_parser.add_argument("--cloud", choices=SUPPORTED_CLOUDS)
    doctor_parser.set_defaults(func=cmd_doctor)

    return parser


def add_workload_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--cloud", required=True, choices=SUPPORTED_CLOUDS)
    parser.add_argument("--name", required=True)


def cmd_init_config(args: argparse.Namespace) -> int:
    created = write_example_config(args.config.expanduser())
    if created:
        print(f"Created config: {args.config.expanduser()}")
    else:
        print(f"Config already exists: {args.config.expanduser()}")
    return 0


def cmd_render(args: argparse.Namespace) -> int:
    deployment = render_from_args(args)
    print(deployment.path)
    return 0


def cmd_plan(args: argparse.Namespace) -> int:
    deployment = render_from_args(args)
    init(deployment.path, verbose=args.verbose)
    plan(deployment.path, verbose=args.verbose)
    return 0


def cmd_create(args: argparse.Namespace) -> int:
    deployment = render_from_args(args)
    init(deployment.path, verbose=args.verbose)
    apply(deployment.path, auto_approve=args.yes, verbose=args.verbose)
    return 0


def cmd_destroy(args: argparse.Namespace) -> int:
    validate_cloud(args.cloud)
    target = deployment_path(args.deployments_dir, args.cloud, args.name)
    if not target.is_dir():
        raise ValueError(f"Deployment directory does not exist: {target}")
    destroy(target, auto_approve=args.yes, verbose=args.verbose)
    return 0


def cmd_outputs(args: argparse.Namespace) -> int:
    validate_cloud(args.cloud)
    target = deployment_path(args.deployments_dir, args.cloud, args.name)
    if not target.is_dir():
        raise ValueError(f"Deployment directory does not exist: {target}")
    print(json.dumps(output_json(target, verbose=args.verbose), indent=2, sort_keys=True))
    return 0


def cmd_list(args: argparse.Namespace) -> int:
    for path in list_deployments(args.deployments_dir):
        print(path)
    return 0


def cmd_doctor(args: argparse.Namespace) -> int:
    repo_root = resolve_repo_root(args.repo_root)
    deployments_dir = args.deployments_dir.resolve()
    config_path = args.config.expanduser()

    print(f"terraform: {terraform_binary() or 'not found'}")
    print(f"repo_root: {repo_root}")
    print(f"modules: {repo_root / 'modules' / 'multicloud' / 'scheduled-batch-job'}")
    print(f"config: {config_path} ({'exists' if config_path.exists() else 'missing'})")
    print(f"deployments_dir: {deployments_dir}")

    validate_repo_root(repo_root)
    if args.cloud:
        if not config_path.exists():
            raise ValueError(f"Config file does not exist: {config_path}")
        config = load_config(config_path)
        workload = build_workload_config(
            config,
            profile=args.profile,
            cloud=args.cloud,
            name="doctor",
        )
        validate_workload(workload)
        print(f"{args.cloud}: config valid")
    return 0


def render_from_args(args: argparse.Namespace):
    repo_root = resolve_repo_root(args.repo_root)
    validate_repo_root(repo_root)

    config_path = args.config.expanduser()
    config = load_config(config_path)
    workload = build_workload_config(
        config,
        profile=args.profile,
        cloud=args.cloud,
        name=args.name,
    )
    validate_workload(workload)
    return render_deployment(
        repo_root=repo_root,
        deployments_dir=args.deployments_dir,
        config=workload,
    )


def resolve_repo_root(repo_root: Path | None) -> Path:
    if repo_root is not None:
        return repo_root.resolve()

    current = Path.cwd().resolve()
    for candidate in [current, *current.parents]:
        if (candidate / "modules" / "multicloud" / "scheduled-batch-job").is_dir():
            return candidate
    return current
