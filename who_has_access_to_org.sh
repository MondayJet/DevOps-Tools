#!/bin/bash

# =========================
# Script: GitHub Access Checker
# Description:
# This script lists users with read access (pull permissions) to a specified GitHub repository.
#
# Version : v0.0.1
# Usage:
#   ./script_name.sh <REPO_OWNER> <REPO_NAME>
#   - REPO_OWNER: GitHub username or organization name owning the repository.
#   - REPO_NAME: Repository name.
#
# Requirements:
#   - curl: For making HTTP requests.
#   - jq: For parsing JSON responses.
#   - GitHub Personal Access Token (PAT) with appropriate permissions.
#
# Author: John Monday
# =========================

# GitHub API Base URL
API_URL="https://api.github.com"

# GitHub username and personal access token (set these as environment variables for security)
USERNAME=${username}
TOKEN=${token}

# User and Repository information
REPO_OWNER=$1  # The first command-line argument specifies the repository owner
REPO_NAME=$2   # The second command-line argument specifies the repository name

# Function: Display help message
function display_help {
    echo "GitHub Access Checker"
    echo "Usage: $0 <REPO_OWNER> <REPO_NAME>"
    echo "Example: $0 octocat Hello-World"
    echo "Ensure 'username' and 'token' are exported as environment variables."
}

# Function: Validate prerequisites
function validate_inputs {
    if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
        echo "Error: GitHub username and token are not set."
        echo "Please export 'username' and 'token' as environment variables."
        exit 1
    fi

    if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
        echo "Error: Missing arguments."
        display_help
        exit 1
    fi
}

# Function: Make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    response=$(curl -s -u "${USERNAME}:${TOKEN}" "$url")

    if [[ -z "$response" ]]; then
        echo "Error: Failed to fetch data from GitHub API."
        exit 1
    fi

    echo "$response"
}

# Function: List users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators=$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')
    # You can edit the line above to show users with admin, push permission etc i.e (.permission.admin ==true)

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main Script Execution
echo "===================================="
echo " GitHub Access Checker Script"
echo "===================================="

# Validate inputs and prerequisites
validate_inputs

# List users with read access
echo "Fetching users with read access to the repository..."
list_users_with_read_access

echo "===================================="
echo " Script Execution Completed"
echo "===================================="
