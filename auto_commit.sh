#!/bin/bash

# Check if a directory argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_git_repository>"
    exit 1
fi

# Navigate to the provided directory
cd "$1" || { echo "Failed to change directory to $1"; exit 1; }

# Check if the directory is a Git repository
if [ ! -d ".git" ]; then
    echo "This is not a Git repository. Please provide a valid Git repository path."
    exit 1
fi

# Stage all changes (modified, deleted, and new files)
git add -A > /dev/null 2>&1

# Get a list of staged files (modified, deleted, and new)
staged_files=$(git status --porcelain | grep -E '^[AMDR]' | cut -c 4-)

# Check if there are any staged files
if [ -z "$staged_files" ]; then
    echo "No files are staged for commit."
    exit 1
fi

# Commit each modified, deleted, and new file individually
for file in $staged_files; do
    # Unstage all files first
    git reset > /dev/null 2>&1

    # Stage the current file individually
    git add "$file" > /dev/null 2>&1

    # Check the type of change (added, modified, or deleted)
    file_status=$(git status --porcelain "$file" | cut -c 1-2)

    if [ "$file_status" == "A " ]; then
        commit_message="Add $file"
    elif [ "$file_status" == "M " ]; then
        commit_message="Update $file"
    elif [ "$file_status" == "D " ]; then
        commit_message="Delete $file"
    fi

    # Commit the file with the appropriate message
    git commit -m "$commit_message" > /dev/null 2>&1

    # Print only the commit message
    echo "$commit_message"
done
