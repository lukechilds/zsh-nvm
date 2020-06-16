# zsh-nvm [![Build Status](https://travis-ci.org/lukechilds/zsh-nvm.svg?branch=master)](https://travis-ci.org/lukechilds/zsh-nvm)

> Zsh plugin for installing, updating and loading `nvm`

[`nvm`](https://github.com/nvm-sh/nvm) is an awesome tool but it can be kind of a pain to install and keep up to date. This zsh plugin allows you to quickly setup `nvm` once, save it in your dotfiles, then never worry about it again.

The plugin will install the latest stable release of `nvm` if you don't already have it, and then automatically `source` it for you. You can upgrade `nvm` to the latest version whenever you want without losing your installed `node` versions by running `nvm upgrade`.

Although this is written as a zsh plugin, it also works with bash if you follow the [manual installation instructions](#manually).

## Usage

Once the plugin's installed `nvm` will be available. You'll probably want to load this as one of your first plugins so `node`/`npm` is available for any other plugins that may require them.

`zsh-nvm` also wraps `nvm` in some additional functionality.

### Upgrade

If you want to upgrade to the latest release of `nvm`:

```shell
% nvm upgrade
Installed version is v0.31.0
Checking latest version of nvm...
Updating to v0.31.3...
Previous HEAD position was 2176894... v0.31.0
HEAD is now at 56417f8... v0.31.3
```

### Revert

If an upgrade breaks something don't worry, reverting back to the previously installed version is simple:

```shell
% nvm revert
Installed version is v0.31.3
Reverting to v0.31.0...
Previous HEAD position was 56417f8... v0.31.3
HEAD is now at 2176894... v0.31.0
```

### Install

You can install the latest Node.js nightlies or release candidates with `nvm install nightly|rc`. Aliases will automatically be created so you can easily `nvm use nightly|rc` in the future:

```
% nvm install rc
Downloading and installing node v8.0.0-rc.1...
Downloading https://nodejs.org/download/rc//v8.0.0-rc.1/node-v8.0.0-rc.1-darwin-x64.tar.xz...
######################################################################## 100.0%
Computing checksum with shasum -a 256
Checksums matched!
Now using node v8.0.0-rc.1 (npm v5.0.0-beta.56)
rc -> v8.0.0-rc.1
Clearing mirror cache...
Done!
```

> **Note:** This is a bit of a hack and leaving rc|nightly versions installed may break nvm when it eventually supports them itself. It's recommended that you don't leave the these versions of Node.js installed. Install them, test/play with them and then uninstall them when you're done.

## Options

### Custom Directory

You can specify a custom directory to use with `nvm` by exporting the `NVM_DIR` environment variable. It must be set before `zsh-nvm` is loaded.

For example, if you are using antigen, you would put the following in your `.zshrc`:

```shell
export NVM_DIR="$HOME/.custom-nvm-dir"
antigen bundle lukechilds/zsh-nvm
```

Note: If `nvm` doesn't exist in this directory it'll be automatically installed when you start a session.

### Nvm Completion

`nvm` comes with a default bash_completion profile. If you want to enable it, you can do it by exporting  the `NVM_COMPLETION` environment variable and setting it to `true`. It must be set before `zsh-nvm` is loaded.

For example, if you are using antigen, you would put the following in your `.zshrc`:

```bash
# Export nvm completion settings for zsh-nvm plugin
export NVM_COMPLETION=true
antigen bundle lukechilds/zsh-nvm
```

### Lazy Loading

If you find `nvm` adds too much lag to your shell startup you can enable lazy loading by exporting the `NVM_LAZY_LOAD` environment variable and setting it to `true`. It must be set before `zsh-nvm` is loaded.

Lazy loading is around 70x faster (874ms down to 12ms for me), however the first time you run `nvm`, `npm`, `node` or a global module you'll get a slight delay while `nvm` loads first. You'll only get this delay once per session.

For example, if you are using antigen, you would put the following in your `.zshrc`:

```shell
export NVM_LAZY_LOAD=true
antigen bundle lukechilds/zsh-nvm
```

Performance comparison:

```shell
% time (source "$NVM_DIR/nvm.sh")
( source "$NVM_DIR/nvm.sh"; )  0.58s user 0.37s system 109% cpu 0.874 total

% time (_zsh_nvm_lazy_load)
( _zsh_nvm_lazy_load; )  0.01s user 0.01s system 168% cpu 0.012 total
```

#### Extra commands to trigger lazy loading
By default lazy loading nvm is triggered by running the `nvm`, `node`, `npm` commands or any installed npm global binaries.
If you want to trigger the lazy loading via extra arbitrary commands you can define `NVM_LAZY_LOAD_EXTRA_COMMANDS` and set it to an array of commands as strings.
This can be usefull if programs are not in the above list of binaries but do depend on the availability of `node`, e.g. a vim plugin.

```shell
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim')
vim --version
#node is now loaded
```

### Don't autoload node

By default when `nvm` is loaded it'll automatically run `nvm use default` and load your default `node` version along with `npm` and any global modules. You can disable this behaviour by exporting the `NVM_NO_USE` environment variable and setting it to `true`. It must be set before `zsh-nvm` is loaded.

If you enable this option you will then need to manually run `nvm use <version>` before you can use `node`.

For example, if you are using antigen, you would put the following in your `.zshrc`:

```shell
export NVM_NO_USE=true
antigen bundle lukechilds/zsh-nvm
```

### Auto use

If you have lots of projects with an `.nvmrc` file you may find the auto use option helpful. If it's enabled, when you `cd` into a directory with an `.nvmrc` file, `zsh-nvm` will automatically load or install the required node version in `.nvmrc`. You can enable it by exporting the `NVM_AUTO_USE` environment variable and setting it to `true`. It must be set before `zsh-nvm` is loaded.

If you enable this option and don't have `nvm` loaded in the current session (`NVM_LAZY_LOAD` or `NVM_NO_USE`) it won't work until you've loaded `nvm`.

For example, if you are using antigen, you would put the following in your `.zshrc`:

```shell
export NVM_AUTO_USE=true
antigen bundle lukechilds/zsh-nvm
```

## Installation

### Using [Antigen](https://github.com/zsh-users/antigen)

Bundle `zsh-nvm` in your `.zshrc`

```shell
antigen bundle lukechilds/zsh-nvm
```

### Using [zplug](https://github.com/b4b4r07/zplug)
Load `zsh-nvm` as a plugin in your `.zshrc`

```shell
zplug "lukechilds/zsh-nvm"

```
### Using [zgen](https://github.com/tarjoilija/zgen)

Include the load command in your `.zshrc`

```shell
zgen load lukechilds/zsh-nvm
```

### As an [Oh My ZSH!](https://github.com/robbyrussell/oh-my-zsh) custom plugin

Clone `zsh-nvm` into your custom plugins repo

```shell
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
```
Then load as a plugin in your `.zshrc`

```shell
plugins+=(zsh-nvm)
```

Keep in mind that plugins need to be added before `oh-my-zsh.sh` is sourced.

### Manually
Clone this repository somewhere (`~/.zsh-nvm` for example)

```shell
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
```
Then source it in your `.zshrc` (or `.bashrc`)

```shell
source ~/.zsh-nvm/zsh-nvm.plugin.zsh
```

## Tests

To run the tests you'll need to install [Urchin](https://github.com/tlevine/urchin#install). You'll also need to run the tests in an environment that doesn't already have `node` or `nvm` loaded.

You can remove `nvm` from the existing session with:

```shell
nvm deactivate && nvm unload
```

Run the tests with:

```shell
urchin -s zsh tests
```



## Related

- [`zsh-better-npm-completion`](https://github.com/lukechilds/zsh-better-npm-completion) - Better completion for `npm`

## License

MIT © Luke Childs
