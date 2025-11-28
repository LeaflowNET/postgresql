#!/bin/bash
set -euo pipefail

# non-interactive apt
export DEBIAN_FRONTEND=noninteractive

apt-get update

# Packages we want to install (extensions named per-postgresql-major)
packages=(
    "wget"
    "gnupg"
    "dirmngr"
    "apt-transport-https"
    "postgresql-${PG_MAJOR}-timescaledb"
    "postgresql-${PG_MAJOR}-age"
    "postgresql-${PG_MAJOR}-pgvector"
    "timescaledb-toolkit-postgresql-${PG_MAJOR}"
)

# Install; if packages don't exist this will fail and print helpful debug info
if ! apt-get install -y --no-install-recommends "${packages[@]}"; then
    echo "apt-get install failed; showing apt-cache policy for debugging:" >&2
    for pkg in "${packages[@]}"; do
        echo "--- $pkg ---" >&2
        apt-cache policy "$pkg" || true
    done
    exit 1
fi

# Final cleanup
apt-get autoremove -y --purge || true
apt-get clean || true
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "setup.sh: installed extensions for PostgreSQL ${PG_MAJOR} and cleaned helpers" >&2
