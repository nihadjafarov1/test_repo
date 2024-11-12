#!/bin/bash

# Stage all changes: modified, deleted, and new files
git add -A

# Get a list of staged files
changed_files=$(git diff --name-only --cached)

# Initialize an empty commit message
commit_message=""

# Loop through each changed file to create a message
for file in $changed_files; do
    # Check if the file is newly added, modified, or deleted
    if git diff --cached --diff-filter=A --quiet -- "$file"; then
        commit_message+="Added $file\n"
    elif git diff --cached --diff-filter=M --quiet -- "$file"; then
        commit_message+="Modified $file\n"
    elif git diff --cached --diff-filter=D --quiet -- "$file"; then
        commit_message+="Deleted $file\n"
    fi
done

# If commit message is empty, use a default message
if [ -z "$commit_message" ]; then
    commit_message="Updated files"
fi

# Commit with the generated message
git commit -m "$(echo -e "$commit_message")"
