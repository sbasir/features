
# GitHub Known Hosts (github-known-hosts)

Adds GitHub SSH host keys (RSA, ECDSA, ED25519) to root and/or remoteUser known_hosts

## Example Usage

```json
"features": {
    "ghcr.io/sbasir/features/github-known-hosts:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| addForRoot | Add GitHub host keys to /root/.ssh/known_hosts | boolean | true |
| addForRemoteUser | Add GitHub host keys to remoteUser's ~/.ssh/known_hosts | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sbasir/features/blob/main/src/github-known-hosts/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
