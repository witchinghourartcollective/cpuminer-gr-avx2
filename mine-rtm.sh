#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG="${RTM_LOG:-$SCRIPT_DIR/miner.log}"

nohup "$SCRIPT_DIR/run-rtm.sh" > "$LOG" 2>&1 &
echo "Started cpuminer. Log: $LOG"
