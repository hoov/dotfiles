#!/bin/bash

# vim: et:ts=2:sts=2:sw=2

. /etc/os-release

CARGO_BIN=${HOME}/.cargo/bin/cargo
DEBIAN_FRONTEND=noninteractive
SCRATCH=$(mktemp -d -t tmp.XXXXXXXXXX)

function finish() {
  rm -rf ${SCRATCH}
}

trap finish EXIT

info() {
  echo "[INFO] ${1}"
}

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

# [FIXME] Figure out rate limiting
get_github_latest_release() {
  http "https://api.github.com/repos/${1}/releases/latest" | jq -r .tag_name
}

get_github_download_url() {
  http "https://api.github.com/repos/${1}/releases/latest" | \
    jq -r ".assets[] | select(.name | test(\"${2}\")) | .browser_download_url"
}

sudo -v

# This has been tested with Debian *buster* on WSL
pkgs=(cmake
      apt-transport-https
      aspell
      ca-certificates
      curl
      fish
      fontconfig
      fonts-powerline
      fzf
      gettext-base
      gnupg2
      gperf
      imagemagick
      jq
      kitty
      libfontconfig1-dev
      libfreetype6-dev
      libx11-xcb1
      libxcb-xfixes0-dev
      libxcursor1
      libxi6
      libxrandr2
      locate
      lsb-release
      lsof
      lua-nvim
      man-db
      ncurses-term
      neovim
      net-tools
      pkg-config
      psmisc
      python
      python-dev
      python-neovim
      python-pip
      python3
      python3-dev
      python3-neovim
      python3-pip
      ruby-neovim
      software-properties-common
      strace
      telnet
      tmux
      tree
      universal-ctags
      wamerican-large
      wget
      x11-xserver-utils
      x11-utils
      xclip)

for pkg in "${pkgs[@]}"
do
  if ! apt_installed ${pkg}; then
    info "Installing ${pkg}..."
    sudo apt-get -qq install ${pkg}
  fi
done

if ! apt_installed rcm; then
  info "Installing rcm..."
  wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
  echo "deb http://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
  update_and_install rcm
fi

# On WSL, don't index Windows drives
if [ ! -f /etc/updatedb.findutils.cron.local ]; then
  info "Configuring updatedb to ignore Windows drives..."
  echo 'PRUNEPATHS="$PRUNEPATHS /mnt/c /mnt/d /mnt/e"' | sudo tee /etc/updatedb.findutils.cron.local > /dev/null
fi

# RCM is handling python dependencies
info "Syncing dotfiles"
rcup -d .

# We haven't switched shells yet, so let's modify the path to include Python binaries that just got installed
export PATH=${HOME}/.local/bin:${PATH}

if [ ! -x ${CARGO_BIN} ]; then
  info "Installing cargo..."
  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
  ${CARGO_BIN} search -q --limit=0
fi

if ! cargo_installed ripgrep; then
  info "Installing ripgrep..."
  ${CARGO_BIN} install -fq ripgrep
fi

if ! cargo_installed cargo-deb; then
  info "Installing cargo-deb..."
  ${CARGO_BIN} install -fq cargo-deb
fi

# alacritty doesn't install from git anymore
#  if ! cargo_installed alacritty; then
#   info "Installing alacritty..."
#   ${CARGO_BIN} install -fq --git https://github.com/jwilm/alacritty
# fi

HUB_RELEASE_URL=https://api.github.com/repos/github/hub/releases/latest
LATEST_HUB_VERSION=$(http ${HUB_RELEASE_URL} | jq -r .tag_name)

function install_latest_hub() {
  HUB_URL=$(http ${HUB_RELEASE_URL} | \
            jq -r '.assets[] | select(.name | test("linux-amd64")) | .browser_download_url')
  wget -qO - ${HUB_URL} | tar zx -C ${SCRATCH}
  HUB_DIR_NAME=${HUB_URL##*/}
  HUB_DIR_NAME=${HUB_DIR_NAME%.*}
  prefix=${HOME}/.local ${SCRATCH}/${HUB_DIR_NAME}/install
  sudo cp ${SCRATCH}/${HUB_DIR_NAME}/etc/hub.fish_completion /usr/share/fish/vendor_completions.d/hub.fish
}

if ! bin_installed hub; then
  info "Installing hub (${LATEST_HUB_VERSION})..."
  install_latest_hub
else
  INSTALLED_HUB_VERSION=v$(hub --version | grep hub | cut -d" " -f3)

  if [ "${INSTALLED_HUB_VERSION}" != "${LATEST_HUB_VERSION}" ]; then
    info "Upgrading hub (${INSTALLED_HUB_VERSION} -> ${LATEST_HUB_VERSION})"

    install_latest_hub
  fi
fi

# Docker is lacking support for iptables with nf_tables backend
if [ "buster" == "${VERSION_CODENAME}" ]; then
  sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
fi

if ! bin_installed docker; then
  info "Installing docker"
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${VERSION_CODENAME} stable"
  sudo apt-get -qq update
  sudo apt-get -qq install docker-ce docker-ce-cli containerd.io
fi

LATEST_DOCKER_COMPOSE_VERSION=$(get_github_latest_release docker/compose)

# FIXME: We should abstract this to a function and upgrade like we do with DSF
if ! bin_installed docker-compose; then
  info "Installing docker-compose (${LATEST_DOCKER_COMPOSE_VERSION})..."
  curl -sL https://github.com/docker/compose/releases/download/${LATEST_DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o ${HOME}/.local/bin/docker-compose
  chmod +x ${HOME}/.local/bin/docker-compose
fi

LATEST_DSF_VERSION=$(get_github_latest_release so-fancy/diff-so-fancy)
if ! bin_installed diff-so-fancy; then
  info "Installing diff-so-fancy (${LATEST_DSF_VERSION})..."
  wget -qP ${HOME}/.local/bin https://raw.githubusercontent.com/so-fancy/diff-so-fancy/${LATEST_DSF_VERSION}/third_party/build_fatpack/diff-so-fancy
  chmod +x ${HOME}/.local/bin/diff-so-fancy
else
  INSTALLED_DSF_VERSION=v$(diff-so-fancy --version 2>&1 >/dev/null | sed -nE 's|Version\W+(.*)$|\1|p')

  if [ "${INSTALLED_DSF_VERSION}" != "${LATEST_DSF_VERSION}" ]; then
    info "Upgrading diff-so-fancy (${INSTALLED_DSF_VERSION} -> ${LATEST_DSF_VERSION})"
    wget -qP ${HOME}/.local/bin https://raw.githubusercontent.com/so-fancy/diff-so-fancy/${LATEST_DSF_VERSION}/third_party/build_fatpack/diff-so-fancy
    chmod +x ${HOME}/.local/bin/diff-so-fancy
  fi
fi

if grep -qi microsoft /proc/version; then
  info "Setting up WSL specific functionality..."
  mkdir -p ${HOME}/.local/share/fonts

  info "Syncing Windows fonts..."
  find /mnt/c/Windows/Fonts -type f -iname "*.ttf" -o -iname "*.TTF" -o -iname "*.otf" | while read FONT
  do
    ln -sf "${FONT}" ${HOME}/.local/share/fonts/
  done
  fc-cache -f

  LATEST_WSLU_VERSION=$(get_github_latest_release wslutilities/wslu)
  LATEST_WSLU_URL=$(get_github_download_url wslutilities/wslu deb)
  LATEST_WSLU_PKG=$(basename "${LATEST_WSLU_URL}")
  # [FIXME] Upgrade package here
  if ! apt_installed wslu; then
    info "Installing wslu (${LATEST_WSLU_VERSION})..."
    wget -qP ${SCRATCH} ${LATEST_WSLU_URL}
    sudo dpkg -i "${SCRATCH}/${LATEST_WSLU_PKG}" > /dev/null
  fi
fi
