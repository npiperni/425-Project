#!/encs/bin/bash

#SBATCH --job-name=gaussian_splatting_train   ## Job name
#SBATCH --mail-type=ALL                      ## Receive all email notifications
#SBATCH --chdir=./                           ## Use current directory as working directory
#SBATCH --partition=ps                       ## Use the ps partition (for A100 or V100 GPUs)
#SBATCH --gpus=1                             ## Request 1 GPU
#SBATCH --mem=24G                            ## Assign memory to CPU (this is for system memory)
#SBATCH --export=ALL                         ## Export all environment variables

# Check if arguments are provided
if [ -z "$1" ]; then
    echo "Usage: sbatch convert.sh <data folder name>"
    exit 1
fi

FOLDER_NAME=$1    # First argument: Video file name

# Set the video file path
FOLDER_PATH="/speed-scratch/n_piper/425-Project/data/$FOLDER_NAME"

# Check if the video file exists
if [ ! -d "$FOLDER_PATH" ]; then
    echo "ERROR: The folder $FOLDER_PATH does not exist in /speed-scratch/n_piper/425-Project/data/"
    exit 1
fi

echo "$0 : Starting conversion for $FOLDER_NAME..."
date

SINGULARITY=/encs/pkg/singularity-3.10.4/root/bin/singularity

$SINGULARITY run --nv \
--bind /speed-scratch/n_piper/425-Project/data:/mnt/data \
--bind /speed-scratch/n_piper/conversions:/mnt/convert_output \
/speed-scratch/n_piper/3d_gaussian_splatting.sif \
bash -c "\
    echo 'Doing some setup...' && \
    cd /workspace/gaussian-splatting/ && \
    conda init bash && \
    source ~/.bashrc && \
    conda activate gaussian_splatting && \

    python convert.py -s /mnt/data/$FOLDER_NAME"



echo "$0 : Conversion done!"
date