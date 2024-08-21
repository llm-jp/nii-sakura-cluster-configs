#!/bin/bash

# Log file
LOGFILE="/data/logs/slurm/log-$(hostname).log"

# Log the start time
echo "Job $SLURM_JOBID from $SLURM_JOB_USER starting at $(date)" >> $LOGFILE

# Example setup tasks
# Load necessary modules or perform any other setup
# module load some_module

# Check if the module loaded successfully
# if [ $? -ne 0 ]; then
#     echo "Failed to load module at $(date)" >> $LOGFILE
#     exit 1
# fi

# DCGM job statistics
# group=$(sudo -u $SLURM_JOB_USER dcgmi group -c allgpus --default)
# if [ $? -eq 0 ]; then
#   groupid=$(echo $group | awk '{print $10}')
#   sudo -u $SLURM_JOB_USER dcgmi stats -g $groupid -e
#   sudo -u $SLURM_JOB_USER dcgmi stats -g $groupid -s $SLURM_JOBID
# fi



# Exit successfully
exit 0
