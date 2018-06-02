#!/bin/bash

. /etc/os-release

CARGO_BIN=${HOME}/.cargo/bin/cargo
DEBIAN_FRONTEND=noninteractive

installed() {
  dpkg-query -f '${binary:Package}\n' -W | grep -qe "^$1\(:amd64\)\?\$"
}

cargo_installed() {
  ${CARGO_BIN} install --list | grep -q "^${1}"
}

update_and_install() {
  sudo apt-get -qq update && sudo apt-get -qq install ${1}
}

sudo -v

for pkg in cmake gperf libfreetype6-dev libfontconfig1-dev libx11-xcb1 pkg-config xclip
do
  if ! installed ${pkg}; then
    echo "Installing ${pkg}..."
    sudo apt-get -qq install ${pkg}
  fi
done

if ! installed rcm; then
  echo "Installing rcm..."
  wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
  echo "deb http://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
  update_and_install rcm
fi

if [ ! -x ${CARGO_BIN} ]; then
  echo "Installing cargo..."
  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
  ${CARGO_BIN} search -q --limit=0
fi

if ! cargo_installed ripgrep; then
  echo "Installing ripgrep..."
  ${CARGO_BIN} install -fq ripgrep
fi

if ! cargo_installed alacritty; then
  echo "Installing alacritty..."
  ${CARGO_BIN} install -fq --git https://github.com/jwilm/alacritty
fi
