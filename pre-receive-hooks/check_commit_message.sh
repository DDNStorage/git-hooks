#!/bin/bash
#
# Reject pushes that contain commits with messages that do not adhere
# to the defined regex.

set -e

zero_commit='0000000000000000000000000000000000000000'
# matching title with:
# - length must be `<= 50` characters
# - must begin with a Jira ticket ref, in uppercase, like `RED-2312`, following by
# - optional `!` to notify that the commit introduce breaking changes, following by
# - optional scope in parenthesis, like `(docs)` or `(api)`, following by
# - colon + **space** `:&nbsp;`, followed by
# - your commit title

# valid examples:
# - RED-124: my title
# - RED-456(core): my title
# - RED-456!(core): my title
#
# invalid ones:
# - title without JIRA issue
# - RED-45:title, missing space
# - RED-45(): missing scope in parenthesis

# skip feature
# git push -o skip_commit_check=true
#
# will bypass checks
if [ "$GIT_PUSH_OPTION_0" = "skip_commit_check=true" ]; then
  echo "SKIPPING COMMIT CHECKS !!"
  exit 0
fi

title_regex='^((RED|REDQAS|REDOPS|REDDVOPS)\-[0-9]+)(!)?: (\{[a-zA-Z]+\})?'

while read -r oldrev newrev refname; do

    # Branch or tag got deleted, ignore the push
    [ "$newrev" = "$zero_commit" ] && continue

    # Check only pushes on main branch
    [ "${refname#refs/heads/}" != "main" ] && continue

    # Calculate range for new branch/updated branch
    [ "$oldrev" = "$zero_commit" ] && range="$newrev" || range="$oldrev..$newrev"

	for commit in $(git rev-list "$range" --not --all); do
	  # Check title
	  if ! git log --max-count=1 --format=%s $commit | grep -qP "$title_regex"; then
      echo "ERROR:"
      echo "ERROR: Your push was rejected because the commit message"
      echo "ERROR: does not follow our commit conventions. (problem in the title)."
      echo "ERROR: See https://github.red.datadirectnet.com/devops/git-hooks for details"
      echo "ERROR:"
      echo "ERROR: Refresh this page, fix the commit message and push again."
      echo "ERROR"
      exit 1
    fi
	done
done
