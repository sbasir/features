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

# 1. Config file must exist
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ SSH config file not found at $CONFIG_FILE"
  exit 1
fi

# 2. Host * block must exist
if ! grep -q "^Host \*$" "$CONFIG_FILE"; then
  echo "❌ Missing 'Host *' block"
  exit 1
fi

# 3. StrictHostKeyChecking should appear only if non-empty
if [ -n "$STRICTHOSTKEYCHECKING" ]; then
  if ! grep -q "StrictHostKeyChecking $STRICTHOSTKEYCHECKING" "$CONFIG_FILE"; then
    echo "❌ StrictHostKeyChecking not set correctly"
    exit 1
  fi
else
  if grep -q "StrictHostKeyChecking" "$CONFIG_FILE"; then
    echo "❌ StrictHostKeyChecking should NOT be present when empty"
    exit 1
  fi
fi

# 4. UserKnownHostsFile should appear only if non-empty
if [ -n "$USERKNOWNHOSTSFILE" ]; then
  if ! grep -q "UserKnownHostsFile $USERKNOWNHOSTSFILE" "$CONFIG_FILE"; then
    echo "❌ UserKnownHostsFile not set correctly"
    exit 1
  fi
else
  # default path
  DEFAULT_KNOWN="$USER_HOME/.ssh/known_hosts"
  if ! grep -q "UserKnownHostsFile $DEFAULT_KNOWN" "$CONFIG_FILE"; then
    echo "❌ Default UserKnownHostsFile not set correctly"
    exit 1
  fi
fi

# 5. GitHub block should appear only if enabled
if [ "$ADDGITHUBBLOCK" = "true" ] || [ -z "$ADDGITHUBBLOCK" ]; then
  if ! grep -q "^Host github.com$" "$CONFIG_FILE"; then
    echo "❌ GitHub block missing"
    exit 1
  fi
else
  if grep -q "^Host github.com$" "$CONFIG_FILE"; then
    echo "❌ GitHub block should NOT be present"
    exit 1
  fi
fi

echo "✅ SSH config feature tests passed."
