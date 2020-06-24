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
#     2. This function will not delete the 'Minecraft.iso' file.

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
#     2. This function will create a 'Minecraft.iso' file within the
#        ~/Downolads directory.
#     3. This function will not operate if there are no active Internet
#        connections.
#     4. Existing files and directories will be deleted before beginning and
#        will also clean up after the disk image is compiled.
#     5. If package 'genisoimage' is not installed, a disk image will not be
#        created and downloaded files will remain in ~/Downloads.

#   Required Packages:
#     1. 'genisoimage' for command 'mkisofs'.
#     2. 'wget' for command 'wget'.

#   Parameters:
#     None.

#   Example Usage:
#     $ p-minecraft

#############
# Functions #
#############

patina_delete_minecraft_data() {
  if [ -f "$PATINA_PATH_HOME_DOWNLOADS/Minecraft.tar.gz" ] ; then
    printf "NOTE: Deleting existing 'Minecraft.tar.gz' file... "
    rm "Minecraft.tar.gz" > /dev/null 2>&1
    echo -e "${GREEN}Done${COLOR_RESET}"
  fi

  if [ -d "$PATINA_PATH_HOME_DOWNLOADS/Minecraft" ] ; then
    printf "NOTE: Deleting existing 'Minecraft' directory... "
    rm -rf 'Minecraft' > /dev/null 2>&1
    echo -e "${GREEN}Done${COLOR_RESET}"
  fi

  if [ -d "$PATINA_PATH_HOME_DOWNLOADS/minecraft-launcher" ] ; then
    printf "NOTE: Deleting existing 'minecraft-launcher' directory... "
    rm -rf 'minecraft-launcher' > /dev/null 2>&1
    echo -e "${GREEN}Done${COLOR_RESET}"
  fi

  return 0
}

patina_download_minecraft_data() {
  patina_detect_internet_connection

  if [ "$PATINA_HAS_INTERNET" = true ] ; then
    mkdir -p "$PATINA_PATH_HOME_DOWNLOADS"
    cd "$PATINA_PATH_HOME_DOWNLOADS" || return 1

    patina_delete_minecraft_data

    if ( command -v 'wget' > /dev/null 2>&1 ) ; then
      # Download fresh copy of the Minecraft Launcher.
      printf "NOTE: Downloading fresh copy of 'Minecraft.tar.gz'... "
      wget 'https://launcher.mojang.com/download/Minecraft.tar.gz' > \
        /dev/null 2>&1
      echo -e "${GREEN}Done${COLOR_RESET}"
    else
      patina_raise_exception 'PE0006'
      return 1
    fi

    # Extract the contents of the Minecraft Launcher archive.
    printf "NOTE: Extracting contents of 'Minecraft.tar.gz'... "
    tar -xvzf "Minecraft.tar.gz" > /dev/null 2>&1
    echo -e "${GREEN}Done${COLOR_RESET}"

    # Inject 'autorun' file.
    printf "NOTE: Injecting populated 'autorun.sh' file... "
    local autorun_header="#!/usr/bin/env bash\n\n"
    local autorun_command="./minecraft-launcher\n\n"
    local autorun_footer="# End of File.\n"
    echo -e "${GREEN}Done${COLOR_RESET}"

    echo -e "$autorun_header$autorun_command$autorun_footer" > \
      "$PATINA_PATH_HOME_DOWNLOADS/minecraft-launcher/autorun.sh"

    chmod 755 "$PATINA_PATH_HOME_DOWNLOADS/minecraft-launcher/autorun.sh"

    # Create new disk image (if possible).
    if ( command -v 'mkisofs' > /dev/null 2>&1 ) ; then
      if [ -f 'Minecraft.iso' ] ; then
        printf "NOTE: Deleting existing 'Minecraft.iso' disk image..."
        rm 'Minecraft.iso'
        echo -e "${GREEN}Done${COLOR_RESET}"
      fi

      printf "NOTE: Creating new 'Minecraft.iso' disk image... "
      mkisofs -volid "Minecraft" \
        -o "Minecraft.iso" -input-charset UTF-8 -joliet -joliet-long \
        -rock 'minecraft-launcher' > /dev/null 2>&1
      echo -e "${GREEN}Done${COLOR_RESET}"

      patina_delete_minecraft_data
    fi

    # Finally change back to original directory.
    cd ~- || return 1
    return 0
  else
    patina_raise_exception 'PE0008'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-minecraft'='patina_download_minecraft_data'

# End of File.
