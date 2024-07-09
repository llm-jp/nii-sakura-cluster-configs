#!/bin/bash
#SBATCH --job-name=dsreport
#SBATCH --output=test_job.out
#SBATCH --error=test_job.err
#SBATCH --nodes=32
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:10:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:8
srun hostname && srun echo $CUDA_VISIBLE_DEVICES
