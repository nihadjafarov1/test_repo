#!/bin/bash

# Stage all changes (modified, deleted, and new files)
git add -A

# Get a list of all staged files (including modifications, deletions, and additions)
staged_files=$(git diff --name-only --cached)

# Check if there are any staged files
if [ -z "$staged_files" ]; then
    echo "No files are staged for commit."
    exit 1
fi

# Commit each modified, deleted, and new file individually
for file in $staged_files; do
    echo "Staging and committing file: $file"
    
    # Stage the current file individually
    git add "$file"

    # Check the type of change (added, modified, or deleted)
    if git diff --cached --diff-filter=A --quiet -- "$file"; then
        commit_message="Add $file"
    elif git diff --cached --diff-filter=M --quiet -- "$file"; then
        commit_message="Update $file"
    elif git diff --cached --diff-filter=D --quiet -- "$file"; then
        commit_message="Delete $file"
    fi
    
    # Commit the file with the appropriate message
    echo "Committing: $commit_message"
    git commit -m "$commit_message"
done
