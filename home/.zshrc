# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/martin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
setopt COMPLETE_ALIASES

# enable history search
#autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
#
#[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
#[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

ANTIGENRC_PATH=~/.antigenrc
if [ -f $ANTIGENRC_PATH ]; then
	source $ANTIGENRC_PATH
fi

bindkey -v

# Add aliases.
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# Add exported paths
if [ -f ~/.export_paths ]; then
    source ~/.export_paths
fi

function activate {

    VENVs="$HOME/venvs/"
    ba="bin/activate"

    if [ $# -eq  1 ]; then

	if [ -f "$1/$ba" ]; then
	    venv="$1"
	elif [ -f "$VENVs/$1/$ba" ]; then
	    venv="$VENVs/$1"
	else
	    echo "Dunno what you mean by \"$1\""
	    return 1
	fi

    else
	for d in */; do
	    if [ -f "$d/$ba" ]; then
		venv="$d"
		break
	    fi
	done

	if [ -z "$venv" ]; then
	    echo "No candidate found, find it yourself"
	    return 1
	fi
    fi

    venv="$venv/bin/activate"
    echo "Using $venv"
    source "$venv"

    return 0
}

AUTOENV_ENABLE_LEAVE=yep
source ~/.autoenv/activate.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/martin/mypap/sources/google-cloud-sdk/path.zsh.inc' ]; then . '/home/martin/mypap/sources/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/martin/mypap/sources/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/martin/mypap/sources/google-cloud-sdk/completion.zsh.inc'; fi


export PATH="/home/martin/.gem/ruby/2.6.0/bin:/home/martin/.local/bin:$PATH"
export PATH="$HOME/esp/xtensa-esp32-elf/bin:$PATH"
export IDF_PATH="/home/martin/esp/esp-idf"
eval `dircolors /home/martin/.dir_colors`

