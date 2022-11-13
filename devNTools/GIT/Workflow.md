# Git workflow stuff

## Reference

<https://map.sitecore.net/Processes/Engineering/Development/Sitecore%20Code%20Quality%20Model/>
​
<https://www.atlassian.com/git/tutorials/comparing-workflows>
​

## Start new feature

1. Branch out from master to feature/XXXXX
2. Develop on branch  feature/XXXXX
3. Test branch feature/XXXXX
4. Create PR feature/XXXXX -> master
5. PR review
6. Merge
7. Branch feature/XXXXX deleted
<https://sitecore.box.com/s/0vacsq4ivq6hf26z0q3pxlbvdcdagqpb>

## Use case : develop a feature: provision azure function app

```c#
# get latest clean code for master
git fetch origin, git checkout master, git pull

# checkout out to a new feature branch and start working
git checkout -b feature/234233-functionapp
git push --set-upstream origin feature/234233-functionapp

# feature work in progress (continous till feature is complete)
git add . && git commit
git push #git pull if remote branch have latest changes

# Getting ready to do pull request
git checkout master, git pull
git checkout feature/234233-functionapp, git merge master

# pull request in TFS
# New Pull request: feature/234233-functionapp to master
# Complete pull request
# Review & approval from reviewers

#Releasing
git checkout master
git pull
git checkout -b release/1.4/master
git push --set-upstream origin release/1.4/master

git tag -a 1.4 <SHA1 of last commit>
git push 1.4 origin

#bug/hotfix
git checkout release/1.4/master
git pull
git checkout -b bug/1.4/443222-function-exist-check
```
