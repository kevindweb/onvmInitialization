#!/bin/bash

cloud() {
    nodeFile=~/nodeNum.txt
    init=~/init
    cloudlab=~/cloudlab
    config=$init/config

    if [ ! -d $init ]
    then
        echo "Please move the init folder to home directory"
        return 1
    fi

    if [ ! -f "$config" ]
    then
        echo "Please supply a config file in the init folder"
        return 1
    fi

    # source our config file
    . $config

    if [ -z "$CLOUD_USER" ]
    then
        echo "ERROR: cloudlab username not set"
        return 1
    fi

    if [ $# -eq 0 ] 
    then
        if [ ! -f "$nodeFile" ]
            then    
                echo "File not found, add node number as argument!"
                return 1
            else
                node=$(<$nodeFile)
        fi  
    else
        if [ $1 = "n" ]
        then
            echo "$2" > "$nodeFile"
            node=$2
            server="$CLOUD_USER@c220g2-"$node".wisc.cloudlab.us"
            scp $cloudlab/.profile $server:~/.profile
            scp -r $cloudlab $server:~
            scp -r $init $server:~
            echo "Remember to run './init/init.sh' upon login"
        else
            node=$1
        fi  
    fi  
    ssh $CLOUD_USER@c220g2-"$node".wisc.cloudlab.us;
}
