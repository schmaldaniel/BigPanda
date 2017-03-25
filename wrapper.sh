#!/bin/bash

function usage {
    echo "Sript usage:"
    echo "------------"
    echo ""
    echo "./wrapper.sh -a/--app {app name to be installed - gify-panda/counter-panda}"
    echo ""
    echo "Examples:"
    echo "--------"
    echo ""
    echo "install both apps:"
    echo "./wapper.sh"
    echo " install single app"
    echo "./wapper.sh -a gify-panda"
    exit

}

function run_playbook {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd $DIR
    if [ ! -z $APP ]; then
        ansible-playbook -i dev/hosts base.yml --tags $APP
    else
        ansible-playbook -i dev/hosts base.yml
    fi
    echo $DIR
}

while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -h|--help)
    usage
    shift # past argument
    ;;
    -a|--app)
    APP="$2"
    shift # past argument
    ;;
    *)
    ;;
esac
shift # past argument or value
done

run_playbook