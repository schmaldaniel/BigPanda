#!/bin/bash

# Usually I prefer to write those wraper in python 
# since I am not familiar with ansible and especially 
# with ansible API I used bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
new_deployment=0

function usage {
    echo "Sript usage:"
    echo "------------"
    echo ""
    echo "./wrapper.sh -n/--new-deployment -a/--app {app name to be installed - gify-panda/counter-panda}"
    echo ""
    echo "Examples:"
    echo "---------"
    echo ""
    echo "install both apps on existing base server:"
    echo "./wapper.sh"
    echo ""
    echo "install single app on existing base server"
    echo "./wapper.sh -a gify-panda"
    echo ""
    echo "deploy base server from scratch without -a parameter will install both"
    echo "./wapper.sh -n -a gify-panda"
    echo ""
    exit

}

function run_playbook {
    # Run ansible playbook on existing base server
    cd $DIR
    if [ ! -z $APP ]; then
        ansible-playbook -i dev/hosts base.yml --tags $APP
    else
        ansible-playbook -i dev/hosts base.yml
    fi
}

function destroy_base {
    # Removing existing base server
    vagrant destroy -f base
}

function create_vagrantfile {
    # Creating vagrantfile based on the apps that should be run in the base server
    cd $DIR
    cp -fp Vagrantfile.template Vagrantfile
    if [ -v $APP ]; then
        APP='["gify-panda", "counter-panda"]'
        sed -i s/{{TAGS}}/"$APP"/g Vagrantfile
    else
        sed -i s/{{TAGS}}/"'$APP'"/g Vagrantfile
    fi
}

function create_base {
    # Creating the base server
    vagrant up base
}



while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|--help)
    usage
    ;;
    -a|--app)
    APP="$2"
    shift 
    ;;
    -n|--new-deployment)
    new_deployment=1
    ;;
    *)
    ;;
esac
shift 
done

if [ "$new_deployment" -eq 1 ]; then
    destroy_base
    create_vagrantfile
    create_base
else
    run_playbook
fi