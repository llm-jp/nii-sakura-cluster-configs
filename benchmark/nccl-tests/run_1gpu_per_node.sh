#!/bin/bash

#SBATCH --job-name=nccl-tests-1gpu-per-node
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --time=00:10:00
#SBATCH --nodes=1            # Number of nodes (changeable from 1 to 33)
#SBATCH --ntasks-per-node=1  # 1 task per node
#SBATCH --gres=gpu:1         # 1 GPU per node
#SBATCH --partition=gpu


set -e

echo "NCCL TESTS: 1 GPU per node with $SLURM_NNODES nodes"

module load cuda/12.5 nccl/2.22.3 hpcx/2.17.1-gcc-cuda12/hpcx

NCCL_TEST_PATH="${NCCL_TEST_PATH:-./build}"

buf_size=512M

# All to All
echo "======= All to All ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/alltoall_perf -b $buf_size -e $buf_size -f 2 --ngpus 1 -c 1 -n 100 -w 20

# All Reduce
echo "======= All Reduce ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/all_reduce_perf -b $buf_size -e $buf_size -f 2 --ngpus 1 -c 1 -n 100 -w 20

# All Gather
echo "======= All Gather ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/all_gather_perf -b $buf_size -e $buf_size -f 2 --ngpus 1 -c 1 -n 100 -w 20
