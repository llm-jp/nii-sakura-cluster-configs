#!/bin/bash

#SBATCH --job-name=storage-test-fio
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --time=00:10:00
#SBATCH --nodes=1            # Number of nodes (changeable from 1 to 33)
#SBATCH --partition=gpu

set -e

bs=${bs:-32k}
size=${size:-1G}
numjobs=${numjobs:-16}
direct=${direct:-0} # 1: O_DIRECT, 0: O_SYNC

FIO_PATH="${FIO_PATH:-./bin}"
IO_FILE="/data/io_test/tmp_$SLURM_JOB_ID.fio" # Slow

echo "======= Output file: $IO_FILE ======="

# Sequential write
echo "======= Sequential write ======="
$FIO_PATH/fio -filename="$IO_FILE" -direct=${direct} -rw=write -bs=${bs} -size=${size} -numjobs=${numjobs} -runtime=5 -group_reporting -name=sequential_write

# Sequential read
echo "======= Sequential read ======="
$FIO_PATH/fio -filename="$IO_FILE" -direct=${direct} -rw=read -bs=${bs} -size=${size} -numjobs=${numjobs} -runtime=5 -group_reporting -name=sequential_read

# Random write
echo "======= Random write ======="
$FIO_PATH/fio -filename="$IO_FILE" -direct=${direct} -rw=randwrite -bs=${bs} -size=${size} -numjobs=${numjobs} -runtime=5 -group_reporting -name=random_write

# Random read
echo "======= Random read ======="
$FIO_PATH/fio -filename="$IO_FILE" -direct=${direct} -rw=randread -bs=${bs} -size=${size} -numjobs=${numjobs} -runtime=5 -group_reporting -name=random_read

rm -f $IO_FILE
