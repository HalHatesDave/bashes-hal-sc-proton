#!/usr/bin/env bash
################################################################################################################################
### Hal's First Script For Running SC via UMU with Proton on *NVIDIA GPU* ver 1.1
### !! Auto-Updates GE-Proton !!
### Hello:
echo -e "\n\033[1;33m
  ██╗  ██╗ █████╗ ██╗
  ██║  ██║██╔══██╗██║
  ███████║███████║██║
  ██╔══██║██╔══██║██║
  ██║  ██║██║  ██║███████╗
  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
\033[0m"
echo "Hal's Star Citizen X Linux X UMU x GE-Proton script now running..."
################################################################################################################################
### !! SET SC PREFIX LOCATION HERE !!
WINEPFX="$HOME/Games/star-citizen"
################################################################
### REQUIRED ENV
export WINEPREFIX="$WINEPFX"
export GAMEID="umu-starcitizen" #Allows Auto-Protonfixes
export STORE=none #Needed for auto-ProtonFix DB Grab
export PROTONPATH="GE-Latest" #Auto-Selects Latest GE-Proton & applies a delta update
################################################################
### OPTIONAL: UTILITY
export DXVK_HUD=0 # MangoHUD is used in-place of this
#export UMU_LOG=debug # not sure if needed disabled for now
export PROTON_LOG=0 # Disabled due to MASSIVE 1GB+ Log Sizes
export MANGOHUD=1 #MangoHud
export MANGOHUD_CONFIG=alpha=0.7,ram,vram,position=middle-left # mangohud configs
################################################################
### FIXES
# VRAM Exhaustion Remediation
export DXVK_CONFIG="dxgi.maxDeviceMemory = 10240;cachedDynamicResources = a;" # replace "10240" (aka 10GB) with your VRAM size in MBs
# Force DLSS4 + enable NVAPI (might be redundant)
export PROTON_ENABLE_NVAPI=1
export PROTON_ENABLE_NGX_UPDATER=1
export DXVK_NVAPI_DRS_NGX_DLSS_SR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_latest
export DXVK_ASYNC=1
export PROTON_HIDE_NVIDIA_GPU=0
################################################################
### Further Optimizations, Might Be Redundant(?)
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SIZE=10737418240
export __GL_SHADER_DISK_CACHE_PATH="${WINEPFX}/shaders"
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
#export __GL_THREADED_OPTIMIZATIONS=0 # GameScope Fix | Not Used ATM
################################################################
### UNUSED
#export WINEDEBUG=-all # Cut down on console debug messages
#export EOS_USE_ANTICHEATCLIENTNULL=1
#export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
### Mesa (AMD/Intel) shader cache options | NOT USED
#export MESA_SHADER_CACHE_DIR="$WINEPREFIX"
#export MESA_SHADER_CACHE_MAX_SIZE="10G"
################################################################
### Print all variables and env
ENV_PRINT=0 # Set to 1 to print all env for troubleshooting
if [[ "${ENV_PRINT:-0}" -eq 1 ]]; then
    echo "### Printing all set variables ###"
    # Print all variables (including environment variables)
    set
    # Alternative: print only non-environment variables
    # ( set -o posix ; set )
fi
################################################################
###         Launch RSI Launcher with latest GE-Proton via UMU
sleep 1
echo "Running Star Citizen!"
sleep .4
echo "Main ENV Set to:" # Set ENV_PRINT on line 29 to print all variables
echo "Wine Prefix set to $WINEPFX"
echo "Proton Ver: $PROTONPATH"
sleep .7
nice -10 umu-run "${WINEPFX}/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe" &
################################################################
