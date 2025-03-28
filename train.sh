#!/encs/bin/bash

#SBATCH --job-name=gaussian_splatting_train   ## Job name
#SBATCH --mail-type=ALL                      ## Receive all email notifications
#SBATCH --chdir=./                           ## Use current directory as working directory
#SBATCH --partition=ps                       ## Use the pg partition (for A100 or V100 GPUs)
#SBATCH --gpus=1                             ## Request 1 GPU
#SBATCH --mem=24G                            ## Assign memory to CPU (this is for system memory)
#SBATCH --export=ALL                         ## Export all environment variables
#SBATCH --time=0-6:00:00                     ## job time limit


# Check if the required arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: sbatch train.sh <dataset_folder> <output_folder>"
    exit 1
fi

DATASET_FOLDER=$1  # First argument: dataset folder
OUTPUT_FOLDER=$2   # Second argument: output folder name

# Define base output directory
BASE_OUTPUT_DIR="/speed-scratch/$USER/output"

# Full path for the output directory
FULL_OUTPUT_DIR="$BASE_OUTPUT_DIR/$OUTPUT_FOLDER"

# Create the output folder if it doesn't exist
if [ ! -d "$FULL_OUTPUT_DIR" ]; then
    mkdir -p "$FULL_OUTPUT_DIR"
    echo "Created output directory: $FULL_OUTPUT_DIR"
fi

echo "$0 : Starting Gaussian Splatting job on Speed with dataset $DATASET_FOLDER..."
date

SINGULARITY=/encs/pkg/singularity-3.10.4/root/bin/singularity

$SINGULARITY run --nv \
--bind "$DATASET_FOLDER:/mnt/data" \
--bind "$FULL_OUTPUT_DIR:/workspace/gaussian-splatting/output" \
/speed-scratch/$USER/3d_gaussian_splatting.sif \
bash -c "echo 'Doing some setup...' && cd /workspace/gaussian-splatting/ && conda init bash && source ~/.bashrc && conda activate gaussian_splatting && python train.py -s /mnt/data/"



echo "$0 : Done"
date
