#!/bin/bash

# Log file
log_file="installed_log.txt"
log_file="installed_core_log.txt"

# Function to log messages
log_message() {
    echo "$(date) - $1" >> "$log_file"
}

# Function to trim whitespace
trim() {
    local var=$1
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# Check if log file exists, if not create one
touch "$log_file"

# count the number of lines in app list
total_lines=$(wc -l < "all_apps.txt")

# initialize counters
installed_count=0
not_installed_count=0
current_line=1

# Initialize arrays for installed and not installed applications
installed_apps=()
not_installed_apps=()

# Read each line from the all_apps.txt file
while IFS= read -r app_name || [[ -n "$app_name" ]]; do
    # Trim whitespace from app_name
    app_name=$(trim "$app_name")
    
    # Check if the application is installed
    if dpkg -s "$app_name" >/dev/null 2>&1; then
    #if dpkg -l | grep "^ii" | grep -q "$app_name"; then
        echo "($current_line/$total_lines) - $app_name is already installed."
        log_message "($current_line/$total_lines) - $app_name is already installed."
        ((installed_count++))
    else
        echo "($current_line/$total_lines) - $app_name is not installed."
        log_message "($current_line/$total_lines) - $app_name is not installed."
        ((not_installed_count++))
    fi

    # Add a delay in seconds
    sleep 1
done < "all_apps.txt"

# Print the list of installed applications
echo "Installed applications:  $installed_count"

# Print the list of not installed applications
echo "Not installed applications:  $not_installed_count"
