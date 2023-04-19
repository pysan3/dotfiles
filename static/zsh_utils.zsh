#!/usr/bin/env zsh

### Spinner on Output
# ```bash
# while [[ $(ps -eF --user $USER | grep '1-create_data.sh' | wc -l) -ge 2 ]]; do
#   spin 'waiting for 1-create_data to finish'
#   sleep 1
# done
# endspin '1-create_data is done. Starting working on it'
# ```
spinners="●∙∙""∙●∙""∙∙●""∙∙∙"
counter=0; spinner_len=3
spin() {
  printf "\r${spinners:counter:spinner_len} $1"
  counter=$((counter+spinner_len))
  [[ $counter -ge ${#spinners} ]] && counter=0
}
endspin() {
  printf "\r%s\n" "$@"
}

### Get Info from URL
# ```bash
# get_url_info "$HTTP_PROXY" 'host' # http://username:password@proxy.example.com:8080 => proxy.example.com
# get_url_info "$HTTP_PROXY" 'port' # http://username:password@proxy.example.com:8080 => 8080
# get_url_info "$HTTP_PROXY" 'name' # http://username:password@proxy.example.com:8080 => username
# ```
function get_url_info () {
  proxy="$(echo "$1" | sed -e 's,https*://,,g')"
  url="${proxy##*@}"
  host="${url%%:*}"
  port="${url##*:}"
  user="${proxy%%@*}"
  name="${user%%:*}"
  pass="${user##*:}"
  eval 'echo $'"$2"
}

### Update git commit author and email
# https://zenn.dev/flyingbarbarian/articles/241627cae5988a
function update_git_commits () {
  # Command to overwrite all commits
  git filter-branch --force --env-filter '
        # GIT_AUTHOR_NAME
        if [ "$GIT_AUTHOR_NAME" = "prior author name" ];
        then
                GIT_AUTHOR_NAME="changed author name";
        fi
        # GIT_AUTHOR_EMAIL
        if [ "$GIT_AUTHOR_EMAIL" = "prior author email" ];
        then
                GIT_AUTHOR_EMAIL="changed author email";
        fi
        # GIT_COMMITTER_NAME
        if [ "$GIT_COMMITTER_NAME" = "prior committer name" ];
        then
                GIT_COMMITTER_NAME="changed committer name";
        fi
        # GIT_COMMITTER_EMAIL
        if [ "$GIT_COMMITTER_EMAIL" = "prior committer email" ];
        then
                GIT_COMMITTER_EMAIL="changed committer email";
        fi
        ' -- --all
  # Delete generated backup
  git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
  # Force apply to remote
  git push --all --force origin
}
