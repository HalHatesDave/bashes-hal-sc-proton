A super simple set of scripts I created to help install and run Star Citizen with UMU-Launcher and GE-Proton on **NVIDIA GPUs**.

hal-sc-manager.sh will by default install the hal-sc-play script, create shortcuts, then download install and run RSI Installer. After which you can run hal-sc-play in a terminal or just Starcitizen from your desktop/start menu. 

hal-sc-play.sh sets up some env that work well for me, then launches Star Citizen using UMU with a -10 niceness. You can edit the script to enable mangoHUD if you use it. 

# Note: This is meant for users with NVIDIA GPUs

Distros:

Debian	✅	Install umu-run manually.
Ubuntu	✅	Same as Debian.
Arch	✅	Works out-of-the-box with AUR umu.
Fedora	⚠️	May need desktop-file-utils and wget.
