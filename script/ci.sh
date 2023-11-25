#!/bin/bash
# echo $1 $2 $3 $4
TOKEN=$1
# repoNwo=$2
remote=`git remote |head -1`
repoNwo=`git remote get-url $remote | sed 's/.*://;s/\.git//'`
branch=$(git rev-parse --abbrev-ref HEAD) # 或 git rev-parse HEAD
file_path=$2
encoded_file_content=$(base64 < "$file_path")
message_headline=$3
message_body="Signed-off-by: 沙漠之子 <7850715+maboloshi@users.noreply.github.com>"
expectedHeadOid=$(git rev-parse HEAD)

curl $GITHUB_GRAPHQL_URL --silent \
     # GITHUB_GRAPHQL_URL= https://api.github.com/graphql
     # echo HTTP status to demonstrate how GraphQL
     # uses HTTP a mere RPC transport, response is 200 OK
     # no matter what errors happen.
     --write-out '%{stderr}HTTP status: %{response_code}\n\n'
     -H "Authorization: bearer $TOKEN" \
     --data @- <<GRAPHQL | jq
{
  "query": "mutation (\$input: CreateCommitOnBranchInput!) {
    createCommitOnBranch(input: \$input) {
      commit {
        url
      }
    }
  }",
  "variables": {
    "input": {
      "branch": {
        "repositoryNameWithOwner": "$repoNwo",
        "branchName": "$branch"
      },
      "message": {
        "headline": "$message_headline"
        "body": "$message_body"
      },
      "fileChanges": {
        "additions": [
          {
            "path": "$file_path",
            "contents": "$encoded_file_content"
          }
        ]
      },
      "expectedHeadOid": "$expectedHeadOid"
    }
  }
}
GRAPHQL