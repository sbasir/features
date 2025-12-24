#!/bin/bash
set -e

TARGET_USER="${USERNAME:-vscode}"
USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

if [ -z "$USER_HOME" ]; then
  TARGET_USER="root"
  USER_HOME="/root"
fi

CONFIG_FILE="$USER_HOME/.ssh/config"

echo "Running tests for ssh-config feature..."

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ SSH config file not found at $CONFIG_FILE"
  exit 1
fi

if ! grep -q "StrictHostKeyChecking" "$CONFIG_FILE"; then
  echo "❌ StrictHostKeyChecking not found in SSH config"
  exit 1
fi

if ! grep -q "UserKnownHostsFile" "$CONFIG_FILE"; then
  echo "❌ UserKnownHostsFile not found in SSH config"
  exit 1
fi

echo
