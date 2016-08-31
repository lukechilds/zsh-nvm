ZSH_NVM_DIR=${0:a:h}

[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

_zsh_nvm_rename_function() {
  test -n "$(declare -f $1)" || return
  eval "${_/$1/$2}"
  unset -f $1
}

_zsh_nvm_has() {
  type "$1" > /dev/null 2>&1
}

_zsh_nvm_latest_release_tag() {
  echo $(cd "$NVM_DIR" && git fetch --quiet origin && git describe --abbrev=0 --tags --match "v[0-9]*" origin)
}

_zsh_nvm_install() {
  echo "Installing nvm..."
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  $(cd "$NVM_DIR" && git checkout --quiet "$(_zsh_nvm_latest_release_tag)")
}

_zsh_nvm_global_binaries() {
  echo "$NVM_DIR"/v0*/bin/*(N) "$NVM_DIR"/versions/*/*/bin/*(N) |
    xargs -n 1 basename |
    sort |
    uniq
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

_zsh_nvm_lazy_load() {

  # Get all global node module binaries (including node)
  local global_binaries
  global_binaries=($(_zsh_nvm_global_binaries))

  # Add nvm
  global_binaries+=('nvm')

  # Create function for each command
  for cmd in $global_binaries; do

    # When called, unset all lazy loaders, load nvm then run current command
    eval "$cmd(){
      unset -f $global_binaries
      _zsh_nvm_load
      $cmd \"\$@\"
    }"
  done
}

nvm_update() {
  echo 'Deprecated, please use `nvm upgrade`'
}
_zsh_nvm_upgrade() {

  # Use default upgrade if it's built in
  if [[ -n "$(_zsh_nvm_nvm help | grep 'nvm upgrade')" ]]; then
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
  if [[ -n "$previous_version" ]]; then
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

# If nvm is installed
if [[ -f "$NVM_DIR/nvm.sh" ]]; then

  # Load it
  [[ "$NVM_LAZY_LOAD" == true ]] && _zsh_nvm_lazy_load || _zsh_nvm_load
fi
