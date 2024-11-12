#!/bin/bash

# Stage all changes (modified, deleted, and new files)
git add -A

# Get a list of staged files (modified, deleted, and new)
staged_files=$(git status --porcelain | grep -E '^[AMDR]' | cut -c 4-)

# Check if there are any staged files
if [ -z "$staged_files" ]; then
    echo "No files are staged for commit."
    exit 1
fi

# Commit each modified, deleted, and new file individually
for file in $staged_files; do
    echo "Staging and committing file: $file"
    
    # Unstage all files first
    git reset

    # Stage the current file individually
    git add "$file"

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
    echo "Committing: $commit_message"
    git commit -m "$commit_message"
done
