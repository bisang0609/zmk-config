# Temporary Patch Instructions

Read this file and make the current machine behave like the home PC for the `zmk` workspace.

Goal:
- On the company PC, running `zmk start` should result in Codex seeing the same project status and instructions that come from `zmk-config/codex.md`.
- This file is temporary and may be deleted after the environment is fixed.

Workspace layout to expect:
- `~/keyboard/zmk`
- `~/keyboard/zmk-config`

Important context:
- Codex reads repository instructions from `~/keyboard/zmk/AGENTS.md`, not directly from `codex.md`.
- In this workflow, `~/keyboard/zmk-config/codex.md` is the source of truth.
- `~/keyboard/zmk/AGENTS.md` must be regenerated from `~/keyboard/zmk-config/codex.md`.
- `zmk start` is expected to pull both repos and sync `AGENTS.md`.

What to do:
1. Inspect `~/keyboard/zmk-config/codex-shell.sh`.
2. Make sure it uses `zmk-config` as the config repo root and sibling `../zmk` as the actual working repo root.
3. Make sure it can regenerate `~/keyboard/zmk/AGENTS.md` from `~/keyboard/zmk-config/codex.md`.
4. Make sure `zmk start` and `zmk pull` both run that sync step automatically.
5. If shell init is missing, install it into the active shell RC file.
6. Run the sync and verify that `AGENTS.md` contains the latest contents from `codex.md`.

Expected commands to check or use:
- `bash ~/keyboard/zmk-config/codex-shell.sh install-shell`
- `bash ~/keyboard/zmk-config/codex-shell.sh sync-agents`
- `zmk start`
- `sed -n '1,40p' ~/keyboard/zmk/AGENTS.md`

Success condition:
- `zmk start` works on this PC.
- `~/keyboard/zmk/AGENTS.md` is freshly generated from `~/keyboard/zmk-config/codex.md`.
- A new Codex session opened in `~/keyboard/zmk` sees the same current project instructions and status as the home PC.

Do not:
- Do not change firmware code unless required for this environment fix.
- Do not revert unrelated user changes.
- Do not keep this file after the environment is confirmed working.
