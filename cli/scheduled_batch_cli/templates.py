from __future__ import annotations

from importlib import resources


def render_template(name: str, values: dict[str, str]) -> str:
    template = resources.files(__package__).joinpath("templates", name).read_text(encoding="utf-8")
    rendered = template
    for key, value in values.items():
        rendered = rendered.replace("${" + key + "}", value)
    return rendered
