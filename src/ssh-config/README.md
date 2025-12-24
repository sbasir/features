
# SSH Client Config (ssh-config)

Configures SSH client settings such as StrictHostKeyChecking, UserKnownHostsFile, and custom Host blocks.

## Example Usage

```json
"features": {
    "ghcr.io/sbasir/features/ssh-config:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| strictHostKeyChecking | Value for StrictHostKeyChecking (yes|no|ask) | string | yes |
| userKnownHostsFile | Path for UserKnownHostsFile | string | - |
| addGithubBlock | Add a dedicated Host github.com block with relaxed settings | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sbasir/features/blob/main/src/ssh-config/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
