#!/bin/bash

# Log file
# LOGFILE="/var/log/slurm/epilog-$(hostmane).log"
LOGFILE="/data/logs/slurm/log-$(hostname).log"

# Log the start time

# Example setup tasks
# Load necessary modules or perform any other setup
# module load some_module

# Check if the module loaded successfully
# if [ $? -ne 0 ]; then
#     echo "Failed to load module at $(date)" >> $LOGFILE
#     exit 1
# fi

# DCGM job statistics
# OUTPUTDIR=$(scontrol show job $SLURM_JOBID | grep WorkDir | cut -d = -f 2)
# sudo -u $SLURM_JOB_USER dcgmi stats -x $SLURM_JOBID
# sudo -u $SLURM_JOB_USER dcgmi stats -v -j $SLURM_JOBID | \
#     sudo -u $SLURM_JOB_USER tee $OUTPUTDIR/dcgm-gpu-stats-$HOSTNAME-$SLURM_JOBID.out



# Log successful setup
echo "Task $SLURM_JOBID finished at $(date)" >> $LOGFILE

# Exit successfully
exit 0
