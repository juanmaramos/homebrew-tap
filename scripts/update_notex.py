"""Update the cask from GitHub's latest public release metadata on stdin."""

import json
from pathlib import Path
import re
import sys


def update_cask(path, release):
    tag = release["tag_name"]
    if release["draft"] or release["prerelease"] or not re.fullmatch(r"v\d+\.\d+\.\d+", tag):
        raise ValueError("Expected a public stable vX.Y.Z release")

    assets = [asset for asset in release["assets"] if asset["name"] == "Notex.dmg"]
    if len(assets) != 1:
        raise ValueError("Expected exactly one Notex.dmg asset")
    asset = assets[0]
    expected_url = f"https://github.com/juanmaramos/notex-releases/releases/download/{tag}/Notex.dmg"
    if asset["state"] != "uploaded" or asset["browser_download_url"] != expected_url:
        raise ValueError("Expected the uploaded DMG at its versioned official URL")
    digest = asset.get("digest") or ""
    if not re.fullmatch(r"sha256:[0-9a-f]{64}", digest):
        raise ValueError("Expected GitHub's SHA-256 digest for Notex.dmg")

    current = path.read_text()
    version_match = re.search(r'^  version "(\d+\.\d+\.\d+)"$', current, re.MULTILINE)
    checksum_match = re.search(r'^  sha256 "([0-9a-f]{64})"$', current, re.MULTILINE)
    if not version_match or not checksum_match:
        raise ValueError("Expected a versioned cask with a SHA-256 checksum")
    version = tag[1:]
    checksum = digest.removeprefix("sha256:")
    if tuple(map(int, version.split("."))) < tuple(map(int, version_match[1].split("."))):
        raise ValueError("Refusing to downgrade the cask")
    if version == version_match[1]:
        if checksum != checksum_match[1]:
            raise ValueError("The published release checksum changed; inspect it manually")
        return False

    updated = current.replace(version_match[0], f'  version "{version}"', 1)
    updated = updated.replace(checksum_match[0], f'  sha256 "{checksum}"', 1)
    path.write_text(updated)
    return True


if __name__ == "__main__":
    cask = Path(__file__).resolve().parents[1] / "Casks/notex.rb"
    changed = update_cask(cask, json.load(sys.stdin))
    print("Updated Notex cask" if changed else "Notex cask is current")
