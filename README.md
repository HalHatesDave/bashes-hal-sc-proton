A super simple set of scripts I created to help install and run Star Citizen with UMU-Launcher and GE-Proton and a **NVIDIA GPU**.

halscript-sc-installer.sh will install the following two scripts, create shortcuts, and run them in succession:

SC-Install will download and install RSI Launcher to /Games/star-citizen. After which you can run SC-Proton. !! Make sure to change WINEPFX in sc-proton.sh if wine prefix has been modified in sc-install.sh !!

SC-Proton sets up some env that work well for me, then launches Star Citizen using UMU with a -10 niceness and a MangoHUD on the middle-left

Technically you can just use sc-install and sc-proton. In fact if you already have SC installed, you can just grab sc-proton and modify the WINEPFX variable to launch.

This is my first script that I actually use, so yay! :sunglas:
