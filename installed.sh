#!/bin/bash

# Log file
log_file="installation_log.txt"

# Function to log messages
log_message() {
    echo "$(date) - $1" >> "$log_file"
}

# Check if log file exists, if not create one
touch "$log_file"

# Read each line from the file
while IFS= read -r app_name; do
    # Check if the application is installed
    if dpkg -s "$app_name" >/dev/null 2>&1; then
        echo "$app_name is already installed."
        log_message "$app_name is already installed."
    else
        echo "$app_name is not installed. Installing..."
        log_message "$app_name is not installed. Installing..."
        sudo apt-get install "$app_name" -y >> "$log_file" 2>&1
        if [ $? -eq 0 ]; then
            echo "$app_name installed successfully."
            log_message "$app_name installed successfully."
        else
            echo "Failed to install $app_name."
            log_message "Failed to install $app_name."
        fi
    fi
done < "all_apps.txt"
