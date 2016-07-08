[[ -z "$NVM_DIR" ]] && NVM_DIR="$HOME/.nvm"

_zsh_nvm_has() {
  type "$1" > /dev/null 2>&1
}

_zsh_nvm_get() {
  if _zsh_nvm_has "curl"; then
    curl --silent "$1"
  elif _zsh_nvm_has "wget"; then
    wget --quiet --output-document - "$1"
  fi
}

_zsh_nvm_latest_release_tag() {
  _zsh_nvm_get "https://api.github.com/repos/creationix/nvm/releases/latest" |  # Get latest release from GitHub api
    grep '"tag_name":' |                                                        # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                                # Pluck JSON value
}

_zsh_nvm_install() {
  echo "Installing nvm..."
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  $(cd "$NVM_DIR" && git checkout --quiet "$(_zsh_nvm_latest_release_tag)")
}

nvm_update() {
  local installed_version=$(cd "$NVM_DIR" && git describe --tags)
  echo "Installed version is $installed_version"
  echo "Checking latest version of nvm..."
  local latest_version=$(_zsh_nvm_latest_release_tag)
  if [[ "$installed_version" = "$latest_version" ]]; then
    echo "You're already up to date"
  else
    echo "Updating to $latest_version..."
    $(cd "$NVM_DIR" && git fetch && git checkout "$latest_version")
  fi
}

# Install nvm if it isn't already installed
[[ ! -f "$NVM_DIR/nvm.sh" ]] && _zsh_nvm_install

# If nvm is installed, source it
[[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
