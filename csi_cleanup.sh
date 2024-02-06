key=csi
disable_services() {
    # Define a list of services to disable
    local disableservices=(
        "systemd-networkd-wait-online.service"
    "NetworkManager-wait-online.service"
    "apache-htcacheclean.service"
        "apache-htcacheclean@.service"
        "apache2.service"
        "apache2@.service"
        "bettercap.service"
        "clamav-daemon.service"
        "clamav-freshclam.service"
    "clamav-milter.service"
        "cups-browsed.service"
        "cups.service"
        "dnsmasq.service"
        "dnsmasq@.service"
        "i2p"
        "i2pd"
        "kismet.service"
        "lokinet"
        "lokinet-testnet.service"
        "openfortivpn@.service"
        "openvpn-client@.service"
        "openvpn-server@.service"
        "openvpn.service"
        "openvpn@.service"
        "privoxy.service"
        "rsync.service"
    "systemd-networkd-wait-online.service"
        "NetworkManager-wait-online.service"
    "xl2tpd.service"
    )

    # Iterate through the list and disable each service
    for service in "${disableservices[@]}"; do
        echo "Disabling $service..."
        echo $key | sudo -S systemctl disable "$service" > /dev/null 2>&1
        echo $key | sudo -S systemctl stop "$service" > /dev/null 2>&1
        echo "$service disabled successfully."
    done
}

remove_specific_files() {
    echo $key | sudo -S rm -rf /etc/apt/"$1"
}

disable_services

remove_specific_files sources.list.d/archive_u*
remove_specific_files sources.list.d/brave*
remove_specific_files sources.list.d/signal*
remove_specific_files sources.list.d/wine*
remove_specific_files trusted.gpg.d/wine*
remove_specific_files trusted.gpg.d/brave*
remove_specific_files trusted.gpg.d/signal*

echo $key | sudo -S apt update
echo $key | sudo -S apt remove sleuthkit
echo $key | sudo -S apt upgrade -y
echo $key | sudo -S apt dist-upgrade -y
echo $key | sudo -S apt full-upgrade -y

if dpkg --print-foreign-architectures | grep -q 'i386'; then
    echo "# Cleaning up old Arch"
    i386_packages=$(dpkg --get-selections | awk '/i386/{print $1}')
    if [ ! -z "$i386_packages" ]; then
        echo "Removing i386 packages..."
        echo $key | sudo -S apt remove --purge --allow-remove-essential -y $i386_packages > /dev/null 2>&1
    fi
    echo "# Standardizing Arch"
    echo $key | sudo -S dpkg --remove-architecture i386
fi
echo $key | sudo -S apt autoremove 
Then run the powerup code:

#!/bin/bash
clear
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
output_file="/tmp/powerup-$timestamp.txt"

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
echo "Running update now..." | tee "$output_file"



./csitoolsupdate.sh $key | tee -a "$output_file"
