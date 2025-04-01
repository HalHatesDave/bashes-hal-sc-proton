#!/usr/bin/env bash
################################################################################################################################
### Hal's Launcher for Star Citizen via UMU with Proton on *NVIDIA GPUs*
### !! Auto-Updates GE-Proton !!
###
### Usage:
###   Default:        hal-sc-play
###   Custom prefix:  hal-sc-play --wineprefix /path/to/prefix
################################################################################################################################

# ASCII Art and startup message
echo -e "\n\033[1;33m
 /\\_/\\   ██╗  ██╗ █████╗ ██╗         /\\_/\\
( o.o )  ██║  ██║██╔══██╗██║        ( o.o )
 > ^ <   ███████║███████║██║         > ^ <
 /\\_/\\   ██╔══██║██╔══██║██║         /\\_/\\
( o.o )  ██║  ██║██║  ██║███████╗   ( o.o )
 > ^ <   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    > ^ <
\033[0m"
echo "hal-sc-play v2.0 now running..."

# Default wine prefix location
DEFAULT_WINEPFX="$HOME/Games/star-citizen"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --wineprefix)
            WINEPFX="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Use default if not specified
WINEPFX="${WINEPFX:-$DEFAULT_WINEPFX}"

################################################################
### REQUIRED ENVIRONMENT VARIABLES
################################################################
export WINEPREFIX="$WINEPFX"           # Set the Wine prefix location
export GAMEID="umu-starcitizen"        # Allows Auto-Protonfixes
export STORE=none                      # Needed for auto-ProtonFix DB Grab
export PROTONPATH="GE-Latest"          # Auto-Selects Latest GE-Proton

################################################################
### OPTIONAL UTILITY SETTINGS
################################################################
export DXVK_HUD=0                      # Disable DXVK HUD (MangoHUD can be used instead)
export PROTON_LOG=0                    # Disable Proton logging to prevent large log files
#export MANGOHUD=1                     # Uncomment to enable MangoHUD
#export MANGOHUD_CONFIG="alpha=0.7,ram,vram,position=middle-left" # MangoHUD config

################################################################
### PERFORMANCE FIXES AND OPTIMIZATIONS
################################################################
# VRAM Management
export DXVK_CONFIG="dxgi.maxDeviceMemory = 10240;cachedDynamicResources = a;" # Set to your VRAM size in MB

# NVIDIA-specific optimizations
export PROTON_ENABLE_NVAPI=1           # Enable NVAPI support
export PROTON_ENABLE_NGX_UPDATER=1     # Enable NGX updater
export DXVK_NVAPI_DRS_NGX_DLSS_SR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_latest
export DXVK_ASYNC=1                    # Enable async shader compilation
export PROTON_HIDE_NVIDIA_GPU=0        # Make NVIDIA GPU visible

# Shader cache optimizations
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SIZE=10737418240 # 10GB cache size
export __GL_SHADER_DISK_CACHE_PATH="${WINEPFX}/shaders"
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

################################################################
### DEBUGGING OPTIONS (UNCOMMENT TO ENABLE)
################################################################
#export ENV_PRINT=1                    # Print all environment variables
#export UMU_LOG=debug                  # Enable UMU debugging
#export WINEDEBUG=-all                 # Reduce Wine debug messages

################################################################
### DEBUG OUTPUT (IF ENABLED)
################################################################
if [[ "${ENV_PRINT:-0}" -eq 1 ]]; then
    echo "### Printing all set variables ###"
    set
fi

################################################################
### LAUNCH STAR CITIZEN
################################################################
sleep 1
echo "Launching Star Citizen!"
echo "Wine Prefix: $WINEPFX"
echo "Proton Version: $PROTONPATH"
sleep 0.7

# Launch with nice priority
nice -10 umu-run "${WINEPFX}/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe"
