#!/usr/bin/env bash
# Start the XFCE desktop and stream it with Selkies on port 8080.
# Selkies listens on loopback only and has no login of its own: access goes through the Codespaces
# forwarded port, which is private to the codespace owner. Keep that port's visibility Private.
set -euo pipefail
PORT=8080
LOG=/tmp/selkies-session.log

if ! command -v selkies-session >/dev/null; then
  echo "Selkies is not installed yet. Run: bash .devcontainer/install-desktop.sh"
  exit 0
fi
if pgrep -f 'selkies-session' >/dev/null; then
  echo "Desktop is already running on port ${PORT}."
  exit 0
fi

setsid nohup selkies-session --session=xfce --port="${PORT}" --enable-basic-auth=false \
  >"$LOG" 2>&1 </dev/null &

# Wait until Selkies is listening before returning. The dev container CLI closes this command's
# terminal the moment the script exits, which kills a session that has not finished detaching yet.
for _ in $(seq 1 60); do
  if (exec 3<>"/dev/tcp/127.0.0.1/${PORT}") 2>/dev/null; then
    echo "Desktop is ready on port ${PORT} (log: $LOG)."
    exit 0
  fi
  sleep 0.5
done
echo "Desktop did not come up within 30s; see $LOG."
