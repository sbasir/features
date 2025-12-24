#!/bin/bash
set -e

TARGET_USER="${_REMOTE_USER:-vscode}"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

echo "[test] Checking chezmoi installation..."
command -v chezmoi >/dev/null

if [ -n "${REPO:-}" ]; then
  echo "[test] Checking chezmoi state directory..."
  if [ ! -d "$TARGET_HOME/.local/share/chezmoi" ]; then
    echo "❌ chezmoi state directory missing"
    exit 1
  fi
fi

echo "✅ All tests passed."
