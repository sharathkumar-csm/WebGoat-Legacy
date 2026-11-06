#!/bin/sh
set -eu

# Host-side gate/auth requests use the runner's loopback address. Inside Docker
# Desktop, the same IQ service is reached through host.docker.internal instead.
# Keep AGP_OIDC_AUDIENCE unchanged: it must match IQ's configured base URL.
case "${AGP_API_URL:-}" in
  http://127.0.0.1:*)
    export AGP_API_URL="http://host.docker.internal:${AGP_API_URL#http://127.0.0.1:}"
    ;;
  http://localhost:*)
    export AGP_API_URL="http://host.docker.internal:${AGP_API_URL#http://localhost:}"
    ;;
esac

# Preserve the vendor's workspace preparation and switch to non-root uid 10000.
exec /entrypoint.sh "$@"
