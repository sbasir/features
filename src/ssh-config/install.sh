#!/bin/sh
set -e

# Ensure SSH client exists
apt-get update -y
apt-get install -y --no-install-recommends openssh-client

# Resolve target user
TARGET_USER="${USERNAME:-vscode}"
USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

if [ -z "$USER_HOME" ]; then
  TARGET_USER="root"
  USER_HOME="/root"
fi

mkdir -p "$USER_HOME/.ssh"
CONFIG_FILE="$USER_HOME/.ssh/config"

# Read feature options
STRICT="${STRICTHOSTKEYCHECKING:-no}"
KNOWN="${USERKNOWNHOSTSFILE:-/dev/null}"
ADD_GH="${ADDGITHUBBLOCK:-true}"

echo "Configuring SSH client for $TARGET_USER..."

# Global Host * block
cat <<EOF >>"$CONFIG_FILE"
Host *
    StrictHostKeyChecking $STRICT
    UserKnownHostsFile $KNOWN
EOF

# Optional GitHub block
if [ "$ADD_GH" = "true" ]; then
  cat <<EOF >>"$CONFIG_FILE"

Host github.com
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
fi

# Permissions
chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.ssh"
chmod 600 "$CONFIG_FILE"

echo "SSH client configuration applied."
