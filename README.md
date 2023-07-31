# git-hooks
Git hooks

## Convention for RED development
See [confluence page](https://ime-ddn.atlassian.net/wiki/spaces/RED/pages/146145288/Commit+Messages)

## Implemented checks
### check_commit_message.sh

  > Check only pushes on `main` branch

Try to follow RED convention. What is implemented?  
#### For the commit title line
- must begin with a Jira ticket ref, in uppercase, like `RED-2312`, following by
- optional `!` to notify that the commit introduce breaking changes, following by
- colon + **space** `:&nbsp;`, followed by
- optional scope in brackets, like `{docs}` or `{redsetup, redapi}`, following by
- your commit title

Valid examples:
```
RED-124: my title
RED-456: {core} my title
RED-1234!: This commit introduce breaking changes
```
Invalid ones:
```
title without JIRA issue
RED-45:title, missing space
RED-45: {} brackets with empty content
```
