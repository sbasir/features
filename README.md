# sbasir/features

A collection of high‑quality, minimal, and reproducible Dev Container Features for personal and professional development environments.

These features are designed to be:

- Simple — no magic, no surprises
- Predictable — reproducible builds, no hidden dependencies
- User‑centric — everything runs as the correct remoteUser
- Composable — works cleanly with official Dev Container features
- Fast — minimal install footprint, no unnecessary packages

If you’re building devcontainers and want a clean, opinionated set of features that “just work,” this repo is for you.

---

## 📦 Available Features

### 1. ChezMoi Bootstrap (chezmoi/)

Installs chezmoi and optionally initializes a dotfiles repo for the remoteUser.

Highlights:

- Installs chezmoi into /usr/local/bin
- Supports shorthand (sbasir), user/repo, or full URLs
- Automatically rewrites GitHub SSH URLs → HTTPS (ensures reproducible builds without SSH keys)
- Runs chezmoi init as the correct user
- Fully compatible with nested git repos inside dotfiles

Example usage:

```jsonc
"features": {
  "ghcr.io/sbasir/features/chezmoi:1": {
    "repo": "sbasir",
    "apply": true
  }
}
```

### 2. GitHub Known Hosts (github-known-hosts/)

Adds GitHub’s SSH host keys to known_hosts for:

- root
- remoteUser
- or both (default)

Useful when you want SSH‑based Git operations inside the container without MITM warnings.

Example usage:

```jsonc
"features": {
  "ghcr.io/sbasir/features/github-known-hosts:1": {
    "addForRoot": true,
    "addForRemoteUser": true
  }
}
```

## 🧱 Structure

```
features/
  ├── src/
  │   ├── chezmoi/
  │   │   ├── devcontainer-feature.json
  │   │   ├── install.sh
  │   │   └── test.sh
  │   ├── github-known-hosts/
  │   │   ├── devcontainer-feature.json
  │   │   ├── install.sh
  │   │   └── test.sh
  └── README.md   ← you are here
```

Each feature is fully self‑contained and follows the official Dev Container Feature spec.

## 🚀 Using These Features

You can reference them directly from GitHub:

```jsonc
"features": {
  "ghcr.io/sbasir/features/chezmoi:1": {},
  "ghcr.io/sbasir/features/github-known-hosts:1": {}
}
```

Or pin to a specific version:

```jsonc
"features": {
  "ghcr.io/sbasir/features/chezmoi:1.0.1": {}
}
```

## 🛠️ Development

To build and test features locally:

```sh
devcontainer features test --all
```

To test a single feature:

```sh
devcontainer features test src/chezmoi
```

## 🤝 Contributing

This repo is primarily for personal use, but PRs that improve reliability, portability, or developer experience are welcome.

If you have ideas for new features or improvements, feel free to open an issue.

## 📄 License

MIT — do whatever you like, just don’t blame me if it breaks.
