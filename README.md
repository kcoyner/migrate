# migrate

A bash script to migrate an existing github repo to a new github repo, complete
with history, without damaging the original repo.

  	Usage:   
          $ ./migrate.sh  old_repo_name.git  new_repo_name

          $ ./migrate.sh -h || --help

**Important:**
The old repo name must end with the file type .git.
The new repo name does not need .git.

  	Example:
          $ ./migrate.sh  rpt01-n-queens.git  2017-06-n-queens

To use this program, your github username must
already be specified in your global ```.gitconfig```
file in your home directory.

You will be prompted for your github password during the execution of the
script.

Make sure this script is executable by running ```chmod +x ./migrate.sh```.

This script will create a new repo on github, complete with
the same commit history, from your original repo on github.

No repos will be created on your local system.
Your original github repo will remain untouched. 


January 2018

