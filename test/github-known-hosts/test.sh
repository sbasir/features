#!/bin/bash
set -e

TARGET_USER="${USERNAME:-vscode}"

# Resolve home directory safely
USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

# Fallback to root if user not found
if [ -z "$USER_HOME" ]; then
  TARGET_USER="root"
  USER_HOME="/root"
fi

echo "Running tests for github-known-hosts feature..."
echo "Checking $USER_HOME/.ssh/known_hosts..."

if [ ! -f "$USER_HOME/.ssh/known_hosts" ]; then
  echo "❌ known_hosts file not found in $USER_HOME/.ssh"
  exit 1
fi

if ! grep -q "github.com" "$USER_HOME/.ssh/known_hosts"; then
  echo "❌ github.com entry not found in known_hosts"
  exit 1
fi

echo "✅ Tests passed: github.com host keys present in $USER_HOME/.ssh/known_hosts"
