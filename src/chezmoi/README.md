
# ChezMoi Bootstrap (chezmoi)

Installs chezmoi and optionally initializes a dotfiles repo for the remoteUser.

## Example Usage

```json
"features": {
    "ghcr.io/sbasir/features/chezmoi:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| repo | Optional chezmoi repo to init (e.g. 'user', 'user/repo', or full URL). If empty, init is skipped. | string | - |
| apply | Run 'chezmoi init --apply' instead of just 'init'. | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sbasir/features/blob/main/src/chezmoi/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
