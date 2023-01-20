#!/bin/bash
#
# Reject pushes that contain commits with messages that do not adhere
# to the defined regex.

set -e

zero_commit='0000000000000000000000000000000000000000'
# matching title with:
# - JIRA ticket id (ex: RED-4322) followed by
# - optional scope (ex: core, io, ci, controlplane), only alphabetic characters allowed. followed by
# - a colon, followed by 1 space
#
# valid examples:
# - RED-124: my title
# - RED-456(core): my title
#
# invalid ones:
# - title without JIRA issue
# - RED-45:title, missing space
# - RED-45(): missing scope in parenthesis

msg_regex='^[A-Z]+\-[0-9]+(\([a-zA-Z]+\))?: '

while read -r oldrev newrev refname; do

    # Branch or tag got deleted, ignore the push
    [ "$newrev" = "$zero_commit" ] && continue

    # Check only pushes on main branch
    [ "${refname#refs/heads/}" != "main" ] && continue

    # Calculate range for new branch/updated branch
    [ "$oldrev" = "$zero_commit" ] && range="$newrev" || range="$oldrev..$newrev"

	for commit in $(git rev-list "$range" --not --all); do
		if ! git log --max-count=1 --format=%B $commit | grep -iqE "$msg_regex"; then
			echo "ERROR:"
			echo "ERROR: Your push was rejected because the commit"
			echo "ERROR: $commit in ${refname#refs/heads/}"
			echo "ERROR: is missing the JIRA Issue 'JIRA-123: description'."
			echo "ERROR:"
			echo "ERROR: Please fix the commit message and push again."
			echo "ERROR: https://help.github.com/en/articles/changing-a-commit-message"
			echo "ERROR"
			exit 1
		fi
	done

done
