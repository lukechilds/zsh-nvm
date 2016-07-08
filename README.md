# zsh-nvm

> Zsh plugin for installing, updating and loading `nvm`

[`nvm`](https://github.com/creationix/nvm) is an awesome tool but it can be kind of a pain to install and keep up to date. This zsh plugin allows you to quickly setup `nvm` once, save it in your dotfiles, then never worry about it again.

The plugin will install the latest stable release of `nvm` if you don't already have it, and then automatically `source` it for you. You can upgrade `nvm` to the latest version whenever you want without losing your installed `node` versions by running `nvm_update`.

## Usage

Once the plugin's installed you don't really need to do anything, `nvm` will be available. You'll probably want to load this as one of your first plugins so `node`/`npm` is available for any other plugins that may require it.

If you want to update `nvm`:

```shell
% nvm_update
Installed version is v0.31.1
Checking latest version of nvm...
Updating to v0.31.2...
Previous HEAD position was ec2f450... v0.31.1
HEAD is now at 9f5322e... v0.31.2
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

### Manually
Clone this repository somewhere (`~/zsh-nvm` for example)

```shell
git clone git@github.com:lukechilds/zsh-nvm.git ~/zsh-nvm
```
Then source it in your `.zshrc`

```shell
source ~/zsh-nvm/zsh-nvm.sh
```

## License

MIT © Luke Childs
