# get all the required modules
update_libraries() {
    # turn off error checking
    set +e
	sudo apt-get update

	sudo apt-get install -y curl
	sudo apt-get install -y vim
	sudo apt-get install libnuma-dev
    
    sudo apt-get install -y python3
    python3 -V
    check_exit_code "Python not installed"

    sudo apt-get install -y python3-pip
    pip3 -V
    check_exit_code "Pip not installed"

    sudo -H pip3 install pexpect
    check_exit_code "Pexpect not installed or failed to install"

    echo "Finished install process"
} 

get_user_input() {
    echo "$1"
    read -r -p "Continue? (Y/N): " confirm
    if ! [[ $confirm =~ ^[Yy]$ ]]
    then
        echo "Exiting initializer"
        exit 1
    fi
}

# checks if a command has failed (exited with code != 0)
check_exit_code() {
    prev=$?
    if [[ -n "$2" && $prev -eq "$2" ]] || [[ -z "$2" && $prev -ne 0 ]]
    then
        echo "ERROR: $1"
        exit 1
    fi
}

 # sets up dpdk, sets env variables, and runs the install script
install_env() {
    git submodule sync 
    git submodule update --init

    echo export ONVM_HOME=$(pwd) >> ~/.bashrc
    export ONVM_HOME=$(pwd)

    cd dpdk

    echo export RTE_SDK=$(pwd) >> ~/.bashrc
    export RTE_SDK=$(pwd)

    echo export RTE_TARGET=x86_64-native-linuxapp-gcc  >> ~/.bashrc
    export RTE_TARGET=x86_64-native-linuxapp-gcc

    echo export ONVM_NUM_HUGEPAGES=1024 >> ~/.bashrc
    export ONVM_NUM_HUGEPAGES=1024

    echo $RTE_SDK

    sudo sh -c "echo 0 > /proc/sys/kernel/randomize_va_space"

    cd ../
    pwd
    . ./scripts/install.sh
}

# makes all onvm code
build_onvm() {
    cd onvm
    make clean && make
    cd ../

    cd examples
    make clean && make
    cd ../
}
