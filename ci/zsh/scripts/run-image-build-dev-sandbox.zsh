#!/bin/zsh

emulate -LR zsh
setopt errexit pipefail
autoload -Uz fn-exit-with

##[>] 🤖🤖
typeset repo_root=$(git -C ${0:A:h} rev-parse --show-toplevel)
#[why] default base is the local ci-linux build; set BASE_IMAGE to a published ref to skip building it
typeset base=${BASE_IMAGE:-ci-linux:local}
typeset configs_sha=${CONFIGS_SHA:-$(git ls-remote https://gitlab.com/konradodwrot/configs.git main | cut -f1)}

(( $+commands[docker] )) || fn-exit-with 1 "${0:t}: docker not found"

docker build \
  --file $repo_root/ci/dev-sandbox/Dockerfile \
  --build-arg BASE_IMAGE=$base \
  --build-arg CONFIGS_SHA=$configs_sha \
  --tag dev-sandbox:local \
  $repo_root
##[<] 🤖🤖
