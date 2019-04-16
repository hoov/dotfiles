#!/bin/bash

. /etc/os-release

CARGO_BIN=${HOME}/.cargo/bin/cargo
DEBIAN_FRONTEND=noninteractive
SCRATCH=$(mktemp -d -t tmp.XXXXXXXXXX)

function finish() {
  rm -rf ${SCRATCH}
}

trap finish EXIT

apt_installed() {
  dpkg-query -f '${binary:Package}\n' -W | grep -qe "^$1\(:amd64\)\?\$"
}

cargo_installed() {
  ${CARGO_BIN} install --list | grep -q "^${1}"
}

bin_installed() {
 command -v ${1} >/dev/null 2>&1
}

update_and_install() {
  sudo apt-get -qq update && sudo apt-get -qq install ${1}
}

sudo -v

pkgs=(cmake
      curl
      gettext-base
      gperf
      jq
      libfreetype6-dev
      libfontconfig1-dev
      libx11-xcb1
      pkg-config
      python
      python-dev
      python3
      python3-dev
      xclip)

for pkg in "${pkgs[@]}"
do
  if ! apt_installed ${pkg}; then
    echo "Installing ${pkg}..."
    sudo apt-get -qq install ${pkg}
  fi
done

if ! apt_installed rcm; then
  echo "Installing rcm..."
  wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
  echo "deb http://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
  update_and_install rcm
fi

# RCM is handling python dependencies
echo "Syncing dotfiles"
rcup -d .

# We haven't switched shells yet, so let's modify the path to include Python binaries that just got installed
export PATH=${HOME}/.local/bin:${PATH}

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

HUB_RELEASE_URL=https://api.github.com/repos/github/hub/releases/latest
LATEST_HUB_VERSION=$(http ${HUB_RELEASE_URL} | jq -r .tag_name)

function install_latest_hub() {
  HUB_URL=$(http ${HUB_RELEASE_URL} | \
            jq -r '.assets[] | select(.name | test("linux-amd64")) | .browser_download_url')
  wget -qO - ${HUB_URL} | tar zx -C ${SCRATCH}
  HUB_DIR_NAME=${HUB_URL##*/}
  HUB_DIR_NAME=${HUB_DIR_NAME%.*}
  prefix=${HOME}/.local ${SCRATCH}/${HUB_DIR_NAME}/install
}

if ! bin_installed hub; then
  echo "Installing hub (${LATEST_HUB_VERSION})..."
  install_latest_hub
else
  INSTALLED_HUB_VERSION=v$(hub --version | grep hub | cut -d" " -f3)

  if [ "${INSTALLED_HUB_VERSION}" != "${LATEST_HUB_VERSION}" ]; then
    echo "Upgrading hub (${INSTALLED_HUB_VERSION} -> ${LATEST_HUB_VERSION})"

    install_latest_hub
  fi
fi

DSF_RELEASE_URL=https://api.github.com/repos/so-fancy/diff-so-fancy/releases/latest
LATEST_DSF_VERSION=$(http ${DSF_RELEASE_URL} | jq -r .tag_name)
if ! bin_installed diff-so-fancy; then
  echo "Installing diff-so-fancy (${LATEST_DSF_VERSION})..."
  wget -qP ${HOME}/.local/bin https://raw.githubusercontent.com/so-fancy/diff-so-fancy/${LATEST_DSF_VERSION}/third_party/build_fatpack/diff-so-fancy
  chmod +x ${HOME}/.local/bin/diff-so-fancy
else
  INSTALLED_DSF_VERSION=v$(diff-so-fancy --version 2>&1 >/dev/null | sed -nE 's|Version\W+(.*)$|\1|p')

  if [ "${INSTALLED_DSF_VERSION}" != "${LATEST_DSF_VERSION}" ]; then
    echo "Upgrading diff-so-fancy (${INSTALLED_DSF_VERSION} -> ${LATEST_DSF_VERSION})"
    wget -qP ${HOME}/.local/bin https://raw.githubusercontent.com/so-fancy/diff-so-fancy/${LATEST_DSF_VERSION}/third_party/build_fatpack/diff-so-fancy
    chmod +x ${HOME}/.local/bin/diff-so-fancy
  fi
fi
