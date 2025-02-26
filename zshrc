export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
ENABLE_CORRECTION="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(
	git 
	custom-grc 
	golang 
	history 
	dotenv 
	docker 
	docker-compose 
	vi-mode 
	pyenv 
	command-not-found 
	common-aliases 
	colorize 
	colored-man-pages 
	cp 
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='vim'

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%}
➜ %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%} $(git_prompt_info) '

export GOPATH=$HOME/go

export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/Users/bosha/Library/Python/3.8/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:~/bin
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
#
# AI Commit Message
ai_commit() {
 diff=$(git diff)
 ollama run deepseek-coder:6.7b-instruct "Diff: $diff. Suggest a git commit message for the diff provided above. The commit message should be written in active voice and should follow conventional commit style, and the format should be <type>[scope]: <description>. Example: fix(authentication): add password regex pattern."
}


if command -v batcat >/dev/null 2>&1; then
  # Save the original system `cat` under `rcat`
  alias rcat="$(which cat)"

  # For Ubuntu and Debian-based `bat` packages
  # the `bat` program is named `batcat` on these systems
  alias cat="$(which batcat)"
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
  export MANROFFOPT="-c"
elif command -v bat >/dev/null 2>&1; then
  # Save the original system `cat` under `rcat`
  alias rcat="$(which cat)"

  # For all other systems
  alias cat="$(which bat)"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# Create aliases for vi and vim to use nvim
if command -v nvim &> /dev/null; then
    alias v='nvim'
    alias nv='nvim'
    alias vi='nvim'
    alias vim='nvim'

	# Preferred editor for local and remote sessions
	if [[ -n $SSH_CONNECTION ]]; then
	  export EDITOR='vim'
	else
	  export EDITOR='nvim'
	fi
fi

alias ls='ls --color '
alias rm='nocorrect rm -Irv'
alias s='nocorrect sudo'
alias rm='rm -v'
alias mv='mv -v'
alias k='killall' 

alias -g G='| grep -e'
alias -g L='| zless'
alias -g clean='egrep -v "^\s*$|^;|^\s*#"'

# Define a custom widget to go up one directory
updir() {
	print -P "\e[K"
	cd .. && ls
	zle reset-prompt
}

# Bind Ctrl+U to the updir widget
zle -N updir
bindkey '^U' updir

extract () {
	echo Extracting $1 ...
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xjf $1        ;;
			*.tar.gz)    tar xzf $1     ;;
			*.bz2)       bunzip2 $1       ;;
			*.rar)       unrar x $1     ;;
			*.gz)        gunzip $1     ;;
			*.tar)       tar xf $1        ;;
			*.tbz2)      tar xjf $1      ;;
			*.tbz)       tar -xjvf $1    ;;
			*.tgz)       tar xzf $1       ;;
			*.zip)       unzip $1     ;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1    ;;
			*)           echo "I don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
} 

pk () {
	echo "Archiving $1 ..."
	if [ $1 ] ; then
		case $1 in
			tbz)       tar cjvf $2.tar.bz2 $2      ;;
			tgz)       tar czvf $2.tar.gz  $2       ;;
			tar)      tar cpvf $2.tar  $2       ;;
			bz2)    bzip $2 ;;
			gz)        gzip -c -9 -n $2 > $2.gz ;;
			zip)       zip -r $2.zip $2   ;;
			7z)        7z a $2.7z $2    ;;
			*)         echo "'$1' cannot be packed via pk()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

