#!/usr/bin/env bash

#!/bin/bash --login

which rvm > /dev/null

if [[ $? -eq 0 ]]; then
  echo "RVM detected, forcing to use system ruby since xcodebuild cause error"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
  rvm use system
fi

if which rbenv > /dev/null; then
  echo "rbenv detected, removing env variables since xcodebuild cause error"
  rbenv shell system
fi

shell_session_update() { :; }

unset RUBYLIB
unset RUBYOPT
unset BUNDLE_BIN_PATH
unset _ORIGINAL_GEM_PATH
unset BUNDLE_GEMFILE
unset GEM_HOME
unset GEM_PATH

set -x
xcodebuild "$@"