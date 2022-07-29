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
