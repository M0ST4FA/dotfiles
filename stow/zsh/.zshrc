#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#

# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/zshrc
# or by creating a folder ~/.config/zshrc/custom
# with copies of files from ~/.config/zshrc
# -----------------------------------------------------

# -----------------------------------------------------
# Load modular configarion
# -----------------------------------------------------

# Set vconsole colors
source /usr/local/bin/nord-vconsole

for f in ~/.config/zshrc/*; do
    if [ ! -d $f ]; then
        c=`echo $f | sed -e "s=.config/zshrc=.config/zshrc/custom="`
        [[ -f $c ]] && source $c || source $f
    fi
done

figlet -tc "m0st4fa" | rainbow

# First login QOTD
if [[ ! -f ~/.last_zsh_run ]] || [[ "$(cat ~/.last_zsh_run)" != "$(date +%Y-%m-%d)" ]]; then
  QOTD="$(netcat djxmmx.net 17)"
  echo $QOTD | rainbow

  date +%Y-%m-%d > ~/.last_zsh_run
fi
