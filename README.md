# zsh-nvm

> Zsh plugin for installing, updating and loading `nvm`

[`nvm`](https://github.com/creationix/nvm) is an awesome tool but it can be kind of a pain to install and keep up to date. This zsh plugin allows you to quickly setup `nvm` once, save it in your dotfiles, then never worry about it again.

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

## Options

### Custom Directory

You can specify a custom directory to use with `nvm` by exporting the `NVM_DIR` environment variable. It must be set before `zsh-nvm` is loaded.

For example, if you are using antigen, you would put the following in your `.zshrc`:

```shell
export NVM_DIR="$HOME/.custom-nvm-dir"
antigen bundle lukechilds/zsh-nvm
```

Note: If `nvm` doesn't exist in this directory it'll be automatically installed when you start a session.

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

### Manually
Clone this repository somewhere (`~/.zsh-nvm` for example)

```shell
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
```
Then source it in your `.zshrc` (or `.bashrc`)

```shell
source ~/.zsh-nvm/zsh-nvm.plugin.zsh
```

## Related

- [`zsh-better-npm-completion`](https://github.com/lukechilds/zsh-better-npm-completion) - Better completion for `npm`

## License

MIT © Luke Childs
