# zmk-config workflow

## Shell setup

Clone `zmk` and `zmk-config` as sibling directories, then register the helper once:

```bash
bash /path/to/zmk-config/codex-shell.sh install-shell
```

Open a new shell and use:

```bash
zmk start
zmk status
zmk end
zmk pull
```

## Notes

- The default VS Code workspace is `../tomak79.code-workspace` relative to `zmk-config`.
- The default VS Code workspace is `tomak79.code-workspace` inside `zmk-config`.
- Override the workspace path with `ZMK_WORKSPACE=/path/to/workspace.code-workspace`.
- The workspace file uses relative `git.ignoredRepositories` entries so it works on different machines and clone paths.
