#!/encs/bin/bash

#SBATCH --job-name=gaussian_splatting_train   ## Job name
#SBATCH --mail-type=ALL                 ## Receive all email notifications
#SBATCH --chdir=./                      ## Use current directory as working directory
#SBATCH --partition=pg                   ## Use GPU partition
#SBATCH --gpus=1                         ## Request 1 GPU
#SBATCH --mem=24G                        ## Assign memory
#SBATCH --export=ALL                     ## Export all environment variables

echo "$0 : Starting Gaussian Splatting job on Speed..."
date

SINGULARITY=/encs/pkg/singularity-3.10.4/root/bin/singularity

$SINGULARITY run --nv 3d_gaussian_splatting.sif

cd gaussian-splatting/

python train.py -s /speed-scratch/$USER/dataset/db/playroom/

echo "$0 : Done"
date
