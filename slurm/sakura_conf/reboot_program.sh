#!/bin/bash
# Simple Reboot Script for Slurm Nodes

# Use shutdown command to reboot the node

echo "Rebooting node $(hostname) at $(date)" >> /var/log/slurm/reboot.log

/sbin/shutdown -r now "Scheduled reboot by Slurm"