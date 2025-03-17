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

echo "$0 : about to run a gaussian splatting job on Speed"
date

module load anaconda3
module load cuda/11.8
module load singularity

time srun which singularity

setenv SINGULARITY_CACHEDIR /speed-scratch/$USER/singularity_cache
setenv SINGULARITY_TMPDIR /speed-scratch/$USER/singularity_tmp
mkdir -p $SINGULARITY_CACHEDIR $SINGULARITY_TMPDIR

time srun singularity pull --disable-cache /scratch-speed/$USER/3d_gaussian_splatting.sif docker://gaetanlandreau/3d-gaussian-splatting
ls -lh /speed-scratch/$USER/
