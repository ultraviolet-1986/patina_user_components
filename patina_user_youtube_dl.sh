#!/usr/bin/env bash

##########
# Notice #
##########

# Patina User Components: Additional components to simplify common tasks.
# Copyright (C) 2018 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#############
# Functions #
#############

patina_youtube_dl_mp3() {
  if ( ! hash 'youtube-dl' ) ; then
    patina_throw_exception 'PE0006'
    return
  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
    return
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return
  else
    youtube-dl \
      --extract-audio \
      --audio-format mp3 \
      --audio-quality 0 \
      "$1"
    return
  fi
}

patina_youtube_dl_mp4() {
  if ( ! hash 'youtube-dl' ) ; then
    patina_throw_exception 'PE0006'
    return
  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
    return
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return
  else
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' "$1"
    return
  fi
}

###########
# Aliases #
###########

alias 'p-yt-dl-mp3'='patina_youtube_dl_mp3'
alias 'p-yt-dl-mp4'='patina_youtube_dl_mp4'

# End of File.
