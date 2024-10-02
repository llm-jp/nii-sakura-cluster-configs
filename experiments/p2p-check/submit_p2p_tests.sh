#!/bin/bash

# Function to print messages with a timestamp
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $1"
}

for SENDER in {0..15}; do
  for RECEIVER in {0..15}; do
    if [ $SENDER -ne $RECEIVER ]; then
      SCRIPT_NAME="p2p_${SENDER}_${RECEIVER}.bat.sh"
      cp p2p.bat.sh $SCRIPT_NAME

      # Modify the job name, output, and error file names in the copied script
      sed -i "s/^#SBATCH --job-name=.*/#SBATCH --job-name=p2p-test-${SENDER}-${RECEIVER}/" $SCRIPT_NAME
      sed -i "s/^#SBATCH --output=.*/#SBATCH --output=p2p-test-${SENDER}-${RECEIVER}-%j.out/" $SCRIPT_NAME
      sed -i "s/^#SBATCH --error=.*/#SBATCH --error=p2p-test-${SENDER}-${RECEIVER}-%j.err/" $SCRIPT_NAME

      # Submit the job and extract the job ID
      JOB_ID=$(sbatch $SCRIPT_NAME $SENDER $RECEIVER | awk '{print $4}')
      log_info "Submitted job $JOB_ID for sender $SENDER and receiver $RECEIVER"

      # Wait for the job to finish before proceeding
      while squeue -j $JOB_ID 2>/dev/null | grep -q "$JOB_ID"; do
        sleep 10
      done
      log_info "Job $JOB_ID completed for sender $SENDER and receiver $RECEIVER."
    fi
  done
done
