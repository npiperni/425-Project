#!/encs/bin/tcsh

#SBATCH -J "Gaussian Splatting"   # job name
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # number of tasks per node
#SBATCH --cpus-per-task=1   # number of CPU cores per task
#SBATCH --gpus=1   # gpu devices per node
#SBATCH --partition=pg   # partition
#SBATCH --mem=8G   # memory
#SBATCH --mail-type=ALL
#SBATCH --time=7-00:00:00   # job time limit

# timestamp
echo "$0 : about to run a gaussian splatting job on Speed"
date
if ( ! -d /speed-scratch/$USER/conda ) then
  mkdir -p /speed-scratch/$USER/conda
endif

setenv CONDA_ENVS_PATH /speed-scratch/$USER/conda
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/conda/pkg

module load anaconda3
module load cuda/11.8

setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp

if ( ! -d gaussian-splatting ) then
  time srun git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive
endif

cd gaussian-splatting

time srun conda init tcsh

time srun conda env create --file environment.yml
time srun conda activate gaussian_splatting
time srun conda deactivate

# EOF
