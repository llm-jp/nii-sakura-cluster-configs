# Prometheus Exporter Setting Scripts

This directory contains Ansible playbooks and scripts to set up Prometheus and Grafana for monitoring the GPU cluster.

## Installation

```bash
# make ssh.cfg file
cp ssh.example.cfg ssh.cfg
# After copying the file, fill out ssh configuration in ssh.cfg

# install ansible
sudo apt install ansible # for Ubuntu
brew install ansible # for mac OS

# install ansible galaxy
ansible-galaxy collection install prometheus.prometheus
ansible-galaxy role install gantsign.golang

# install necessary packages for ansible
brew install gnu-tar # for mac OS
```

## Usage

```sh
# load environment variables
source .env

# play all playbooks
ansible-playbook site.yml
# OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ansible-playbook site.yml # for mac OS

# play each playbook
ansible-playbook playbooks/install_node_exporter.yml

# dry run with verbose
ansible-playbook site.yml --check --diff -vvv
```

- `OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` is necessary if you are a mac user
