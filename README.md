# omz-zshrc

My zsh configuration on top of oh-my-zsh.

## Installation

```bash
bash <(wget -q -O - https://raw.githubusercontent.com/bosha/omz-zshrc/master/install.sh)
```

This script will:

- Install the oh-my-zsh if it's not already installed
- Install the following plugins: _zsh-syntax-highlighting_, _zsh-autosuggestions_
- Clone this repository to the `~/.zsh-bosha`
- Move the `~/.zshrc` generated by the oh-my-zsh to `~/.zshrc.backup`
- Make a symlink `~/.zsh-bosha/zshrc → ~/.zshrc`
