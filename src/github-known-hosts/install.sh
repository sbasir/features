#!/bin/sh
set -e

# Ensure ssh-keyscan is available
apt-get update -y
apt-get install -y --no-install-recommends openssh-client

TARGET_USER="${USERNAME:-vscode}"
# Resolve home directory safely
USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
# Fallback to root if user not found

if [ -z "$USER_HOME" ]; then
  TARGET_USER="root"
  USER_HOME="/root"
fi

echo "Adding GitHub SSH host keys to $USER_HOME/.ssh/known_hosts..."

mkdir -p "$USER_HOME/.ssh"
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >>"$USER_HOME/.ssh/known_hosts"
chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.ssh"

echo "✅ GitHub host keys added for $TARGET_USER"
