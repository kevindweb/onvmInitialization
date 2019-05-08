#!/usr/bin/python3

import os
import pexpect
import sys
import socket


def osread(cmd):
    # get result of system command
    # ignore trailing new line
    return os.popen(cmd).read().rstrip()


if len(sys.argv) != 2:
    print("ERROR! Incorrect number of arguments")
    sys.exit(1)

user_dir = osread('eval echo ~$USER')
email = sys.argv[1]
cmd = "ssh-keygen -t rsa -b 4096 -C '%s'" % (email)
rsa_file = "%s/.ssh/id_rsa" % (user_dir)


if os.path.isfile(rsa_file):
    delete_cmd = "sudo rm -f %s" % (rsa_file)
    child = pexpect.run(delete_cmd)

child = pexpect.spawn(cmd)
child.expect("Enter.*")
child.sendline(rsa_file + "\n")
child.expect("Enter.*")
child.sendline("\n")
child.expect("Enter.*")
child.sendline("\n")

child.interact()

os.system('eval "$(ssh-agent)" ssh-add %s' % (rsa_file))
