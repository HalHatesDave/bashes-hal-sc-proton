#!/usr/bin/env bash
################################################################################################################################
###         hal-sc-manager.sh - Manages RSI Launcher installation and hal-sc-play script
###         Combines functionality of installation and launcher management
###
###         Usage:
###           Install:        ./hal-sc-manager.sh
###           Uninstall:      ./hal-sc-manager.sh --uninstall
###           Update Launcher: ./hal-sc-manager.sh --update
################################################################################################################################

# ASCII Art and startup message
echo -e "\n\033[1;33m
  ██╗  ██╗ █████╗ ██╗
  ██║  ██║██╔══██╗██║
  ███████║███████║██║
  ██╔══██║██╔══██║██║
  ██║  ██║██║  ██║███████╗
  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
\033[0m"
echo "hal-sc-manager.sh is now running..."
sleep 1

################################################################################################################################
# CONFIGURATION SECTION
################################################################################################################################

VERSION="2.0"
INSTALL_DIR="/usr/local/bin"           # System-wide install directory
USER_INSTALL_DIR="$HOME/.local/bin"    # User install directory
DESKTOP_DIR="/usr/share/applications"  # System start menu directory
USER_DESKTOP_DIR="$HOME/Desktop"       # User desktop directory
DESKTOP_NAME="Star-Citizen.desktop"    # Desktop shortcut name

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Launcher script name (now called hal-sc-play)
LAUNCHER_SCRIPT="hal-sc-play.sh"
GITHUB_LAUNCHER_URL="https://raw.githubusercontent.com/HalHatesDave/halscripts-starcitizen/main/hal-sc-play.sh"

# Default installation paths
DEFAULT_INSTALL_PATH="$HOME/Games/star-citizen"
DEFAULT_DOWNLOAD_DIR="$HOME/Downloads"
RSI_DOWNLOAD_SOURCE="https://install.robertsspaceindustries.com/rel/2/RSI%20Launcher-Setup-2.3.1.exe"

################################################################################################################################
# HAL SC PLAY INSTALLATION FUNCTIONS
################################################################################################################################

# Installs the hal-sc-play script to the target directory
install_hal_play() {
  echo -e "${GREEN}Installing hal-sc-play...${NC}"

  local target_dir="$1"
  mkdir -p "$target_dir"

  if [ ! -f "$SCRIPT_DIR/$LAUNCHER_SCRIPT" ]; then
    echo -e "${RED}Error: Missing $LAUNCHER_SCRIPT in package${NC}"
    return 1
  fi

  dest_name="${LAUNCHER_SCRIPT%.sh}"
  echo "Installing $LAUNCHER_SCRIPT as $dest_name..."
  install -m 755 "$SCRIPT_DIR/$LAUNCHER_SCRIPT" "$target_dir/$dest_name" || {
    echo -e "${RED}Failed to install $dest_name${NC}"
    return 1
  }
}

# Creates a desktop shortcut for the launcher
create_desktop_entry() {
  local target_dir="$1"
  local install_path="$2"
  echo -e "${YELLOW}Creating desktop shortcut...${NC}"

  cat > "$target_dir/$DESKTOP_NAME" <<EOF
[Desktop Entry]
Name=Star Citizen
Exec=$INSTALL_DIR/hal-sc-play --wineprefix "$install_path"
Icon=application-x-executable
Terminal=true
Type=Application
Categories=Games;
EOF

  chmod +x "$target_dir/$DESKTOP_NAME"
  if [ "$target_dir" = "$DESKTOP_DIR" ]; then
    update-desktop-database "$DESKTOP_DIR"
  fi
}

################################################################################################################################
# UNINSTALL FUNCTIONS
################################################################################################################################

# Removes all installed files and shortcuts
uninstall() {
  echo -e "${YELLOW}Uninstalling Star Citizen scripts...${NC}"

  # System-wide uninstall
  dest_name="${LAUNCHER_SCRIPT%.sh}"
  rm -f "$INSTALL_DIR/$dest_name" && echo "Removed $INSTALL_DIR/$dest_name"
  rm -f "$DESKTOP_DIR/$DESKTOP_NAME"
  [ -d "$DESKTOP_DIR" ] && update-desktop-database "$DESKTOP_DIR"

  # User-specific uninstall
  rm -f "$USER_INSTALL_DIR/$dest_name" && echo "Removed $USER_INSTALL_DIR/$dest_name"
  rm -f "$USER_DESKTOP_DIR/$DESKTOP_NAME"

  echo -e "${GREEN}Uninstallation complete!${NC}"
}

################################################################################################################################
# RSI INSTALLATION FUNCTION
################################################################################################################################

# Handles the actual RSI Launcher installation using UMU
install_rsi_launcher() {
  local install_path="$1"
  local download_dir="$2"

  FILENAME=$(basename "$RSI_DOWNLOAD_SOURCE")
  DEST_FILE="$download_dir/$FILENAME"

  echo "Downloading $FILENAME..."

  # Check if file exists and prompt for redownload
  if [[ -f "$DEST_FILE" ]]; then
      echo "File already exists: $DEST_FILE"
      read -p "Do you want to redownload it? (y/N): " choice
      case "$choice" in
          y|Y ) echo "Redownloading..."; rm "$DEST_FILE" ;;
          * ) echo "Using existing file." ;;
      esac
  fi

  # Download if file doesn't exist
  if [[ ! -f "$DEST_FILE" ]]; then
      echo "Downloading $FILENAME..."
      wget -O "$DEST_FILE" "$RSI_DOWNLOAD_SOURCE"

      if [[ $? -ne 0 ]]; then
          echo "Download failed!"
          return 1
      fi
  fi

  chmod +x "$DEST_FILE"

  # Set up environment variables for UMU
  echo "Applying ENV..."
  export WINEPREFIX="$install_path"
  export GAMEID="umu-starcitizen"
  export STORE=none
  export PROTONPATH="GE-Proton"

  # User instructions
  echo -e "\n${YELLOW}HEADS UP! After installing:${NC}"
  echo "1. In the launcher, change the game installation directory to:"
  echo "   Z:\\path\\to\\prefix\\drive_c\\Program Files\\Roberts Space Industries"
  echo "2. Remember to use Windows-style backslashes in the path"
  sleep 5

  # Launch the installer
  echo "Launching with UMU..."
  umu-run "$DEST_FILE" &
  UMU_PID=$!
  wait $UMU_PID
}

################################################################################################################################
# LAUNCHER UPDATE FUNCTION
################################################################################################################################

# Updates the hal-sc-play script from GitHub
update_launcher() {
  echo -e "${YELLOW}Checking for hal-sc-play script updates on GitHub...${NC}"

  # Temporary file for download
  TEMP_FILE=$(mktemp)

  # Download latest launcher from GitHub
  echo "Downloading latest launcher from GitHub..."
  if ! wget -q "$GITHUB_LAUNCHER_URL" -O "$TEMP_FILE"; then
    echo -e "${RED}Error: Failed to download launcher from GitHub${NC}"
    rm -f "$TEMP_FILE"
    return 1
  fi

  # Verify downloaded file looks like a script
  if ! grep -q '#!/usr/bin/env bash' "$TEMP_FILE"; then
    echo -e "${RED}Error: Downloaded file doesn't appear to be a valid script${NC}"
    rm -f "$TEMP_FILE"
    return 1
  fi

  # Find installed launcher locations
  local installed_locations=()
  if [ -f "$INSTALL_DIR/hal-sc-play" ]; then
    installed_locations+=("$INSTALL_DIR/hal-sc-play")
  fi
  if [ -f "$USER_INSTALL_DIR/hal-sc-play" ]; then
    installed_locations+=("$USER_INSTALL_DIR/hal-sc-play")
  fi

  if [ ${#installed_locations[@]} -eq 0 ]; then
    echo -e "${YELLOW}No installed launcher found - installing new one${NC}"
    installed_locations+=("$USER_INSTALL_DIR/hal-sc-play")
    mkdir -p "$USER_INSTALL_DIR"
  fi

  # Update all found installations
  for location in "${installed_locations[@]}"; do
    echo "Updating launcher at $location"
    install -m 755 "$TEMP_FILE" "$location" || {
      echo -e "${RED}Failed to update launcher at $location${NC}"
      rm -f "$TEMP_FILE"
      return 1
    }
  done

  rm -f "$TEMP_FILE"
  echo -e "${GREEN}Launcher updated successfully from GitHub!${NC}"
}

################################################################################################################################
# MAIN EXECUTION
################################################################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Handle uninstall
if [ "$1" = "--uninstall" ]; then
  uninstall
  exit 0
fi

# Handle launcher update
if [ "$1" = "--update" ]; then
  update_launcher
  exit 0
fi

# Check if Star Citizen is already installed
INSTALL_PATH="$DEFAULT_INSTALL_PATH"
if [ -d "$INSTALL_PATH" ]; then
  echo -e "${YELLOW}Star Citizen appears to be already installed at $INSTALL_PATH${NC}"
  echo "To reinstall, please remove the directory first or specify a different path"
  echo "To uninstall, run: $0 --uninstall"

  # Install/update launcher even if game is already installed
  if [ "$(id -u)" -eq 0 ]; then
    install_hal_play "$INSTALL_DIR" && create_desktop_entry "$DESKTOP_DIR" "$INSTALL_PATH"
  else
    echo -e "${YELLOW}Installing launcher for current user only (run as root for system-wide install)${NC}"
    install_hal_play "$USER_INSTALL_DIR" && create_desktop_entry "$USER_DESKTOP_DIR" "$INSTALL_PATH"
    echo -e "${YELLOW}Ensure $USER_INSTALL_DIR is in your PATH:${NC}"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\" >> ~/.bashrc"
  fi

  exit 0
fi

# Normal installation
echo -e "${GREEN}Proceeding with Star Citizen installation...${NC}"

# Install RSI Launcher and run it
install_rsi_launcher "$INSTALL_PATH" "$DEFAULT_DOWNLOAD_DIR"

# Install hal-sc-play launcher
if [ "$(id -u)" -eq 0 ]; then
  install_hal_play "$INSTALL_DIR" && create_desktop_entry "$DESKTOP_DIR" "$INSTALL_PATH"
else
  echo -e "${YELLOW}Installing launcher for current user only (run as root for system-wide install)${NC}"
  install_hal_play "$USER_INSTALL_DIR" && create_desktop_entry "$USER_DESKTOP_DIR" "$INSTALL_PATH"
  echo -e "${YELLOW}Ensure $USER_INSTALL_DIR is in your PATH:${NC}"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\" >> ~/.bashrc"
fi

echo -e "${GREEN}Installation complete!${NC}"
echo "Installed:"
echo "  Game at: $INSTALL_PATH"
echo "  Launcher at: $INSTALL_DIR/hal-sc-play or $USER_INSTALL_DIR/hal-sc-play"
echo ""
echo "A desktop shortcut to launch Star Citizen has been created"
echo ""
echo "To uninstall:"
echo "  sudo $0 --uninstall  # For system-wide install"
echo "  $0 --uninstall       # For user install"
echo ""
echo "To update the launcher:"
echo "  $0 --update"
