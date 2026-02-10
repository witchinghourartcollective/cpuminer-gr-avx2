#!/usr/bin/env bash
set -euo pipefail

WALLET="${RTM_WALLET:-}"
POOL="${RTM_POOL:-stratum+tcp://pool.rplant.xyz:17029}"
THREADS="${RTM_THREADS:-$(nproc)}"
LOG="${RTM_LOG:-/home/fletchervaughn/cpuminer-gr-avx2/miner.log}"

if [ -z "$WALLET" ]; then
  echo "RTM_WALLET is not set. Example:"
  echo "  RTM_WALLET=R... $0"
  exit 1
fi

cd /home/fletchervaughn/cpuminer-gr-avx2
nohup ./cpuminer -a gr -o "$POOL" -u "$WALLET" -t "$THREADS" > "$LOG" 2>&1 &
echo "Started cpuminer. Log: $LOG"
