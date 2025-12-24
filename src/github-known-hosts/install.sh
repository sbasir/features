#!/bin/sh
set -e

# Ensure ssh-keyscan is available
apt-get install -y --no-install-recommends openssh-client

add_keys() {
  USERNAME="$1"
  USER_HOME="$2"

  echo "Adding GitHub SSH host keys to $USER_HOME/.ssh/known_hosts..."

  mkdir -p "$USER_HOME/.ssh"
  ssh-keyscan -t rsa,ecdsa,ed25519 github.com >>"$USER_HOME/.ssh/known_hosts"

  # Fix permissions only if user exists
  if id "$USERNAME" >/dev/null 2>&1; then
    chown -R "$USERNAME":"$USERNAME" "$USER_HOME/.ssh"
  fi

  echo "✅ GitHub host keys added for $USERNAME"
}

# Feature options (default true)
ADD_FOR_ROOT="${ADD_FORROOT:-$ADD_FOR_ROOT}"
ADD_FOR_REMOTE="${ADD_FORREMOTEUSER:-$ADD_FOR_REMOTEUSER}"

# Fallback defaults if env vars not set
ADD_FOR_ROOT="${ADD_FOR_ROOT:-true}"
ADD_FOR_REMOTE="${ADD_FOR_REMOTE:-true}"

REMOTE_USER="${USERNAME:-vscode}"
REMOTE_HOME=$(getent passwd "$REMOTE_USER" | cut -d: -f6)

# If remoteUser doesn't exist, skip it
if [ -z "$REMOTE_HOME" ]; then
  ADD_FOR_REMOTE="false"
fi

# Run installers
if [ "$ADD_FOR_ROOT" = "true" ]; then
  add_keys "root" "/root"
fi

if [ "$ADD_FOR_REMOTE" = "true" ]; then
  add_keys "$REMOTE_USER" "$REMOTE_HOME"
fi
