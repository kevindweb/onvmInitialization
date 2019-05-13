# onvmInitialization
Helpers to finish the ONVM initialization in 2 commands 

Use `scp -r` to push all the files in the init folder to your cloudlab node

Once there, run `chmod +x init.sh`

Finally run the program with ./init.sh

## Advanced remote work
Alternative to the above configuration, no need to do both
These processes are not necessary but helpful for pushing your vim configs, bash aliases and other to cloudlab nodes

- Move the `cloudlab` and `init` folders to your home directory (`~`)
- Move the `cloud` function from `bash_profile.sh` into your personal bash profile
  - You can alternatively move that file to home, and `source bash_profile.sh`
  - Make sure it is in the home directory

## Using the cloud command
The script stores your node number (c220g2 node specific, change the script if node is different)

Before you login to your node for the first time, run this command
`cloud n <your node number (010807 for example)>`

The `n` argument tells the script to initialize all your files and `scp` them to the node (it will not do this everytime you login)

This will automatically log you into the node, and source your bash configurations from the `cloudlab` folder
They are loaded with default (my) personal commands I use, but can be changed to fit your needs

The next time you login, if you haven't overwritten the `nodeNum.txt` file, run `cloud`
This will take your most recent cloudlab node number and ssh into that
