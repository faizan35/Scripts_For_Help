#!/bin/bash

# File path for the TOKEN file
TOKEN_FILE="$(dirname "$0")/TOKEN"

# Check if TOKEN file exists
if [ ! -f "$TOKEN_FILE" ]; then
    echo "TOKEN file not found!"
    exit 1
fi

# Read the token from the TOKEN file
TOKEN=$(cat "$TOKEN_FILE")

# Build the complete command with the token and verbosity level
full_command="sudo $TOKEN --v=5"

# Execute the final command
eval "$full_command"




# #!/bin/bash

# # Check if the join command is provided
# if [ "$#" -lt 1 ]; then
#     echo "Usage: $0 <user_command>"
#     exit 1
# fi

# # Perform pre-flight checks
# sudo kubeadm reset pre-flight checks

# # Extract the user-specific command from the arguments
# user_command="$1"

# # Build the complete command
# full_command="sudo $user_command --v=5"

# # Execute the final command
# eval "$full_command"
