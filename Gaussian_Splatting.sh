#!/encs/bin/tcsh

#SBATCH --job-name=gaussian_splatting        ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --chdir=./             ## Use currect directory as working directory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1      ## Request 1 cpus
#SBATCH --mem=1G               ## Assign 1G memory per node

# timestamp
echo "$0 : about to run a gaussian splatting job on Speed"
date

module load anaconda3 /2023.03/ default
module load cuda /11.8/ default

time srun git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive
cd gaussian-splatting

time srun conda env create --file environment.yml
time srun conda activate gaussian_splatting
time srun conda deactivate

# EOF
