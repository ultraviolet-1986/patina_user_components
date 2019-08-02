#!/usr/bin/env bash

##########
# Notice #
##########

# Patina User Components: Additional components to simplify common tasks.
# Copyright (C) 2019 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#########################
# ShellCheck Directives #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#################
# Documentation #
#################

# Function: 'patina_delete_minecraft_data'

#   Notes:
#     1. Detects and deletes files and folders related to Minecraft launcher
#        downloads.
#     2. This function will not delete the 'Minecraft Launcher.iso' file.

#   Required Packages:
#     None.

#   Parameters:
#     None.

#   Example Usage:
#     $ patina_delete_minecraft_data

# Function: 'patina_download_minecraft_data'

#   Notes:
#     1. This function will download the Minecraft launcher data from Microsoft
#        and create a mountable disk image from these files.
#     2. This function will create a 'Minecraft Launcher.iso' file within the
#        ~/Downolads directory.
#     3. This function will not operate if there are no active Internet
#        connections.
#     4. Existing files and directories will be deleted before beginning and
#        will also clean up after the disk image is compiled.
#     5. If package 'genisoimage' is not installed, a disk image will not be
#        created and downloaded files will remain in ~/Downloads.

#   Required Packages:
#     1. 'genisoimage' for command 'mkisofs'.

#   Parameters:
#     None.

#   Example Usage:
#     $ p-minecraft

#############
# Functions #
#############

patina_delete_minecraft_data() {
  if [ -f "$patina_path_home_downloads/Minecraft.tar.gz" ] ; then
    printf "NOTE: Deleting existing 'Minecraft.tar.gz' file... "
    rm "Minecraft.tar.gz" > /dev/null 2>&1
    echo "Done"
  fi

  if [ -d "$patina_path_home_downloads/Minecraft" ] ; then
    printf "NOTE: Deleting existing 'Minecraft' directory... "
    rm -rf 'Minecraft' > /dev/null 2>&1
    echo "Done"
  fi

  if [ -d "$patina_path_home_downloads/minecraft-launcher" ] ; then
    printf "NOTE: Deleting existing 'minecraft-launcher' directory... "
    rm -rf 'minecraft-launcher' > /dev/null 2>&1
    echo "Done"
  fi
}

patina_download_minecraft_data() {
  patina_detect_internet_connection

  if [ "$patina_has_internet" = true ] ; then
    cd "$patina_path_home_downloads" || return

    patina_delete_minecraft_data

    # Download fresh copy of the Minecraft Launcher.
    printf "NOTE: Downloading fresh copy of 'Minecraft.tar.gz'... "
    wget 'https://launcher.mojang.com/download/Minecraft.tar.gz' > \
      /dev/null 2>&1
    echo "Done"

    # Extract the contents of the Minecraft Launcher archive.
    printf "NOTE: Extracting contents of 'Minecraft.tar.gz'... "
    tar -xvzf "Minecraft.tar.gz" > /dev/null 2>&1
    echo "Done"

    # Create new disk image (if possible).
    if ( hash 'mkisofs' > /dev/null 2>&1 ) ; then
      if [ -f 'Minecraft Launcher.iso' ] ; then
        printf "NOTE: Deleting existing 'Minecraft Launcher.iso' disk image..."
        rm 'Minecraft Launcher.iso'
        echo "Done"
      fi

      printf "NOTE: Creating new 'Minecraft Launcher.iso' disk image... "
      mkisofs -volid "$(patina_generate_volume_label)" \
        -o "Minecraft Launcher.iso" -input-charset UTF-8 -joliet -joliet-long \
        -rock 'minecraft-launcher' > /dev/null 2>&1
      echo "Done"

      patina_delete_minecraft_data
    fi

    # Finally change back to original directory.
    cd ~- || return
  else
    patina_throw_exception 'PE0008'
  fi
}

###########
# Aliases #
###########

alias 'p-minecraft'='patina_download_minecraft_data'

# End of File.
