#!/usr/bin/env bash

##############
# References #
##############

# Stack Exchange .................................. https://tinyurl.com/y98f5f87

#############
# Variables #
#############

readonly df_download_url='http://www.bay12games.com/dwarves'
readonly df_download_dir="$HOME/Downloads/Games"
readonly df_wiki_install_url='http://dwarffortresswiki.org/index.php/DF2014:Installation#Linux'

#############
# Functions #
#############

patina_dwarf_fortress_install_dependencies() {
  if [ $patina_package_manager = 'apt' ] ; then
    patina_package_manager install \
      libsdl1.2debian \
      libsdl-image1.2 \
      libSDL-ttf2.0-0
  elif [ $patina_package_manager = 'dnf' ] ; then
    patina_package_manager install \
      SDL \
      SDL_image \
      SDL_ttf \
      gtk2-devel \
      openal-soft \
      alsa-lib \
      alsa-plugins-pulseaudio \
      mesa-dri-drivers
  else
    echo_wrap "Patina cannot install dependencies on your current system. "`
      `"For more information, please visit '$df_wiki_install_url'."
  fi
}

patina_dwarf_fortress_download() {
  patina_detect_internet_connection

  mkdir -p "$df_download_dir"

  if [ "$patina_has_internet" = 'true' ] && [ -e "$df_download_dir" ] ; then
    echo
    wget $df_download_url/$(wget -O- $df_download_url | \
      egrep -o 'df_[0-9\.]+.[0-9\.]+_linux.tar.bz2' | sort -V  | tail -1) \
      -P $df_download_dir
    echo
  else
    echo_wrap "Patina has encountered an unknown error."
  fi
}

patina_dwarf_fortress() {
  case "$1" in
    'download') patina_dwarf_fortress_download ;;
    'dependencies') patina_dwarf_fortress_install_dependencies ;;
    'play') echo ;;
    *) ;;
  esac
}

###########
# Aliases #
###########

alias 'p-dwarf'='patina_dwarf_fortress'

# End of File.
