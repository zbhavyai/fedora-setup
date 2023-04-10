## Updating files

1. After the repository has been cloned locally on the machine, make the required changes

1. Run below command to check what files have been modified, added or deleted

   ```shell
   $ git status
   ```

1. If new files are added, they are shown as untracked. Use this command to track them too

   ```shell
   $ git add filepath/filename1 ...          # to add specific files

   $ git add .                               # to add all of them at once
   ```

1. Commit the changes locally using this command

   ```shell
   $ git commit -m "message title" -m "message description"
   ```

1. If user and email are not set in `.gitconfig` file, then name and email address were configured automatically based on your username and hostname from the operating system

   You will get message like this

   > Committer: FirstName LastName <username@hostname>
   > Your name and email address were configured automatically based
   > on your username and hostname. Please check that they are accurate.
   > You can suppress this message by setting them explicitly. Run the
   > following command and follow the instructions in your editor to edit
   > your configuration file:
   >
   > `git config --global --edit`
   >
   > After doing this, you may fix the identity used for this commit with:
   >
   > `git commit --amend --reset-author`

1. If a commit message contains unclear, incorrect, or typos, you can amend it locally and push a new commit. You can also change a commit message to add missing information.

   To rewrite most recent commit message

   ```shell
   $ git commit --amend
   ```

   Then in the editor, make the changes, and save it.

1. Push the changes
   ```shell
   $ git push origin main
   ```

## Creating Repositories locally

1. Navigate to the folder which you want to convert to a git repository

1. Run below command to convert it to git repository

   ```shell
   $ git init
   ```

1. After the files have been added/modified/deleted, run usual commands

   ```shell
   $ git add .
   $ git commit -m "message title" -m "message description"
   ```

1. Now where to exactly push these files to? Since this repository was not cloned from GitHub, you need to supply the remote location where to push

1. Create an empty GitHub repository, and copy the SSH url

1. Run below command to add reference to the remote repository

   ```shell
   $ git remote add origin git@github.com:username/reponame.git
   ```

1. Verify using the above step

   ```shell
   $ git remote -v
   ```

1. Now push the files to the GitHub via either of below commands

   ```shell
   $ git push origin main

   $ git push -u origin main        # using -u will set the upstream, to prevent using "origin main" again
   ```

## Branching

1. Check all available branches using below command. Highlighted branch is the current branch

   ```shell
   $ git branch
   ```

1. Create new branch using below commands. You shall be automatically switched to the newly created branch

   ```shell
   $ git checkout -b <branchname>

   # examples,
   $ git checkout -b feature/awesomeNewFeature
   $ git checkout -b awesome-new-feature
   ```

1. Manually switch branches

   ```shell
   $ git checkout new-branch-name
   ```

1. Changes "done -> added -> committed" to one branch (don't switch branches in between the process), will not reflect in the other branch

   ```shell
   $ git checkout feature/test
   $ ls /etc/ > README.md
   $ git add .
   $ git commit -m "some changes"
   ```

1. You can merge the feature branch to main branch using

   ```shell
   $ git checkout main
   $ git merge feature/test
   ```

1. But you can't always merge to the main branch. May be its rights are controlled by someone else, and changes are accepted only after review

1. So, rather, push the changes you have done in the feature branch

   ```shell
   $ git push -u origin feature/test

   $ git push --set-upstream origin feature     # same as above statement
   ```

1. Now, the changes have been reflected on GitHub as a new branch `feature/test`

1. Pull request is basically a request to pull code into another branch.
   Once we have made a pull request, anyone can review our code, comment on it, ask us to make changes.
   Usually feature branches are deleted once code is merged

1. Go to GitHub, click the button "Compare & pull request".
   Add some comments under "Write" section, and click "Create pull request"

1. On the new screen, now you can see Commits you have made, files that are changed, add comment per line per file, etc.

1. To finally merge, click "Merge pull request", and then "Confirm merge"

1. With this, changes are merged to main branch on GitHub, but local main branch has still the old files

1. Update local repo using

   ```shell
   $ git pull origin main
   ```

1. Now you can delete local branch using

   ```shell
   $ git branch -d feature/test
   ```

1. Branch is deleted from local git, to remove from GitHub
   ```shell
   $ git push -d origin feature/test
   ```

## Git Tagging

Create a tag locally on the current commit

```shell
$ git tag -a v1.5 -m "my version 1.5"
```

Create a tag on the previous commit - get the checksum using `git log --pretty=oneline`

```shell
$ git tag -a v1.5 9fceb02
```

Pushing tags to remote server

```shell
$ git push origin v1.5           # transfer a single tag v1.5

$ git push origin --tags         # transfer all tags at once
```

Deleting tags locally

```shell
$ git tag -d v1.5
```

Delete tags from remote server after deleting locally

```shell
$ git push origin :refs/tags/v1.5         # basically pushing null to remote tag, and thereby deleting it

$ git push origin --delete v1.5           # intuitive way
```

## Commands Reference

| Command                                  | Description                                                                     |
| ---------------------------------------- | ------------------------------------------------------------------------------- |
| `git clone <HTTPS/SSH>`                  | copy a remote repository into local machine using HTTPS/SSH url                 |
| `git init`                               | initialize a new folder as a git repository                                     |
| `git status`                             | ask git to check the overall status of all changes made                         |
| `git add filename`                       | tell git to track your files and changes in Git                                 |
| `git commit -m "title" -m "description"` | save your files in Git in the current branch                                    |
| `git push`                               | update Git commits to a remote repository like GitHub                           |
| `git pull`                               | download changes from remote repository to your local machine, opposite of push |
| `git remote -v`                          | check from where you are fetching files and where you are pushing them          |
| `git checkout -b new-branch-name`        | create new branch called "new-branch-name"                                      |
| `git checkout branch-name`               | switch to branch called "branch-name"                                           |
| `git diff other-branch-name`             | see changes of current branch wrt to "other-branch-name"                        |
| `git branch -d branch-name`              | deletes the branch if it has already been fully merged in its upstream branch   |
| `git branch -D branch-name`              | force deletes the branch "irrespective of its merged status"                    |
| `git restore`                            | discard the changes that have been made to local files                          |
| `git remote add origin <HTTPS/SSH>`      | add GitHub link to the locally created repository                               |

## Open Source Licenses

Know more about [open source license](Open_Source_License.md) and how they work
