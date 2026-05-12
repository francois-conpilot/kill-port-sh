# kill_port

Small shell helper to free a TCP/UDP port by terminating the process(es) using it. Handy when a dev server (e.g. Flask on `5000`) did not shut down cleanly.

**Platform:** macOS (uses `lsof`).

## Requirements

- `sh` (POSIX shell)
- `lsof` (ships with macOS)

## Install

Clone the repo, then put the script somewhere on your `PATH` and make it executable:

```bash
chmod +x kill_port
cp kill_port ~/.local/bin/   # or ~/bin, /usr/local/bin, etc.
```

Ensure that directory is on your PATH (e.g. in ~/.zshrc):

```
export PATH="$HOME/.local/bin:$PATH"
```

## Usage

```
kill_port <port>
```

- If nothing is using the port, it prints a short message and exits successfully.
- It sends SIGTERM first, waits briefly, then SIGKILL for anything still bound to the port.
