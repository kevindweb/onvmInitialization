if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

cloud=$HOME/cloudlab
if [ -d "$cloud" ]; then 
    for file in $cloud/.*
    do  
        if [ $file != $cloud/. ] && [ $file != $cloud/.. ]
        then
            mv $file $HOME/
        fi  
    done
	rm -rf $cloud
	chmod +x $HOME/init/init.sh
	. "$HOME/.kbashrc"
fi

if [ -f "$HOME/.kbashrc" ]; then
   . "$HOME/.kbashrc"
fi
