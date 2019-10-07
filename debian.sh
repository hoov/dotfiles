#!/bin/bash

# vim: et:ts=2:sts=2:sw=2

. /etc/os-release

CARGO_BIN=${HOME}/.cargo/bin/cargo
DEBIAN_FRONTEND=noninteractive
SCRATCH=$(mktemp -d -t tmp.XXXXXXXXXX)

function finish() {
  rm -rf "${SCRATCH}"
}

trap finish EXIT

info() {
  echo "[INFO] ${1}"
}

apt_installed() {
  dpkg-query -f '${binary:Package}\n' -W | grep -qe "^$1\\(:amd64\\)\\?\$"
}

cargo_installed() {
  ${CARGO_BIN} install --list | grep -q "^${1}"
}

bin_installed() {
 command -v "${1}" >/dev/null 2>&1
}

update_and_install() {
  sudo apt-get -qq update
  sudo DEBIAN_FRONTEND=$DEBIAN_FRONTEND apt-get -qq install "${1}" > /dev/null
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
install_system_packages() {
  local -a packages
  packages=(cmake
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
        libbz2-dev
        libffi-dev
        libfontconfig1-dev
        libfreetype6-dev
        libreadline-dev
        libssl-dev
        libsqlite3-dev
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
        shellcheck
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

  for package in "${packages[@]}"
  do
    # I know we could do this in bulk, but I kind of want to see the diff. We'll do the right thing later.
    if ! apt_installed "${package}"; then
      info "Installing ${package}..."
      sudo DEBIAN_FRONTEND=$DEBIAN_FRONTEND apt-get -qq install "${package}" > /dev/null
    fi
  done
}

install_rcm() {
  if ! apt_installed rcm; then
    info "Installing rcm..."
    wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
    echo "deb http://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
    update_and_install rcm
  fi
}

disable_indexing_windows_drives() {
  # On WSL, don't index Windows drives
  if [ ! -f /etc/updatedb.findutils.cron.local ]; then
    info "Configuring updatedb to ignore Windows drives..."
    # shellcheck disable=SC2016
    echo 'PRUNEPATHS="$PRUNEPATHS /mnt/c /mnt/d /mnt/e"' | sudo tee /etc/updatedb.findutils.cron.local > /dev/null
  fi
}

sync_dotfiles() {
  # RCM is handling python dependencies
  info "Syncing dotfiles"
  rcup -d .
}

# We're going to be tossing a bunch of stuff into ${HOME}/.local/bin/
export PATH=${HOME}/.local/bin:${PATH}

install_cargo() {
  if [ ! -x "${CARGO_BIN}" ]; then
    info "Installing cargo..."
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
    ${CARGO_BIN} search -q --limit=0
  fi
}

install_cargo_packages() {
  local -a packages
  packages=(cargo-deb \
            ripgrep \
            starship \
            # alacritty doesn't install from git anymore
            # alacritty \
            )

  for package in "${packages[@]}"
  do
    if ! cargo_installed "${package}"; then
      info "Installing ${package}..."
      ${CARGO_BIN} install -fq "${package}"
    fi
  done
}

install_latest_hub() {
  local -r hub_release_url=https://api.github.com/repos/github/hub/releases/latest
  local -r latest_hub_version=$(http ${hub_release_url} | jq -r .tag_name)

  if ! bin_installed hub; then
    info "Installing hub (${latest_hub_version})..."
  else
    local -r installed_hub_version=v$(hub --version | grep hub | cut -d" " -f3)

    if [ "${installed_hub_version}" != "${latest_hub_version}" ]; then
      info "Upgrading hub (${installed_hub_version} -> ${latest_hub_version})"
    else
      return 0
    fi
  fi
  local -r hub_url=$(http ${hub_release_url} | \
                     jq -r '.assets[] | select(.name | test("linux-amd64")) | .browser_download_url')
  wget -qO - "${hub_url}" | tar zx -C "${SCRATCH}"
  local hub_dir_name=${hub_url##*/}
  hub_dir_name=${hub_dir_name%.*}
  prefix=${HOME}/.local "${SCRATCH}/${hub_dir_name}/install"
  # We could also toss this in ${HOME}/.config/fish/completions/, but this is where packages tend to toss things
  sudo cp "${SCRATCH}/${hub_dir_name}/etc/hub.fish_completion" /usr/share/fish/vendor_completions.d/hub.fish
}

install_system_packages
install_rcm
disable_indexing_windows_drives
sync_dotfiles
install_cargo
install_cargo_packages
install_latest_hub

# Docker is lacking support for iptables with nf_tables backend
if [ "buster" == "${VERSION_CODENAME}" ]; then
  sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
fi

if ! bin_installed docker; then
  info "Installing docker"
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${VERSION_CODENAME} stable"
  sudo apt-get -qq update > /dev/null
  sudo apt-get -qq install docker-ce docker-ce-cli containerd.io > /dev/null
  sudo usermod -aG docker "${USER}"
fi

LATEST_DOCKER_COMPOSE_VERSION=$(get_github_latest_release docker/compose)

# FIXME: We should abstract this to a function and upgrade like we do with DSF
if ! bin_installed docker-compose; then
  info "Installing docker-compose (${LATEST_DOCKER_COMPOSE_VERSION})..."
  curl -sL "https://github.com/docker/compose/releases/download/${LATEST_DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o "${HOME}/.local/bin/docker-compose"
  chmod +x "${HOME}/.local/bin/docker-compose"
fi

install_diff_tools() {
  local -r latest_dsf_version=$(get_github_latest_release so-fancy/diff-so-fancy)
  local -r latest_dsf_url="https://raw.githubusercontent.com/so-fancy/diff-so-fancy/${latest_dsf_version}/third_party/build_fatpack/diff-so-fancy"

  if ! bin_installed diff-so-fancy; then
    info "Installing diff-so-fancy (${latest_dsf_version})..."
    wget -qP "${HOME}/.local/bin" "${latest_dsf_url}"
    chmod +x "${HOME}/.local/bin/diff-so-fancy"
  else
    installed_dsf_version=v$(diff-so-fancy --version 2>&1 >/dev/null | sed -nE 's|Version\W+(.*)$|\1|p')
    if [ "${installed_dsf_version}" != "${latest_dsf_version}" ]; then
      info "Upgrading diff-so-fancy (${installed_dsf_version} -> ${latest_dsf_version})"
      wget -qP "${HOME}/.local/bin" "${latest_dsf_url}"
      chmod +x "${HOME}/.local/bin/diff-so-fancy"
    fi
  fi

  if ! bin_installed diff-highlight; then
    info "Installing diff-highlight"
    cp -r /usr/share/doc/git/contrib/diff-highlight "${SCRATCH}"
    make -s -C "${SCRATCH}/diff-highlight"
    cp "${SCRATCH}/diff-highlight/diff-highlight" "${HOME}/.local/bin"
  fi
}

install_diff_tools

if grep -qi microsoft /proc/version; then
  info "Setting up WSL specific functionality..."
  mkdir -p "${HOME}/.local/share/fonts"

  info "Syncing Windows fonts..."
  find /mnt/c/Windows/Fonts -type f -iname "*.ttf" -o -iname "*.TTF" -o -iname "*.otf" | while read -r FONT
  do
    ln -sf "${FONT}" "${HOME}/.local/share/fonts/"
  done
  fc-cache -f

  LATEST_WSLU_VERSION=$(get_github_latest_release wslutilities/wslu)
  LATEST_WSLU_URL=$(get_github_download_url wslutilities/wslu deb)
  LATEST_WSLU_PKG=$(basename "${LATEST_WSLU_URL}")
  # [FIXME] Upgrade package here
  if ! apt_installed wslu; then
    info "Installing wslu (${LATEST_WSLU_VERSION})..."
    wget -qP "${SCRATCH}" "${LATEST_WSLU_URL}"
    sudo dpkg -i "${SCRATCH}/${LATEST_WSLU_PKG}" > /dev/null
  fi
fi
