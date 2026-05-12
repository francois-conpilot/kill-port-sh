#!/bin/sh
# Kill process(es) listening on or using the given TCP/UDP port (macOS: lsof).
set -eu

usage() {
	echo "usage: kill_port <port>" >&2
	exit 1
}

port="${1:-}"
[ -n "$port" ] || usage

case "$port" in
*[!0-9]*) echo "kill_port: invalid port: $port" >&2; exit 1 ;;
esac

pids=$(lsof -ti ":$port" 2>/dev/null || true)
if [ -z "$pids" ]; then
	echo "kill_port: nothing using port $port"
	exit 0
fi

for pid in $pids; do
	if kill -TERM "$pid" 2>/dev/null; then
		:
	else
		kill -KILL "$pid" 2>/dev/null || true
	fi
done

# Give processes a moment to exit after SIGTERM
sleep 0.2
still=$(lsof -ti ":$port" 2>/dev/null || true)
if [ -n "$still" ]; then
	for pid in $still; do
		kill -KILL "$pid" 2>/dev/null || true
	done
fi

echo "kill_port: freed port $port (was PIDs: $pids)"
