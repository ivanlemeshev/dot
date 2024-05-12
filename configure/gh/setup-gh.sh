#!/bin/bash

echo "--- Configuring GitHub CLI"
gh config set editor vim
gh config set pager less
gh config set git_protocol ssh --host github.com

echo "--- Current GitHub CLI config"
gh config list
