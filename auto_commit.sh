#!/bin/bash

# Get a list of all changed files (staged or unstaged)
changed_files=$(git diff --name-only)

# Loop through each changed file and create an individual commit
for file in $changed_files; do
    # Stage the current file only
    git add "$file"
    
    # Determine the type of change for the file (Added, Modified, or Deleted)
    if git diff --cached --diff-filter=A --quiet -- "$file"; then
        commit_message="Add $file"
    elif git diff --cached --diff-filter=M --quiet -- "$file"; then
        commit_message="Update $file"
    elif git diff --cached --diff-filter=D --quiet -- "$file"; then
        commit_message="Delete $file"
    else
        commit_message="Update $file"
    fi

    # Commit the current file with its specific commit message
    git commit -m "$commit_message"
done
