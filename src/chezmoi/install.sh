#!/bin/sh
set -e

# Feature options
REPO="${REPO:-}"
APPLY="${APPLY:-true}"

# Resolve remoteUser from common-utils
TARGET_USER="${_REMOTE_USER:-vscode}"

echo "[chezmoi] Installing chezmoi into /usr/local/bin..."

# Install chezmoi (your logic, but targeting /usr/local/bin)
if ! command -v chezmoi >/dev/null 2>&1; then
  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL get.chezmoi.io)" -- -b /usr/local/bin
  elif command -v wget >/dev/null 2>&1; then
    sh -c "$(wget -qO- get.chezmoi.io)" -- -b /usr/local/bin
  else
    echo "[chezmoi] ERROR: curl or wget required." >&2
    exit 1
  fi
fi

CHEZMOI_BIN="$(command -v chezmoi)"

echo "[chezmoi] Installed: $($CHEZMOI_BIN --version)"

# If no repo provided, stop here
if [ -z "$REPO" ]; then
  echo "[chezmoi] No repo provided. Skipping init."
  exit 0
fi

# Normalize repo input
# Cases:
#   "user"        → pass through (chezmoi expands automatically)
#   "user/repo"     → convert to https://github.com/user/repo.git
#   full URL        → use as-is
if printf "%s" "$REPO" | grep -qE '^https?://'; then
  REPO_URL="$REPO"
elif printf "%s" "$REPO" | grep -q '/'; then
  REPO_URL="https://github.com/$REPO.git"
else
  REPO_URL="$REPO"
fi

echo "[chezmoi] Initializing repo: $REPO_URL"

# Force GitHub SSH → HTTPS rewrite (critical fix)
su "$TARGET_USER" -c "
  git config --global url.\"https://github.com/\".insteadOf \"git@github.com:\"
"

INIT_CMD="$CHEZMOI_BIN init"
[ "$APPLY" = "true" ] && INIT_CMD="$INIT_CMD --apply"
INIT_CMD="$INIT_CMD '$REPO_URL'"

# Run as remoteUser (no login shell, no env reset)
su "$TARGET_USER" -c "
  export PATH=/usr/local/bin:/usr/bin:/bin;
  $INIT_CMD
"

echo "[chezmoi] Init complete for $TARGET_USER"
