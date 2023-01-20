# git-hooks
Git hooks

## Convention for RED development
See [confluence page](https://ime-ddn.atlassian.net/wiki/spaces/RED/pages/146145288/Commit+Messages)

## Implemented checks
### check_commit_message.sh

  > Check only pushes on `main` branch

Try to follow RED convention. What is implemented?  
#### For the commit title line
- length must be `<= 50` characters
- must begin with a Jira ticket ref, in uppercase, like `RED-2312`, following by
- optional `!` to notify that the commit introduce breaking changes, following by
- optional scope in parenthesis, like `(docs)` or `(api)`, following by
- colon + **space** `:&nbsp;`, followed by
- your commit title

Valid examples:
```
RED-124: my title
RED-456(core): my title
```
Invalid ones:
```
title without JIRA issue
RED-45:title, missing space
RED-45(): parenthesis with empty content
RED-1234!(docs): This commit introduce breaking changes but title too long
```

#### For the commit description
- length must be `<=72` characters


  Valid examples:
```
With this change, our customers can change cli language to Japanese,
Hindi, or russian, so all customers will be able to describe their
issues to QA-team.
```
Invalid ones:
```
With this change, our customers can change cli language to Japanese, Hindi, or
russian, so all customers will be able to describe their issues to QA-team.
```
