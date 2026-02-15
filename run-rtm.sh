#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${RTM_ENV_FILE:-$HOME/.config/cpuminer/rtm.env}"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

RTM_WALLET="${RTM_WALLET:-}"
RTM_POOL="${RTM_POOL:-stratum+tcp://pool.rplant.xyz:17029}"
RTM_PASSWORD="${RTM_PASSWORD:-x}"
RTM_THREADS="${RTM_THREADS:-$(nproc)}"
RTM_TUNE_CONFIG="${RTM_TUNE_CONFIG:-$SCRIPT_DIR/tune_config}"
RTM_NO_TUNE="${RTM_NO_TUNE:-1}"
RTM_FLAGS="${RTM_FLAGS:-}"

if [[ -z "$RTM_WALLET" || "$RTM_WALLET" == "REPLACE_WITH_YOUR_RTM_WALLET" ]]; then
  echo "RTM_WALLET is not configured. Edit $ENV_FILE and set your wallet."
  exit 1
fi

if [[ ! -x "$SCRIPT_DIR/cpuminer" ]]; then
  echo "Missing binary: $SCRIPT_DIR/cpuminer"
  echo "Build it with: cd $SCRIPT_DIR && ./build.sh"
  exit 1
fi

cmd=(
  "$SCRIPT_DIR/cpuminer"
  -a gr
  -o "$RTM_POOL"
  -u "$RTM_WALLET"
  -p "$RTM_PASSWORD"
  -t "$RTM_THREADS"
  --tune-config="$RTM_TUNE_CONFIG"
)

if [[ "$RTM_NO_TUNE" == "1" ]]; then
  cmd+=(--no-tune)
fi

if [[ -n "$RTM_FLAGS" ]]; then
  # Intentional shell splitting to support multiple flags from env.
  # shellcheck disable=SC2206
  extra_flags=( $RTM_FLAGS )
  cmd+=("${extra_flags[@]}")
fi

exec "${cmd[@]}"
