#!/bin/sh

# Files: migrate.sh
# Copyright: 2018 Kevin Coyner <kevin@rustybear.com>
# License: GPL-3+

set -e

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  cat << EOM

  Usage:   $0  old_repo_name.git  new_repo_name

  Important:
   The old repo name must end with the file type .git.
   The new repo name does not need .git.

  Example: $0  rpt01-n-queens.git  2017-06-n-queens

  To use this program, your github username must
  already be specified in your global .gitconfig
  file in your home directory.

  Make sure this script is executable by running

    chmod +x ./migrate.sh

  This script will create a new repo on github, complete with
  the same commit history, from your original repo on github.

  No repos will be created on your local system.

EOM
  exit 0
fi

old_repo_name=$1
new_repo_name=$2
dir_name=`basename $(pwd)`

if [[ "$old_repo_name" == "" ]]; then
  echo "You did not specify an old repo name. Try again."
  exit 1
fi

if [[ "$new_repo_name" == "" ]]; then
  echo "New repo name ?\n(or hit enter to use $dir_name as a new repo name)"
  read new_repo_name
fi

if [[ "$new_repo_name" == "" ]]; then
  new_repo_name=$dir_name
fi

username=`git config github.user`
if [[ "$username" = "" ]]; then
  echo "Could not find username, run 'git config --global github.user <username>'"
  exit 1
fi

git clone --bare https://github.com/$username/$old_repo_name || (echo "fatal: Could\
 not find your old repo on github or you do not have access rights to it." && exit 1)

if [[ -f "/usr/bin/curl" ]]; then
  /usr/bin/curl -s -u $username https://api.github.com/user/repos \
  -d "{\"name\":\"$new_repo_name\"}" || \
  (echo "fatal: Could not create a new repo on github." && exit 1)
else
  echo "Error:  You must have 'curl' installed on your system."
  rm -rf $old_repo_name || (echo "fatal: Could not remove the old repo." && exit 1)
  exit 1
fi

cd $old_repo_name || (echo "fatal: Could not change directories." && exit 1)

git push --mirror https://github.com/$username/$new_repo_name || \
  (echo "fatal: Could not populate your new repo with data." && exit 1)

(cd .. && rm -rf $old_repo_name) || (echo "fatal: Could not remove the old repo." && exit 1)

cat << EOM

  Success!

  A new repo called $new_repo_name now exists in your $username github account.

  Your original repo $old_repo_name also remains in your github account.

  Bye!
EOM
exit 0

