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

# Create a temporary file to hold the license list
temp_file=$(mktemp)
echo "$license_list" > "$temp_file"

# Initialize a flag for valid license
valid_license_found=false

# Validate the license by checking each line in the temporary file
while IFS= read -r line; do
    line=$(echo "$line" | xargs)  # Trim leading/trailing whitespace
    if [ "$line" = "$user_license" ]; then
        echo "Valid license found. Proceeding with the operation."
        valid_license_found=true  # Set flag to true if a valid license is found
        break  # Exit the loop immediately after finding a valid license
    fi
done < "$temp_file"  # Read from the temporary file

# Clean up the temporary file
rm "$temp_file"

# Check if a valid license was found
if [ "$valid_license_found" = true ]; then
    exit 0  # Exit with success
else
    echo "Invalid license. Aborting operation."
    exit 1  # Exit with error if no valid license was found
fi
