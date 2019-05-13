#!/bin/bash

set -e
# exit on error

SCRIPTS_LOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
config=$SCRIPTS_LOC/config

if [ ! -f $config ]
then
    echo "ERROR: Could not find config file!"
    exit 1
else
    . $config
    # source config file 
fi

cd $HOME

if [ -z "$REPO" ]
then
    echo "ERROR: repo is not set"
    exit 1        
fi

if [ -z "$GIT_USER" ]
then
    echo "ERROR: github username is not set"
    exit 1        
fi

if [ -z "$NAME" ]
then
    echo "ERROR: your name is not set"
    exit 1        
fi

if [ -z "$EMAIL" ]
then
    echo "ERROR: github email is not set"
    exit 1        
fi

# source helper functions file
. $SCRIPTS_LOC/helper-functions.sh

update_libraries

python3 $SCRIPTS_LOC/sshkey.py $EMAIL

desc="${desc:-$(date +%D)}"
title="$(hostname) ($desc)"
path="${path:-$HOME/.ssh/id_rsa.pub}"
key_data="$(cat "$path")"

result="$(curl -u "$GIT_USER" \
    --data "{\"title\":\"$title\",\"key\":\"$key_data\"}" \
    https://api.github.com/user/keys
)"

ssh -T git@github.com
# check we have authentication
check_exit_code "Github not authenticated correctly" 255

# turn error checking back on
set -e

export dir=$HOME/$REPO

if [ -d $dir ]
then
    get_user_input "Operation will overwrite $REPO"
fi

# clean up space before cloning
sudo rm -rf $dir

# initialize into repo
ssh_git="git@github.com:"
repo="/${REPO}.git"

origin=$ssh_git$GIT_USER$repo
remote=${ssh_git}sdnfv${repo}

git clone $origin

echo "Setting git config globals"

cd $dir
git config --global user.name "$NAME" 
git config --global user.email $EMAIL

# add upstream configuration
git remote add upstream $remote
git fetch upstream

install_env
build_onvm

echo "Completed Initialization"
