#!/bin/bash
# video demo at: http://www.youtube.com/watch?v=90xoathBYfk

# written by "mhwombat": https://bbs.archlinux.org/viewtopic.php?id=71938&p=2
# Based on "snippy" by "sessy" 
# (https://bbs.archlinux.org/viewtopic.php?id=71938)
# other mods by defenestration

# You will also need "dmenu", "xsel" and "xdotool". Get them from your linux
# distro in the usual way.
#
# To use:
# 1. Create the directory ~/.snippy
#
# 2. Create a file in that directory for each snippet that you want.
#    The filename will be used as a menu item, so you might want to
#    omit the file extension when you name the file. 
#
#    TIP: If you have a lot of snippets, you can organise them into 
#    subdirectories under ~/.snippy.
#
#    TIP: The contents of the file will be pasted asis, so if you 
#    don't want a newline at the end when the text is pasted, don't
#    put one in the file.
#
# 3. Bind a convenient key combination to this script.
#
#    TIP: If you're using XMonad, add something like this to xmonad.hs
#      ((mod4Mask, xK_s), spawn "/path/to/snippy")
#
DIR=${HOME}/.snippy
APPS="xdotool xsel dmenu"
DMENU_ARGS="-i -l 20  -p 'snippy>' -nb #AA0000 -b "
TMPFILE="/tmp/.snippy.tmp"; :>$TMPFILE
# if nothing happens, try "xdotool click 2", "xdotool key ctrl+v" or "xdotool key ctrl+shift+v"
#GUIPASTE="xdotool click 2" 
#GUIPASTE="xdotool key shift+Insert" 
#GUIPASTE="xdotool --window $name type $(cat $TMPFILE)"
# -p = `xdotool click 2` 
#-s,-b #works with cli & shift+Insert , not GUI apps tho
#xselopts="--display :0 -p -s -b -k"

bashdown(){
# @link http://github.com/coderofsalvation/bashdown
# @example: echo 'hi $NAME it is $(date)' | bashdown
# fetches a document and interprets bashsyntax in string (bashdown) templates 
  IFS=''; cat - | sed 's/\\/\\\\\\\\/g' | while read line; do 
    line="$(eval "echo \"$( echo "$line" | sed 's/"/\\"/g')\"")"; # process bash in snippet
    echo "$line"
  done
}

init(){
  for APP in $APPS; do 
    which $APP &>/dev/null || {
      read -p "install the following required utils? : $APPS (y/n)" reply
      [[ "$reply" == "y" ]] && sudo apt-get install ${APPS}; 
    }
  done
  [[ ! -d "$DIR" ]] && { 
    echo -e "created $DIR\n";
    mkdir "$DIR"; 
    printf 'hi it is $(date)' > "$DIR""/test";
  }
  return 0
}

run(){
  cd ${DIR}
  # Use the filenames in the snippy directory as menu entries.
  # Get the menu selection from the user.
  if ! DMENU_OUT=`find -L .  -type f | grep -v '^\.$' | sed 's!\.\/!!' | /usr/bin/dmenu ${DMENU_ARGS}` ; then
    #quit on escape
    return 1 
  fi 
  
  if [ -f ${DIR}/${DMENU_OUT} ]; then
    #check header of file for #bashdown
    if [ `head -n1 ${DIR}/${DMENU_OUT}` == '#bashdown' ];then
      #remove 1st line and bashdown it
      content="$(sed 1d ${DIR}/${DMENU_OUT} | bashdown )" 
    else

      content="$(cat ${DIR}/${DMENU_OUT})" 
    fi
    type_it "$content"

    #[[ "${#content}" == 0 ]] && printf "${FILE}" > $TMPFILE || printf "%s" "$content" > $TMPFILE
    #FILE} &> $TMPFILE # execute as bashcommand
  else
    # try to run as a cmd and give output
    content=$($DMENU_OUT)
    type_it "$content"
    #type_it "${DIR}/${FILE} doesn't exist."
  fi
  #xsel $xselopt --input < $TMPFILE

  # Paste into the current application.
  #paste_cli || gui_paste # cli or gui paste
}

type_it() {
  xdotool type --clearmodifiers --delay 1 -- "$1"
}
# gui_paste() {
# 	#local window=$1
# 	#xdotool type -- $(cat $TMPFILE)
#   #xdotool click 2
#   xdotool sleep 0.2 type -- "$1"

# }

# paste_cli(){
#   window="$(xdotool getwindowname $(xdotool getwindowfocus) | tr '[:upper:]' '[:lower:]')"
#   [[ ! "$window" =~ ~|term|tilda ]] && return 1
#   gui_paste 
# }


init && run

