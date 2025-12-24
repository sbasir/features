#!/bin/sh
set -e

# Detect the remoteUser from environment or default to vscode
TARGET_USER="${USERNAME:-vscode}"
USER_HOME=$(eval echo "~$TARGET_USER")

echo "Adding GitHub SSH host keys to $USER_HOME/.ssh/known_hosts..."

mkdir -p "$USER_HOME/.ssh"
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >>"$USER_HOME/.ssh/known_hosts"

# Ensure correct ownership
chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.ssh"

echo "✅ GitHub host keys added for $TARGET_USER"
