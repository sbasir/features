#!/bin/bash
set -e

echo "Running tests for github-known-hosts feature..."

check_user() {
  local USERNAME="$1"
  local HOME_DIR="$2"

  echo "Checking $HOME_DIR/.ssh/known_hosts for $USERNAME..."

  if [ ! -f "$HOME_DIR/.ssh/known_hosts" ]; then
    echo "❌ known_hosts file not found for $USERNAME"
    exit 1
  fi

  if ! grep -q "github.com" "$HOME_DIR/.ssh/known_hosts"; then
    echo "❌ github.com entry missing for $USERNAME"
    exit 1
  fi

  echo "✅ Passed for $USERNAME"
}

# Test root if enabled
if [ "${ADD_FOR_ROOT:-true}" = "true" ]; then
  check_user "root" "/root"
fi

# Test remoteUser if enabled
REMOTE_USER="${USERNAME:-vscode}"
REMOTE_HOME=$(getent passwd "$REMOTE_USER" | cut -d: -f6)

if [ "${ADD_FOR_REMOTEUSER:-true}" = "true" ] && [ -n "$REMOTE_HOME" ]; then
  check_user "$REMOTE_USER" "$REMOTE_HOME"
fi

echo "🎉 All tests passed!"
