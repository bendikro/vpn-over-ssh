#!/bin/bash

source conf.env

# No need to edit
export VIRTUALENVWRAPPER=${VIRTUALENVWRAPPER_SCRIPT}
PIP_CACHE=packages

VENV_NAME=vpn-over-ssh

source $VIRTUALENVWRAPPER

workon ${VENV_NAME} || mkvirtualenv --no-download --extra-search-dir ${PIP_CACHE} ${VENV_NAME} -i sshuttle

sshuttle -r ${SSH_SERVER} 0/0 --dns &

cleanup()
{
	printf "Killing jobs: %b\n" `jobs -p`
	kill `jobs -p`
}

trap "cleanup" INT QUIT TERM EXIT

sleep 2

sudo openvpn --config ${OPENPVN_CONFIG} ${OPENPVN_ROUTE}

echo "Waiting and jobs.."

for job in `jobs -p`
do
	echo $job
	wait $job || let "FAIL+=1"
done
