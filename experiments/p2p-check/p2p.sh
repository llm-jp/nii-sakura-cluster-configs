#!/bin/bash

set -eu -o pipefail

. scripts/environment.sh
. scripts/mpi_variables.sh
. venv/bin/activate

# see https://docs.nvidia.com/deeplearning/nccl/archives/nccl_2205/user-guide/docs/env.html
# export NCCL_P2P_LEVEL=LOC
# export NCCL_P2P_LEVEL=0
# export NCCL_P2P_DISABLE=1
# export NCCL_NET_GDR_READ=1
# export NCCL_IB_CUDA_SUPPORT=0
# export NCCL_NET_GDR_LEVEL=LOC
# export NCCL_NET_GDR_LEVEL=0
# export NCCL_NET=Socket

#export NCCL_DEBUG=INFO
#export NCCL_DEBUG=TRACE

python p2p.py $1 $2

