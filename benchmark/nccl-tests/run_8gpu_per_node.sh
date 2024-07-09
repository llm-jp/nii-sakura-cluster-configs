#!/bin/bash

#SBATCH --job-name=nccl-tests-multinodes
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --time=00:10:00
#SBATCH --nodes=1            # Number of nodes (changeable from 1 to 33)
#SBATCH --gres=gpu:8         # 8 GPUs per node
#SBATCH --partition=gpu


set -e

NCCL_TEST_PATH="${NCCL_TEST_PATH:-./build}"

# All to All
echo "======= All to All ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/alltoall_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# All Reduce
echo "======= All Reduce ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/all_reduce_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# All Gather
echo "======= All Gather ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/all_gather_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Broadcast
echo "======= Broadcast ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/broadcast_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Reduce
echo "======= Reduce ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/reduce_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Scatter
echo "======= Scatter ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/scatter_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Reduce Scatter
echo "======= Reduce Scatter ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/reduce_scatter_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Send Recv
echo "======= Send Recv ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/sendrecv_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Hypercube
echo "======= Hypercube ======="
mpirun ./mpi_wrapper.sh $NCCL_TEST_PATH/hypercube_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100
