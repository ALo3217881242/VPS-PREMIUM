#!/usr/bin/env bash
# Ubuntu desktop for Codespaces: XFCE streamed by Selkies (H.264 over one WebSocket port, decoded with WebCodecs in the browser).
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
SELKIES_VERSION="${SELKIES_VERSION:-2.0.0}"

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  xfce4 xfce4-terminal xvfb dbus-x11 x11-xserver-utils xdg-utils \
  pulseaudio curl ca-certificates wget git-lfs xubuntu-wallpapers

# Selkies native package from the project's GitHub release, matched to this Ubuntu version.
. /etc/os-release
PKG="selkies-${SELKIES_VERSION}-ubuntu${VERSION_ID}-$(dpkg --print-architecture).deb"
curl -fsSL -o "/tmp/${PKG}" "https://github.com/selkies-project/selkies/releases/download/${SELKIES_VERSION}/${PKG}"
sudo apt-get install -y "/tmp/${PKG}"
rm -f "/tmp/${PKG}"

# Firefox and fonts.
bash "$(dirname "$0")/install-browser.sh"
