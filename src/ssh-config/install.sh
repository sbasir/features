#!/bin/sh
set -e

apt-get update -y
apt-get install -y --no-install-recommends openssh-client

TARGET_USER="${USERNAME:-vscode}"
USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

if [ -z "$USER_HOME" ]; then
  TARGET_USER="root"
  USER_HOME="/root"
fi

mkdir -p "$USER_HOME/.ssh"
CONFIG_FILE="$USER_HOME/.ssh/config"

# Read options
STRICT="${STRICTHOSTKEYCHECKING:-}"
USER_KNOWN="${USERKNOWNHOSTSFILE:-}"
ADD_GH="${ADDGITHUBBLOCK:-true}"

# Determine default known_hosts path
if [ -z "$USER_KNOWN" ]; then
  USER_KNOWN="$USER_HOME/.ssh/known_hosts"
fi

echo "Configuring SSH client for $TARGET_USER..."

{
  echo "Host *"

  if [ -n "$STRICT" ]; then
    echo "    StrictHostKeyChecking $STRICT"
  fi

  if [ -n "$USER_KNOWN" ]; then
    echo "    UserKnownHostsFile $USER_KNOWN"
  fi
} >>"$CONFIG_FILE"

if [ "$ADD_GH" = "true" ]; then
  cat <<EOF >>"$CONFIG_FILE"

Host github.com
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
fi

chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.ssh"
chmod 600 "$CONFIG_FILE"

echo "SSH client configuration applied."
