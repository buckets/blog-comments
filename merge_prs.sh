#!/bin/bash

if ! git remote | grep bot; then
  git remote add bot git@github.com:buckets-comments/blog-comments.git
fi

skipped=""
git fetch --prune bot >/dev/null 2>/dev/null
for branch in $(git branch --remotes --no-merged); do
  echo "-------------------------------------------------------"
  echo "$branch"
  git diff ...${branch}
  read -p "Press enter to keep. Type 'n' (or anything) to skip: " answer
  if [ -z "$answer" ]; then
    git merge --no-edit "${branch}"
  else
    echo skipping ${branch}
    skipped="${skipped} ${branch}"
  fi
done

if ! [ -z "$skipped" ]; then
  echo "=================================="
  echo "To delete comments (username: buckets-comments):"
  echo ""
  for branch in $skipped; do
    echo "git push bot ':$branch'"
  done
  echo ""
fi
