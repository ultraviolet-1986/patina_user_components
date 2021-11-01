#!/usr/bin/env bash

###########
# License #
###########

# Patina User Components: Additional components for other use-cases.
# Copyright (C) 2019 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#############
# Functions #
#############

patina_yt_dlp() {
  # Failure: Required application 'yt-dlp' was not detected.
  if ( ! hash 'yt-dlp' ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Patina was not given an argument or was given a single
  # argument.
  elif [ "$#" -eq "0" ] || [ "$#" -eq "1" ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina was given too many arguments.
  elif [ "$#" -gt "2" ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Patina was given 2 arguments. Parse arguments.
  elif [ "$#" -eq "2" ] ; then
    case "$1" in
      'best')
        yt-dlp --no-flat-playlist --write-subs -o '%(playlist_index)s %(title)s.%(ext)s' "$2"
        return 0
        ;;
      *)
        patina_raise_exception 'PE0001'
        return 1
        ;;
    esac

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

export -f 'patina_yt_dlp'

###########
# Aliases #
###########

alias 'p-yt-dlp'='patina_yt_dlp'

# End of File.
