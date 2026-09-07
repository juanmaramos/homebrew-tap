import importlib.util
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location("update_notex", Path(__file__).resolve().parents[1] / "scripts/update_notex.py")
updater = importlib.util.module_from_spec(spec)
spec.loader.exec_module(updater)


class UpdateNotexTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.path = Path(directory.name) / "notex.rb"
        self.original = 'cask "notex" do\n  version "0.1.3"\n  sha256 "' + "a" * 64 + '"\n  app "Notex.app"\nend\n'
        self.path.write_text(self.original)
        self.release = {
            "tag_name": "v0.1.4", "draft": False, "prerelease": False,
            "assets": [{"name": "Notex.dmg", "state": "uploaded", "digest": "sha256:" + "b" * 64,
                        "browser_download_url": "https://github.com/juanmaramos/notex-releases/releases/download/v0.1.4/Notex.dmg"}],
        }

    def test_updates_version_and_checksum_and_is_idempotent(self):
        self.assertTrue(updater.update_cask(self.path, self.release))
        self.assertEqual(self.path.read_text(), self.original.replace('"0.1.3"', '"0.1.4"').replace("a" * 64, "b" * 64))
        self.assertFalse(updater.update_cask(self.path, self.release))

    def test_compares_versions_numerically(self):
        self.path.write_text(self.original.replace('"0.1.3"', '"0.1.9"'))
        self.release["tag_name"] = "v0.1.10"
        self.release["assets"][0]["browser_download_url"] = self.release["assets"][0]["browser_download_url"].replace("v0.1.4", "v0.1.10")
        self.assertTrue(updater.update_cask(self.path, self.release))

    def assert_rejected(self):
        before = self.path.read_text()
        with self.assertRaises(ValueError):
            updater.update_cask(self.path, self.release)
        self.assertEqual(self.path.read_text(), before)

    def test_rejects_draft_prerelease_and_invalid_tags(self):
        for field, value in [("draft", True), ("prerelease", True), ("tag_name", "v0.2.0-beta"), ("tag_name", 'v0.2.0"; system("bad")')]:
            with self.subTest(field=field, value=value):
                original = self.release[field]
                self.release[field] = value
                self.assert_rejected()
                self.release[field] = original

    def test_rejects_incomplete_or_unexpected_assets(self):
        for field, value in [("name", "Other.dmg"), ("state", "new"), ("digest", None), ("digest", "sha256:bad"), ("browser_download_url", "https://example.com/Notex.dmg")]:
            with self.subTest(field=field):
                original = self.release["assets"][0][field]
                self.release["assets"][0][field] = value
                self.assert_rejected()
                self.release["assets"][0][field] = original
        self.release["assets"].append(self.release["assets"][0].copy())
        self.assert_rejected()

    def test_rejects_downgrades_and_changed_published_checksums(self):
        for version in ["0.1.5", "0.1.4"]:
            with self.subTest(version=version):
                self.path.write_text(self.original.replace('"0.1.3"', f'"{version}"'))
                self.assert_rejected()


if __name__ == "__main__":
    unittest.main()
