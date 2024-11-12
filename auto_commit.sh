#!/bin/bash

# Stage all changes (modified, deleted, new files)
git add -A

# Get a list of all staged files (including modifications and deletions)
staged_files=$(git diff --name-only --cached)

# Commit each modified, deleted, and new file individually
for file in $staged_files; do
    if git diff --cached --diff-filter=A --name-only -- "$file"; then
        commit_message="Add $file"
    elif git diff --cached --diff-filter=M --name-only -- "$file"; then
        commit_message="Update $file"
    elif git diff --cached --diff-filter=D --name-only -- "$file"; then
        commit_message="Delete $file"
    fi
    
    # Commit the file with the appropriate message
    git commit -m "$commit_message"
done

