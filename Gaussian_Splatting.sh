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

time srun git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive


# EOF
