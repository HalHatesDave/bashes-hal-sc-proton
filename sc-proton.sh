#!/usr/bin/env bash
################################################################
## Hal's Franken-Script For SC on Umu Proton 1.0
################################################################
### Main Corpus
################################################################
#Set Required ENVARS
export WINEPREFIX="/home/ody/Games/star-citizen"
export GAMEID="umu-starcitizen" #Allows Auto-Protonfixes
export STORE=none #Needed for auto-ProtonFix DB Grab
export PROTONPATH="GE-Latest" #Auto-Selects Latest GE-Proton & applies a delta update
################################################################
# Optional Utility ENVARS
export DXVK_HUD=0
### export UMU_LOG=debug
export PROTON_LOG=0 # Disabled due to MASSIVE 1GB+ Log Sizes
################################################################
export MANGOHUD=1 #MangoHud
export MANGOHUD_CONFIG=alpha=0.7,ram,vram,position=middle-left
################################################################
### FIXES
################################################################
# VRAM Exhaustion Remediation
export DXVK_CONFIG="dxgi.maxDeviceMemory = 10240;cachedDynamicResources = a;"
# DLSS Force DLSS4 and NVAPI
export PROTON_ENABLE_NVAPI=1
export PROTON_ENABLE_NGX_UPDATER=1
export DXVK_NVAPI_DRS_NGX_DLSS_SR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_latest
export DXVK_ASYNC=1
export PROTON_HIDE_NVIDIA_GPU=0
################################################################
### Further Optimizations
################################################################
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SIZE=10737418240
export __GL_SHADER_DISK_CACHE_PATH="/home/ody/Games/star-citizen/shaders"
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
### export __GL_THREADED_OPTIMIZATIONS=0 # GameScope Fix | Not Used ATM
################################################################

################################################################
### UNUSED ENVARS
################################################################
#export WINEDLLOVERRIDES=winemenubuilder.exe=d # Prevent updates from overwriting existing .desktop entries
#export WINEDEBUG=-all # Cut down on console debug messages
#export EOS_USE_ANTICHEATCLIENTNULL=1
# Nvidia cache options

#export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
# Mesa (AMD/Intel) shader cache options
#export MESA_SHADER_CACHE_DIR="$WINEPREFIX"
#export MESA_SHADER_CACHE_MAX_SIZE="10G"
################################################################

################################################################
#export MANGOHUD=1 #Might use at some point
################################################################


################################################################
###         Launch Launcher Using UMU Launcher
################################################################

nice -10 umu-run "~/Games/star-citizen/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe"
