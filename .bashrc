# Global Declarations
export ENV=$HOME/.bashrc
export SHELL=/bin/bash
export EDITOR="nano"

export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='exgxfxdxcxdxdxhbadexex'

if [ -t 0 ]; then
  stty erase ^H
fi

push_path(){
	if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH=$PATH:$1
    else
      PATH=$1:$PATH
    fi
	fi
}

push_path /usr/local/bin
for path in `ls -d /usr/local/*/bin 2>/dev/null`; do
	push_path $path
done
push_path $HOME/bin

export BASH_EXTRAS="$HOME/.bash_extras"
if [ -d $BASH_EXTRAS ]; then
  for config in `ls $BASH_EXTRAS`; do
    source $BASH_EXTRAS/$config
  done
fi

# Call this to rerender the prompt after changing the $PROMPT_* variables below
update_prompt(){
  export PROMPT_COMMAND='PS1="\`if [[ \$? = "0" ]]; then echo $PROMPT_COLOR; else echo $PROMPT_ECOLOR; fi\`[\u.\h: \w]\$\[\033[0m\] "; echo -ne "\033]0;`termtitle`\007"'
}

# this is used to set the terminal title
termtitle(){
  echo `hostname -s`:`pwd`
}

if [ "$PS1" ]; then
  export PROMPT_COLOR="\[\033[32m\]"
  export PROMPT_ECOLOR="\[\033[31m\]"
  # Re-run this in your .mybashrc file if you change the PROMPT_COLLAPSE_PATHS var
  update_prompt
fi

# Aliases
[[ -e $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

# Our buddy "z"
[[ -e $HOME/bin/z.sh ]] && source $HOME/bin/z.sh

# Define custom things for each machine in ~/.mybashrc
# (e.g.: different color prompt, different aliases, vars, etc.)
[[ -e $HOME/.mybashrc ]] && source $HOME/.mybashrc