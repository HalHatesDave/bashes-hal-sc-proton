A super simple set of scripts I created to help install and run Star Citizen with UMU-Launcher and GE-Proton on **NVIDIA GPUs**.

hal-rsi-manager.sh will install the following two scripts, create shortcuts, and run them in succession:

hal-rsi-installer.sh will download and install RSI Launcher to /Games/star-citizen. After which you can run SC-Proton. !! Make sure to change WINEPFX in sc-proton.sh if wine prefix has been modified in sc-install.sh !!

hal-rsi-launcher.sh sets up some env that work well for me, then launches Star Citizen using UMU with a -10 niceness and a MangoHUD on the middle-left

Technically you can just use hal-rsi-installer and hal-rsi-launcher. In fact if you already have SC installed, you can just grab sc-proton and modify the WINEPFX variable to launch. Although hal-rsi-manager will become more useful as I iterate this project.

Note: This is meant for users with NVIDIA GPUs
