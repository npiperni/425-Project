#!/encs/bin/bash

#SBATCH --job-name=gaussian_splatting_train   ## Job name
#SBATCH --mail-type=ALL                      ## Receive all email notifications
#SBATCH --chdir=./                           ## Use current directory as working directory
#SBATCH --partition=ps                       ## Use the ps partition (for A100 or V100 GPUs)
#SBATCH --gpus=1                             ## Request 1 GPU
#SBATCH --mem=24G                            ## Assign memory to CPU (this is for system memory)
#SBATCH --export=ALL                         ## Export all environment variables

# Check if arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: sbatch convert.sh <video_filename> <frame_rate>"
    exit 1
fi

VIDEO_FILENAME=$1    # First argument: Video file name
FRAME_RATE=$2        # Second argument: Frame extraction rate

# Extract video name without extension
VIDEO_NAME=$(basename "$VIDEO_FILENAME" | sed 's/\.[^.]*$//')

echo "$0 : Starting conversion for video $VIDEO_FILENAME at $FRAME_RATE fps..."
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

    cd /mnt/convert_output && \
    mkdir -p \"$VIDEO_NAME/input\" && \
    cd \"$VIDEO_NAME/input\" && \
    ffmpeg -i \"/mnt/data/$VIDEO_FILENAME\" -qscale:v 1 -qmin 1 -vf fps=$FRAME_RATE %04d.jpg && \

    python convert.py -s /mnt/convert_output/$VIDEO_NAME"



echo "$0 : Conversion done!"
date