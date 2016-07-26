ZSH_NVM_DIR=${0:a:h}

[[ -z "$NVM_DIR" ]] && NVM_DIR="$HOME/.nvm"

_zsh_nvm_rename_function() {
  test -n "$(declare -f $1)" || return
  eval "${_/$1/$2}"
  unset -f $1
}

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

_zsh_nvm_load() {

  # Source nvm
  source "$NVM_DIR/nvm.sh"

  # Rename main nvm function
  _zsh_nvm_rename_function nvm _zsh_nvm_nvm

  # Wrap nvm in our own function
  nvm() {
    case $1 in
      'upgrade')
        _zsh_nvm_upgrade
        ;;
      'revert')
        _zsh_nvm_revert
        ;;
      *)
        _zsh_nvm_nvm "$@"
        ;;
    esac
  }
}

nvm_update() {
  echo 'Deprecated, please use `nvm upgrade`'
}
_zsh_nvm_upgrade() {

  # Use default upgrade if it's built in
  if [[ "$(_zsh_nvm_nvm help | grep 'nvm upgrade')" ]]; then
    _zsh_nvm_nvm upgrade
    return
  fi

  # Otherwise use our own
  local installed_version=$(cd "$NVM_DIR" && git describe --tags)
  echo "Installed version is $installed_version"
  echo "Checking latest version of nvm..."
  local latest_version=$(_zsh_nvm_latest_release_tag)
  if [[ "$installed_version" = "$latest_version" ]]; then
    echo "You're already up to date"
  else
    echo "Updating to $latest_version..."
    echo "$installed_version" > "$ZSH_NVM_DIR/previous_version"
    $(cd "$NVM_DIR" && git fetch --quiet && git checkout "$latest_version")
    _zsh_nvm_load
  fi
}

_zsh_nvm_previous_version() {
  cat "$ZSH_NVM_DIR/previous_version" 2>/dev/null
}

_zsh_nvm_revert() {
  local previous_version="$(_zsh_nvm_previous_version)"
  if [[ $previous_version ]]; then
    local installed_version=$(cd "$NVM_DIR" && git describe --tags)
    if [[ "$installed_version" = "$previous_version" ]]; then
      echo "Already reverted to $installed_version"
      return
    fi
    echo "Installed version is $installed_version"
    echo "Reverting to $previous_version..."
    $(cd "$NVM_DIR" && git checkout "$previous_version")
    _zsh_nvm_load
  else
    echo "No previous version found"
  fi
}

# Install nvm if it isn't already installed
[[ ! -f "$NVM_DIR/nvm.sh" ]] && _zsh_nvm_install

# If nvm is installed, load it
[[ -f "$NVM_DIR/nvm.sh" ]] && _zsh_nvm_load
