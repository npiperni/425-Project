#!/encs/bin/bash

#SBATCH --job-name=gaussian_splatting_train   ## Job name
#SBATCH --mail-type=ALL                      ## Receive all email notifications
#SBATCH --chdir=./                           ## Use current directory as working directory
#SBATCH --partition=ps                       ## Use the ps partition (for A100 or V100 GPUs)
#SBATCH --gpus=1                             ## Request 1 GPU
#SBATCH --gres=gpu:nvidia_a100_7g.80gb:1     ## Request an A100 GPU with 80 GB of VRAM (if available)
#SBATCH --mem=24G                            ## Assign memory to CPU (this is for system memory)
#SBATCH --export=ALL                         ## Export all environment variables


echo "$0 : Starting Gaussian Splatting job on Speed..."
date

SINGULARITY=/encs/pkg/singularity-3.10.4/root/bin/singularity

$SINGULARITY run --nv \
--bind /speed-scratch/n_piper/425-Project/gaussian-splatting:/mnt/code \
--bind /speed-scratch/n_piper/dataset:/mnt/data \
/speed-scratch/n_piper/425-Project/3d_gaussian_splatting.sif \
python /mnt/code/train.py -s /mnt/data/db/playroom/


echo "$0 : Done"
date
