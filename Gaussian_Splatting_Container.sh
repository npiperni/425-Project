#!/encs/bin/bash

#SBATCH --job-name=gaussian_splatting   ## Job name
#SBATCH --mail-type=ALL                 ## Receive all email notifications
#SBATCH --chdir=./                      ## Use current directory as working directory
#SBATCH --partition=pg                   ## Use GPU partition
#SBATCH --gpus=1                         ## Request 1 GPU
#SBATCH --mem=20G                        ## Assign memory
#SBATCH --export=ALL                     ## Export all environment variables

echo "$0 : Starting Gaussian Splatting job on Speed..."
date

REPO_PATH="/speed-scratch/$USER/gaussian_splatting/"
if [ ! -d $REPO_PATH]; then
    mkdir -p $REPO_PATH
    cd $REPO_PATH
    git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive
fi

cd /speed-scratch/$USER/

# Load necessary modules
SINGULARITY=/encs/pkg/singularity-3.10.4/root/bin/singularity

# Set Singularity environment variables for caching
export SINGULARITY_CACHEDIR=/speed-scratch/$USER/singularity_cache
export SINGULARITY_TMPDIR=/speed-scratch/$USER/singularity_tmp
mkdir -p $SINGULARITY_CACHEDIR $SINGULARITY_TMPDIR

# Set the path where the container will be stored
CONTAINER_PATH="/speed-scratch/$USER/3d_gaussian_splatting.sif"

# Check if the container already exists, if not, pull and convert it
if [ ! -f "$CONTAINER_PATH" ]; then
    echo "Pulling container from Docker Hub..."
    $SINGULARITY pull --disable-cache "$CONTAINER_PATH" docker://j3soon/gaussian_splatting
else
    echo "Container already exists at $CONTAINER_PATH. Skipping download."
fi

# Ensure the container file exists before proceeding
if [ ! -f "$CONTAINER_PATH" ]; then
    echo "ERROR: Singularity container was not created successfully!"
    exit 1
fi

# Define bind paths to allow access to necessary directories
SINGULARITY_BIND="$PWD:/speed-pwd,/speed-scratch/$USER:/my-speed-scratch,/nettemp"

echo "Singularity will bind mount: $SINGULARITY_BIND for user: $USER"

# Run the container with GPU support
time \
srun $SINGULARITY run --nv --bind $SINGULARITY_BIND "$CONTAINER_PATH" \
    /usr/bin/python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print("3D Gaussian Splatting Container Running!")'

echo "$0 : Gaussian Splatting job completed!"
date
