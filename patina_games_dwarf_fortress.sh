#!/usr/bin/env bash

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

##############
# References #
##############

# Stack Exchange .................................. https://tinyurl.com/y98f5f87
# Stack Overflow .................................. https://tinyurl.com/ydghmshz

#############
# Variables #
#############

readonly patina_df_download_url='http://www.bay12games.com/dwarves'
readonly patina_df_download_dir="$HOME/Downloads/Games"
readonly patina_df_wiki_install_url='http://dwarffortresswiki.org/index.php/DF2014:Installation#Linux'

#############
# Functions #
#############

patina_dwarf_fortress_install_dependencies() {
  # Detect system Package Manager and install known dependencies.
  if [ "$patina_package_manager" = 'apt' ] ; then
    patina_package_manager install \
      libsdl1.2debian \
      libsdl-image1.2 \
      libSDL-ttf2.0-0
  elif [ "$patina_package_manager" = 'dnf' ] ; then
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
      `"For more information, please visit '$patina_df_wiki_install_url'."
  fi
}

patina_dwarf_fortress_download() {
  patina_detect_internet_connection

  mkdir -p "$patina_df_download_dir"

  if [ "$patina_has_internet" = 'true' ] && [ -e "$patina_df_download_dir" ] ; then
    echo
    wget "$patina_df_download_url"/"$(wget -O- $patina_df_download_url | \
      grep -E -o 'df_[0-9\.]+.[0-9\.]+_linux.tar.bz2' | sort -V  | tail -1)" \
      -P "$patina_df_download_dir"
    echo
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_dwarf_fortress_play() {
  # Temporarily set variables for Dwarf Fortress folder and script location.
  local patina_df_directory="$(find "$HOME" -name "df_linux" -type d -print -quit 2> /dev/null)"
  local patina_df_script="$patina_df_directory/df"

  # Execute Dwarf Fortress script if found.
  if [ -e "$patina_df_script" ] ; then
    "$patina_df_script"
    echo
  else
    patina_throw_exception 'PE0005'
  fi
}

patina_dwarf_fortress() {
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
  else
    case "$1" in
      'download' | 'dl') patina_dwarf_fortress_download ;;
      'dependencies' | 'deps') patina_dwarf_fortress_install_dependencies ;;
      'play') patina_dwarf_fortress_play ;;
      *) patina_throw_exception 'PE0003' ;;
    esac
  fi
}

###########
# Aliases #
###########

alias 'p-dwarf'='patina_dwarf_fortress'
alias 'p-df'='patina_dwarf_fortress'

# End of File.
