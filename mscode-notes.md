# mscode-notes
An easy way to note things on github with mscode.


To start with, lets create a repository.
```
  mkdir ~/Notes
  cd ~/Notes
  git init
  echo "Notepad" > notepad.md
  git add .
  git commit -m "creating my notepad repo"
```

Push it to github:
```
  git remote add origin git@github.com:YOUR_GITHUB_USERNAME_HERE/REPO_NAME_HERE.git
  git push --set-upstream origin master
```

Create a sync.sh in your root directory (eg. ~/Notes/) adding the below code:
```
  #!/bin/bash
  cd $(dirname `which $0`)
  git pull
  git add .
  git commit -m "Notes - $(date)"
  git push
  echo "Done"
```

In order to run it we have to make it executable with chmod +x ~/Notes/git-sync.sh

Install the extension called "Run on Save" . install it from [here](https://marketplace.visualstudio.com/items?itemName=pucelle.run-on-save)

Open settings.json and add the code below:
```
  {
   "runOnSave.commands": [
      {
         "match": "/<YOUR_HOME_DIRECTORY>/Notes/.*",
         "notMatch": "",
         "command": "/<YOUR_HOME_DIRECTORY>/Notes/git-sync.sh",
         "runIn": "backend",
         "runningStatusMessage": "Syncing Notes...",
         "finishStatusMessage": "Notes Sync Successful"
      }
   ],
   "runOnSave.statusMessageTimeout": 5000
}
```
Now when you create a note in the directory, and saveit, it will automatically sync with Github.
