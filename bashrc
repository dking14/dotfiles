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

export BASH_EXTRAS="$HOME/.bash"
if [ -d $BASH_EXTRAS ]; then
  for config in `ls $BASH_EXTRAS`; do
    source $BASH_EXTRAS/$config 2>/dev/null
  done
fi

# overwrite in .mybashrc to customize these for each machine 
# (or use __before_ps1 to dynamically update these)
export TERM_TITLE="`hostname -s`:$PWD"
export PROMPT_COLOR="\e[32m"  # regular color
export PROMPT_DETAILS="[$RET\u.\h: \w]\$ "
export ERROR_COLOR="\e[31m" # for our error status code

function __prompt_command(){ 
  # on $? != 0 put the exit status in $ERROR_COLOR wherever $RET is within $PROMPT_DETAILS
  RET="\$(r=\$?;[ \$r -eq 0 ] || echo -n \"\[$ERROR_COLOR\]\$r\[$PROMPT_COLOR\] \")"

  # use this function `__before_ps1` to customize the above vars
  # or modify PROMPT_DETAILS/etc.
  if type __before_ps1 >/dev/null 2>&1;then __before_ps1; fi

  echo -ne "\033]0;$TERM_TITLE\007"
  PS1="\[${PROMPT_COLOR}\]${PROMPT_DETAILS}\[\e[0m\]"
}
export PROMPT_COMMAND=__prompt_command

# Aliases
[[ -e $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

# Our buddy "z"
[[ -e $HOME/bin/z.sh ]] && source $HOME/bin/z.sh

# Define custom things for each machine in ~/.mybashrc
# (e.g.: different color prompt, prompt details, different aliases, vars, etc.)
[[ -e $HOME/.mybashrc ]] && source $HOME/.mybashrc