#!/bin/bash

#SBATCH --job-name=nccl-roce-test
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --time=00:10:00
#SBATCH --nodes=16           # Number of nodes (changeable from 1 to 33)
#SBATCH --gres=gpu:8         # 8 GPUs per node
#SBATCH --partition=gpu


set -e -o pipefail

module load cuda/12.5 nccl/2.22.3 hpcx/2.17.1-gcc-cuda12/hpcx

NCCL_TEST_PATH="${NCCL_TEST_PATH:-./build}"
buf_size=256M
n_gpus="$SLURM_GPUS_ON_NODE"

echo "NCCL TESTS: RoCE v1 and v2 test with $SLURM_NNODES nodes"
echo "buf_size: $buf_size"
echo "n_gpus per node: $n_gpus"

# All to All on RoCE v1
echo "======= All to All on RoCE v1 ======="
mpirun -np 1 ./mpi_wrapper.sh printenv | grep NCCL # Check NCCL settings
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/alltoall_perf -b $buf_size -e $buf_size -g $n_gpus -c 1 -n 100 -w 20

# All to All on RoCE v2
echo "======= All to All on RoCE v2 ======="
mpirun -np 1 -x NCCL_IB_GID_INDEX=3 ./mpi_wrapper.sh printenv | grep NCCL # Check NCCL settings
mpirun -x NCCL_IB_GID_INDEX=3 \
    ./mpi_wrapper.sh $NCCL_TEST_PATH/alltoall_perf -b $buf_size -e $buf_size -g $n_gpus -c 1 -n 100 -w 20
