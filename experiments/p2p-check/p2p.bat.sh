#!/bin/bash
#SBATCH --job-name=test-p2p
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --gres=gpu:8
#SBATCH --output=%x-%j.txt
#SBATCH --error=%x-%j.txt
#SBATCH --partition=gpu-debug

#
# usage: sbatch ./p2p.bat.sh SENDER RECEIVER
# e.g., sbatch ./p2p.bat.sh 0 9
#
set -eu -o pipefail

source scripts/environment.sh
source venv/bin/activate

export MASTER_ADDR="$(scontrol show hostname $SLURM_JOB_NODELIST | head -n1)"
export MASTER_PORT=12801

echo "MASTER_ADDR=${MASTER_ADDR}"

NUM_NODES=$SLURM_JOB_NUM_NODES
NUM_GPUS_PER_NODE=$(echo $SLURM_TASKS_PER_NODE | cut -d '(' -f 1)
NUM_GPUS=$((${NUM_NODES} * ${NUM_GPUS_PER_NODE}))

echo NUM_NODES=$NUM_NODES
echo NUM_GPUS_PER_NODE=$NUM_GPUS_PER_NODE
echo NUM_GPUS=$NUM_GPUS

mpirun \
    -np $NUM_GPUS \
    --npernode $NUM_GPUS_PER_NODE \
    -bind-to none \
    -map-by slot \
    -x MASTER_ADDR=$MASTER_ADDR \
    -x MASTER_PORT=$MASTER_PORT \
    -x NUM_NODES=$NUM_NODES \
    -x NUM_GPUS_PER_NODE=$NUM_GPUS_PER_NODE \
    -- ./p2p.sh $1 $2

