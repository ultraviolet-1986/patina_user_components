#!/usr/bin/env bash

###########
# License #
###########

# Patina User Components: Additional components to simplify common tasks.
# Copyright (C) 2019 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program. If not,
# see <http://www.gnu.org/licenses/>.

#############
# Functions #
#############

# patina_youtube_dl <format> <url>
patina_youtube_dl() {
  if ( ! hash 'youtube-dl' ) ; then
    patina_raise_exception 'PE0006'
    return 1

  elif [ "$#" -eq "0" ] || [ "$#" -eq "1" ] ; then
    patina_raise_exception 'PE0001'
    return 1

  elif [ "$#" -gt "2" ] ; then
    patina_raise_exception 'PE0002'
    return 1

  elif [ "$#" -eq "2" ] ; then
    case "$1" in
      'mp3')
        youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 -o \
          "%(playlist_index)s %(title)s.%(ext)s" "$2"
          return 0
          ;;
      'mp4')
        youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' -o \
          "%(playlist_index)s %(title)s.%(ext)s" "$2"
          return 0
          ;;
      'mp4-sub')
        youtube-dl --write-auto-sub --write-sub --embed-subs --sub-lang en_GB,en-GB,en_US,en-US,en \
          --sub-format srt/best -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' -o \
          "%(playlist_index)s %(title)s.%(ext)s" "$2"
          return 0
          ;;
      *)
        patina_raise_exception 'PE0001'
        return 1
        ;;
    esac

  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

export -f 'patina_youtube_dl'

###########
# Aliases #
###########

alias 'p-yt-dl'='patina_youtube_dl'

# End of File.
