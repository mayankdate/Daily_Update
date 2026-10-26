"""Print every column of each Notion database your connection can see.

Run it, paste your Notion integration token when asked, press Enter.
The column list prints to the terminal and is also copied to your clipboard.
"""

import json
import subprocess
import sys
from urllib.request import Request, urlopen

NOTION_VERSION = "2026-03-11"


def notion(token, method, endpoint, payload=None):
    body = json.dumps(payload).encode("utf-8") if payload is not None else None
    request = Request(
        "https://api.notion.com/v1/" + endpoint,
        data=body,
        method=method,
        headers={
            "Authorization": "Bearer " + token,
            "Notion-Version": NOTION_VERSION,
            "Content-Type": "application/json",
        },
    )
    with urlopen(request, timeout=30) as response:
        return json.load(response)


def find_data_sources(token):
    sources, cursor = [], None
    while True:
        payload = {"filter": {"property": "object", "value": "data_source"}, "page_size": 100}
        if cursor:
            payload["start_cursor"] = cursor
        response = notion(token, "POST", "search", payload)
        sources.extend(response["results"])
        if not response["has_more"]:
            return sources
        cursor = response["next_cursor"]


def title_text(items):
    return "".join(item["plain_text"] for item in items or []) or "Untitled"


def describe(source):
    lines = [title_text(source.get("title")), "data source id: " + source["id"], ""]
    for name, column in sorted(source["properties"].items(), key=lambda pair: pair[0].casefold()):
        kind = column["type"]
        details = column[kind]
        lines.append(f"  {name}  [{kind}]  id={column['id']}")
        if kind in {"status", "select", "multi_select"}:
            lines.append("    options: " + ", ".join(option["name"] for option in details["options"]))
        elif kind == "formula":
            lines.append("    formula: " + details["expression"])
        elif kind == "relation":
            lines.append("    related data source: " + details["data_source_id"])
    lines.append("")
    return lines


def copy_to_clipboard(text):
    command = {
        "darwin": ["pbcopy"],
        "win32": ["clip"],
        "linux": ["xclip", "-selection", "clipboard"],
    }[sys.platform]
    subprocess.run(command, input=text.encode("utf-8"), check=True)


def main():
    token = input("Paste your Notion token and press Enter: ").strip()
    sources = find_data_sources(token)
    output = "\n".join(line for source in sources for line in describe(source))
    print("\n" + output)
    copy_to_clipboard(output)
    print(f"{len(sources)} database(s) found. Copied to clipboard.")


if __name__ == "__main__":
    main()