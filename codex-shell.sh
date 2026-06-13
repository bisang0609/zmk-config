#!/usr/bin/env bash

zmk_repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
zmk_codex_file="$zmk_repo_root/codex.md"
zmk_workspace_path="${ZMK_WORKSPACE:-$HOME/keyboard/tomak79.code-workspace}"

append_zmk_codex_progress() {
  local progress
  local timestamp

  if [ ! -f "$zmk_codex_file" ]; then
    echo "codex.md not found: $zmk_codex_file"
    return 1
  fi

  echo
  read -r -p "Progress note for codex.md: " progress
  [ -n "$progress" ] || progress="No progress note provided."
  timestamp="$(date '+%Y-%m-%d %H:%M:%S %Z')"

  {
    echo
    echo "- [$timestamp] $progress"
  } >> "$zmk_codex_file"
}

commit_and_push_repo() {
  local repo_dir="$1"
  local default_msg="$2"
  local commit_msg="$3"

  cd "$repo_dir" || return 1

  if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit in $repo_dir."
    return 0
  fi

  git status
  git add .
  git commit -m "${commit_msg:-$default_msg}" && git push
}

zmk_end() {
  local msg

  append_zmk_codex_progress || return

  echo
  read -r -p "Commit message: " msg

  commit_and_push_repo "$zmk_repo_root" "Update tomak79 config" "$msg"
}

zmk() {
  case "$1" in
    start)
      if [ -f "$zmk_codex_file" ]; then
        echo "== $zmk_codex_file =="
        cat "$zmk_codex_file"
        echo
      fi

      cd "$zmk_repo_root" || return
      git pull

      if command -v code >/dev/null 2>&1; then
        code "$zmk_workspace_path"
      else
        echo "'code' command not found. Skipping VS Code launch."
      fi
      ;;

    end)
      zmk_end
      ;;

    status)
      cd "$zmk_repo_root" || return
      git status
      ;;

    pull)
      cd "$zmk_repo_root" || return
      git pull
      ;;

    *)
      echo "Usage:"
      echo "  zmk start   # show codex.md + git pull + open VSCode workspace"
      echo "  zmk end     # append codex note + commit + push"
      echo "  zmk status  # show git status"
      echo "  zmk pull    # git pull only"
      ;;
  esac
}

end() {
  zmk_end
}

alias start='zmk start'
