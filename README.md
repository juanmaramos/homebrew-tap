# homebrew-tap
Homebrew casks for Juanma Ramos projects

## Notex

[Notex](https://notex-swart.vercel.app/) is a native Mac app for notes, meeting
transcription, and summaries. Requires macOS 26 or later; supports Apple Silicon
and Intel.

```sh
brew install --cask juanmaramos/tap/notex
```

This adds the tap and installs the signed, Apple-notarized app into Applications.
After the first install, you can also use the short name `notex`.

Notex includes its own updater. To update through Homebrew instead:

```sh
brew update
brew upgrade --cask --greedy notex
```

`brew uninstall --cask notex` removes the app and keeps your notes and settings.
The cask deliberately has no `zap` rule to delete your library.

### Release maintenance

[Update Notex](https://github.com/juanmaramos/homebrew-tap/actions/workflows/update-notex.yml)
checks the public `juanmaramos/notex-releases` repository hourly and can also be
run manually after a release. GitHub may delay scheduled runs. It pins the stable
version's DMG URL and GitHub-computed SHA-256, then commits only the cask when a
newer release exists. It rejects drafts, prereleases, missing checksums, downgrades,
and checksum changes to an already published version.

The workflow uses this repository's built-in `GITHUB_TOKEN`; no personal token,
private source access, or additional secrets are needed. Public repositories'
scheduled workflows can be disabled after 60 days without repository activity;
re-enable the workflow in Actions if that happens. To check or refresh manually:

```sh
python3 -m unittest discover -s tests
gh api repos/juanmaramos/notex-releases/releases/latest | python3 scripts/update_notex.py
brew livecheck --cask juanmaramos/tap/notex
```
