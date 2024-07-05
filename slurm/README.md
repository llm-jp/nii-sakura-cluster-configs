# Slurm Setup

This directory contains partial scripts for setting up slurm in the sakura-cluster.
All configuration files are contained in the `sakura_conf` directory. 

## How-to

### Preparing configuration files
Before running the script, we need to prepare the following configuration files
- `slurm.conf`: the slurm configuration file. All nodes **MUST** share the same configuration file.
- `gres.conf`: the generic resource definition file. We control the GPU usage with this file.
- `prolog.sh`/`epilog.sh`: the pre-execution/post-execution script. 
- `cgroup.conf`: the cgroup configuration file. Current configuration allows the partition of cpu and gpus.
- `hosts`: the ethernet definition file. This should be distributed to the `/etc/hosts`. **It's highly recommended for all nodes to share the same hosts file**. Otherwise, all nodes must know the ip address of any other node for slurm to launch sbatch jobs.
- `nhc.conf`: the health check configuration file.

### Setting up
To setup the slurm, we need to install the followings
- nhc script
- slurm & munge service

To this end, we run the following ansible playbook.
```
ansible-playbook -i inventory nhc-install.yml -K
ansible-playbook -i inventory slurm-install.yml -K
```


