#!/encs/bin/bash

#SBATCH --job-name=gaussian_splatting_train   ## Job name
#SBATCH --mail-type=ALL                      ## Receive all email notifications
#SBATCH --chdir=./                           ## Use current directory as working directory
#SBATCH --partition=ps                       ## Use the ps partition (for A100 or V100 GPUs)
#SBATCH --gpus=1                             ## Request 1 GPU
#SBATCH --mem=24G                            ## Assign memory to CPU (this is for system memory)
#SBATCH --export=ALL                         ## Export all environment variables


# Check if an argument was provided
if [ -z "$1" ]; then
    echo "Usage: sbatch train.sh <dataset_folder>"
    exit 1
fi

DATASET_FOLDER=$1  # Get the first argument passed to sbatch

echo "$0 : Starting Gaussian Splatting job on Speed with dataset $DATASET_FOLDER..."
date

SINGULARITY=/encs/pkg/singularity-3.10.4/root/bin/singularity

$SINGULARITY run --nv \
--bind $DATASET_FOLDER:/mnt/data \
--bind /speed-scratch/n_piper/output:/workspace/gaussian-splatting/output \
/speed-scratch/n_piper/3d_gaussian_splatting.sif \
bash -c "echo 'Doing some setup...' && cd /workspace/gaussian-splatting/ && conda init bash && source ~/.bashrc && conda activate gaussian_splatting && python train.py -s /mnt/data/"




echo "$0 : Done"
date
