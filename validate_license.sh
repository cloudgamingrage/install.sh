#!/bin/bash

# URL of the licenses.txt file
license_url="https://raw.githubusercontent.com/cloudgamingrage/install.sh/refs/heads/main/license.txt"  # Replace with your actual URL

# Prompt user for their license key
read -p "Enter your license key: " user_license

# Fetch the licenses from the remote URL
license_list=$(curl -s "$license_url")

# Check if curl command succeeded
if [ $? -ne 0 ]; then
    echo "Error: Could not fetch license list from $license_url."
    echo "Please check your internet connection or the URL."
    exit 1
fi

# Check if the license list is empty
if [ -z "$license_list" ]; then
    echo "Error: License list is empty."
    exit 1
fi

# Validate the license
valid_license=false  # Flag to track if a valid license is found

echo "$license_list" | while IFS= read -r line; do
    line=$(echo "$line" | xargs)  # Trim leading/trailing whitespace
    if [ "$line" = "$user_license" ]; then
        valid_license=true  # Set the flag to true
        break  # Exit the loop
    fi
done

# Check the validity flag
if [ "$valid_license" = true ]; then
    echo "Valid license found. Proceeding with the operation."
    exit 0
else
    echo "Invalid license. Aborting operation."
    exit 1
fi
