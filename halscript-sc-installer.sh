#!/bin/bash
################################################################################################################################
###         halscript-sc installer script
###         Note: You can also just run sc-install.sh and then sc-proton-sh
################################################################################################################################
### Hello:
echo -e "\n\033[1;33m
  ██╗  ██╗ █████╗ ██╗
  ██║  ██║██╔══██╗██║
  ███████║███████║██║
  ██╔══██║██╔══██║██║
  ██║  ██║██║  ██║███████╗
  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
\033[0m"
echo "halscripts-sc tools installer script is now running..."
sleep 1
################################################################################################################################
VERSION="1.2"
INSTALL_DIR="/usr/local/bin"           # System-wide install
USER_INSTALL_DIR="$HOME/.local/bin"    # User install
DESKTOP_DIR="/usr/share/applications"  # System start menu
USER_DESKTOP_DIR="$HOME/Desktop"       # User desktop
DESKTOP_NAME="Star-Citizen.desktop"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Scripts to manage
SCRIPTS=("sc-install.sh" "sc-proton.sh")

################################################################################################################################
# INSTALLATION FUNCTIONS
################################################################################################################################

install_scripts() {
  echo -e "${GREEN}Installing halscript-sc${VERSION}...${NC}"

  local target_dir="$1"
  mkdir -p "$target_dir"

  for script in "${SCRIPTS[@]}"; do
    if [ ! -f "$SCRIPT_DIR/$script" ]; then
      echo -e "${RED}Error: Missing $script in package${NC}"
      continue
    fi

    dest_name="${script%.sh}"
    echo "Installing $script as $dest_name..."
    install -m 755 "$SCRIPT_DIR/$script" "$target_dir/$dest_name" || {
      echo -e "${RED}Failed to install $dest_name${NC}"
      return 1
    }
  done
}

create_desktop_entry() {
  local target_dir="$1"
  echo -e "${YELLOW}Creating desktop shortcut...${NC}"

  cat > "$target_dir/$DESKTOP_NAME" <<EOF
[Desktop Entry]
Name=Star Citizen
Exec=$INSTALL_DIR/sc-proton
Icon=application-x-executable
Terminal=true
Type=Application
Categories=Utility;
EOF

  chmod +x "$target_dir/$DESKTOP_NAME"
  if [ "$target_dir" = "$DESKTOP_DIR" ]; then
    update-desktop-database "$DESKTOP_DIR"
  fi
}

################################################################################################################################
# UNINSTALL FUNCTIONS
################################################################################################################################

uninstall_scripts() {
  echo -e "${YELLOW}Uninstalling halscript-sc...${NC}"

  # System-wide uninstall
  for script in "${SCRIPTS[@]}"; do
    dest_name="${script%.sh}"
    rm -f "$INSTALL_DIR/$dest_name" && echo "Removed $INSTALL_DIR/$dest_name"
  done
  rm -f "$DESKTOP_DIR/$DESKTOP_NAME"
  [ -d "$DESKTOP_DIR" ] && update-desktop-database "$DESKTOP_DIR"

  # User-specific uninstall
  for script in "${SCRIPTS[@]}"; do
    dest_name="${script%.sh}"
    rm -f "$USER_INSTALL_DIR/$dest_name" && echo "Removed $USER_INSTALL_DIR/$dest_name"
  done
  rm -f "$USER_DESKTOP_DIR/$DESKTOP_NAME"

  echo -e "${GREEN}Uninstallation complete!${NC}"
}

################################################################################################################################
# MAIN EXECUTION
################################################################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Handle uninstall
if [ "$1" = "--uninstall" ]; then
  uninstall_scripts
  exit 0
fi

# Normal installation
if [ "$(id -u)" -eq 0 ]; then
  install_scripts "$INSTALL_DIR" && create_desktop_entry "$DESKTOP_DIR"
else
  echo -e "${YELLOW}Installing for current user only (run as root for system-wide install)${NC}"
  install_scripts "$USER_INSTALL_DIR" && create_desktop_entry "$USER_DESKTOP_DIR"
  echo -e "${YELLOW}Ensure $USER_INSTALL_DIR is in your PATH:${NC}"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\" >> ~/.bashrc"
fi
echo -e "${GREEN}Installation complete!${NC}"
echo "Installed:"
echo "  $INSTALL_DIR/sc-install"
echo "  $INSTALL_DIR/sc-proton"
echo ""
sleep 1
echo "sc-install will now run"
echo ""
sleep 1
echo "A desktop shortcut to launch Star Citizen has been created"
echo ""
echo "To uninstall:"
echo "  sudo $0 --uninstall  # For system-wide install"
echo "  $0 --uninstall       # For user install"
sleep 1
echo "Running sc-install.sh to install RSI Launcher"
echo -e "\n\033[1;36mVerifying installation...\033[0m"
sleep .8
################################################################################################################################
# Run sc-install
################################################################################################################################
# Check if sc-install is in PATH
if command -v sc-install &>/dev/null; then
    echo -e "\033[1;32msc-install is already available in PATH\033[0m"
    echo -e "\n\033[1;33mLaunching sc-install...\033[0m"
    sc-install
else
    # Check for local sc-install.sh
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SC_INSTALL_SH="$SCRIPT_DIR/sc-install.sh"

    if [[ -f "$SC_INSTALL_SH" ]]; then
        echo -e "\033[1;33msc-install not in PATH, but found local script\033[0m"
        echo -e "\n\033[1;33mLaunching sc-install.sh...\033[0m"
        chmod +x "$SC_INSTALL_SH"
        "$SC_INSTALL_SH"
    else
        echo -e "\033[1;31mError: sc-install not found in PATH or locally\033[0m"
        echo "You may need to manually add the installation directory to your PATH or download sc-install and place it next to this file"
    fi
fi

sleep .7
echo -e "\n\033[1;32m halscript-sc install complete!\033[0m"
################################################################################################################################
