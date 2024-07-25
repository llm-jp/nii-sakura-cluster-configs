#!/bin/bash

module load cuda/12.5 nccl/2.22.3 hpcx/2.17.1-gcc-cuda12/hpcx

# See manual page 11
# This is the settings for GPU A cluster. The settings for GPU B cluster may be different.

# MPI settings
export OMPI_MCA_btl_tcp_if_include="10.1.0.0/16,10.2.0.0/16,10.3.0.0/16,10.4.0.0/16"

# UCX settings
export UCX_NET_DEVICES="mlx5_0:1,mlx5_1:1,mlx5_4:1,mlx5_5:1"
export UCX_MAX_EAGER_RAILS=4
export UCX_MAX_RNDV_RAILS=4
export UCX_IB_GPU_DIRECT_RDMA=1

# NCCL settings
export NCCL_IB_ADDR_RANGE="10.1.0.0/16,10.2.0.0/16,10.3.0.0/16,10.4.0.0/16"
# export NCCL_IB_GID_INDEX=3  # Set gid = 3 to use RoCE v2 (not necessary)
export NCCL_IB_HCA="mlx5_0:1,mlx5_1:1,mlx5_4:1,mlx5_5:1"
export NCCL_IB_PCI_RELAXED_ORDERING=1

# execute the command
"$@"
