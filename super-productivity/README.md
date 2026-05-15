# Home Assistant Super Productivity Add-on

This add-on runs [Super Productivity](https://github.com/johannesjo/super-productivity) inside Home Assistant with built-in WebDAV sync support.

## Installation

1. In Home Assistant, go to **Settings > Add-ons**.
2. Click on the three dots in the top-right and select **Repositories**.
3. Add this repository URL: https://github.com/hfbauman/ha-super-productivity-addon
4. Find **Super Productivity** in the add-on store, install it, and start the service.

## Configuration

You can configure the built-in WebDAV sync endpoint in the add-on options.

| Option | Default | Description |
| --- | --- | --- |
| `username` | `alice` | WebDAV username for Super Productivity sync. |
| `password` | `alicepassword` | WebDAV password for Super Productivity sync. |
| `sync_base_url` | `/webdav/` | Same-origin WebDAV URL proxied through the add-on ingress. |
| `sync_folder_path` | `/` | Folder used by Super Productivity inside the WebDAV share. |
| `sync_interval_minutes` | `15` | Built-in sync interval in minutes. |
| `sync_compression` | `true` | Enables Super Productivity sync compression. |
| `sync_encryption` | `false` | Prefills the Super Productivity encryption toggle. |

The add-on starts a local WebDAV server and exposes it through `/webdav/`.
Super Productivity's sync dialog is prefilled with the URL and username from
these options. Use the same password from the add-on options when the app asks
for the WebDAV password.

## Access

- **Super Productivity UI:** open the add-on through Home Assistant Ingress.
- **WebDAV:** `/webdav/` through the same add-on ingress session.
