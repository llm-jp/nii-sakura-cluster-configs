#!/bin/bash

# Log file
LOGFILE="/var/log/slurm/prolog-$(hostmane).log"

# Log the start time
echo "Prolog script ended at $(date)" >> $LOGFILE

# Example setup tasks
# Load necessary modules or perform any other setup
# module load some_module

# Check if the module loaded successfully
# if [ $? -ne 0 ]; then
#     echo "Failed to load module at $(date)" >> $LOGFILE
#     exit 1
# fi

# DCGM job statistics
group=$(sudo -u $SLURM_JOB_USER dcgmi group -c allgpus --default)
if [ $? -eq 0 ]; then
  groupid=$(echo $group | awk '{print $10}')
  sudo -u $SLURM_JOB_USER dcgmi stats -g $groupid -e
  sudo -u $SLURM_JOB_USER dcgmi stats -g $groupid -s $SLURM_JOBID
fi


# Log successful setup
echo "Prolog script completed successfully at $(date)" >> $LOGFILE

# Exit successfully
exit 0
