#!/bin/bash
clear
while true; do
    key=$(zenity --password --title "Power up your system with an upgrade." --text "Enter your CSI password." --width=400)
    if [ $? -ne 0 ]; then
        zenity --info --text="Operation cancelled. Exiting script." --width=400
        exit 1
    fi
    if echo "$key" | sudo -S -k -l &> /dev/null; then
        break # Exit loop if the password is correct
    else
        zenity --error --title="Authentication Failure" --text="Incorrect password or lack of sudo privileges. Please try again." --width=400
    fi
done
cd /tmp
SCRIPT_URL="https://raw.githubusercontent.com/CSILinux/CSILinux-Powerup/main/csitoolsupdate.sh"
curl -o csitoolsupdate.sh "$SCRIPT_URL" && chmod +x csitoolsupdate.sh
echo "Running update now..."
echo $key | sudo -S apt update
programs=(curl bpytop xterm aria2 yad zenity)
for program in "${programs[@]}"; do
    if ! which "$program" > /dev/null; then
        echo "$program is not installed. Attempting to install..."
        sudo apt-get install -y "$program"
    else
        echo "$program is already installed."
    fi
done
./csitoolsupdate.sh $key
