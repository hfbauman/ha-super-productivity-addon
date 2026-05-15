#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"
WEBDAV_CONFIG="/tmp/webdav.json"
WEBDAV_DATA_DIR="/data/webdav"

option_value() {
  key="$1"
  default="$2"

  if [ -r "$OPTIONS_FILE" ]; then
    value="$(jq -r --arg key "$key" --arg default "$default" '.[$key] // $default' "$OPTIONS_FILE")"
  else
    value="$default"
  fi

  if [ "$value" = "null" ]; then
    printf '%s' "$default"
  else
    printf '%s' "$value"
  fi
}

WEBDAV_USER="$(option_value username alice)"
WEBDAV_PASS="$(option_value password alicepassword)"
SYNC_BASE_URL="$(option_value sync_base_url /webdav/)"
SYNC_FOLDER_PATH="$(option_value sync_folder_path /)"
SYNC_INTERVAL_MINUTES="$(option_value sync_interval_minutes 15)"
SYNC_COMPRESSION="$(option_value sync_compression true)"
SYNC_ENCRYPTION="$(option_value sync_encryption false)"

mkdir -p "$WEBDAV_DATA_DIR"

jq -n \
  --arg username "$WEBDAV_USER" \
  --arg password "$WEBDAV_PASS" \
  --arg directory "$WEBDAV_DATA_DIR" \
  '{
    address: "127.0.0.1",
    port: 6065,
    prefix: "/",
    directory: $directory,
    permissions: "CRUD",
    cors: {
      enabled: true,
      credentials: true,
      allowed_hosts: ["*"],
      allowed_headers: ["Authorization", "Content-Type", "Depth", "Destination", "If", "Lock-Token", "Overwrite", "TimeOut", "Translate"],
      allowed_methods: ["COPY", "DELETE", "GET", "HEAD", "LOCK", "UNLOCK", "MKCOL", "MOVE", "OPTIONS", "POST", "PROPFIND", "PROPPATCH", "PUT"]
    },
    users: [
      {
        username: $username,
        password: $password,
        directory: $directory,
        permissions: "CRUD"
      }
    ]
  }' > "$WEBDAV_CONFIG"

export WEBDAV_BACKEND="http://127.0.0.1:6065"
export WEBDAV_BASE_URL="$SYNC_BASE_URL"
export WEBDAV_USERNAME="$WEBDAV_USER"
export WEBDAV_SYNC_FOLDER_PATH="$SYNC_FOLDER_PATH"
export SYNC_INTERVAL="$SYNC_INTERVAL_MINUTES"
export IS_COMPRESSION_ENABLED="$SYNC_COMPRESSION"
export IS_ENCRYPTION_ENABLED="$SYNC_ENCRYPTION"

/usr/local/bin/webdav --config "$WEBDAV_CONFIG" &
WEBDAV_PID="$!"

cleanup() {
  if [ -n "${APP_PID:-}" ]; then
    kill "$APP_PID" 2>/dev/null || true
  fi
  kill "$WEBDAV_PID" 2>/dev/null || true
  wait "$WEBDAV_PID" 2>/dev/null || true
}

trap 'cleanup; exit 0' INT TERM

/usr/local/bin/docker-entrypoint.sh &
APP_PID="$!"
wait "$APP_PID"
APP_STATUS="$?"
cleanup
exit "$APP_STATUS"
