#!/bin/bash

set -e

NCCL_TEST_PATH="${NCCL_TEST_PATH:-./build}"

# all_gather_perf  alltoall_perf   gather_perf     reduce_perf          scatter_perf   timer.o
# all_reduce_perf  broadcast_perf  hypercube_perf  reduce_scatter_perf  sendrecv_perf  verifiable

# All to All
echo "======= All to All ======="
$NCCL_TEST_PATH/alltoall_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# All Reduce
echo "======= All Reduce ======="
$NCCL_TEST_PATH/all_reduce_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# All Gather
echo "======= All Gather ======="
$NCCL_TEST_PATH/all_gather_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Broadcast
echo "Broadcast"
$NCCL_TEST_PATH/broadcast_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Reduce
echo "Reduce"
$NCCL_TEST_PATH/reduce_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Scatter
echo "Scatter"
$NCCL_TEST_PATH/scatter_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Reduce Scatter
echo "Reduce Scatter"
$NCCL_TEST_PATH/reduce_scatter_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Send Recv
echo "Send Recv"
$NCCL_TEST_PATH/sendrecv_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100

# Hypercube
echo "Hypercube"
$NCCL_TEST_PATH/hypercube_perf -b 8 -e 256M -f 2 -g 8 -c 1 -n 100
