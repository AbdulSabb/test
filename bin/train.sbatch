#!/bin/bash --login
#SBATCH -N 1
#SBATCH --partition=batch
#SBATCH -J MyJob
#SBATCH -o MyJob.%J.out
#SBATCH -e MyJob.%J.err
#SBATCH --mail-user=abdelrahman.sabbagh@kaust.edu.sa
#SBATCH --mail-type=ALL
#SBATCH --time=03:30:00
#SBATCH --mem=200M
#SBATCH --gres=gpu:1
#SBATCH --constraint=gpu

# entire script fails if single command fails
set -e

# activate the conda environment
module purge
conda activate "$1"

# use srun to launch NVDashboard server in order to reserve a port
srun --resv-ports=1 ./bin/launch-nvdashboard-server.srun &
NVDASHBOARD_PID=$!

# launch the training script
python "${@:2}"

# shutdown the NVDashboard server
kill $NVDASHBOARD_PID
