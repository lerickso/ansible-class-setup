#!/bin/bash

HOSTS=("server101" "server102" "drserver201")

echo "Please provide the root/support password when prompted"
sleep 2
sudo yum check-update
sudo yum -y upgrade
sudo yum -y install ansible git
ansible_version=$(ansible --version | awk '/ansible [0-9\.]+/' )
echo "Installed Ansible version: ${ansible_version}"
git clone https://github.com/lerickso/docker-repo.git ~/

for S in ${HOSTS[@]}
do
	SEARCH=/${S}/
	if [ $(awk ${SEARCH} ~/.ssh/known_hosts | wc -c) -lt 1 ]
	then
		ssh ${S} -l root 'echo "Connected to $(hostname)"'
	fi
done

ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 2048 -a 100 -q -N ""
echo "Please provide the root/support password when prompted"
sleep 2
ansible-playbook -i ~/docker-repo/inventory ~/docker-repo/setup.yml -k
