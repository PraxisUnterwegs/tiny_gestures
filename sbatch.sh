#!/usr/bin/zsh

#SBATCH --account=rwth1557
#SBATCH -p c23g 
#SBATCH --job-name=yolov4_tiny
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --output=output.%J.txt
#SBATCH --time=04:00:00

# 加载 CUDA 和 cuDNN 模块
module load CUDA
module load cuDNN

# 设置 Anaconda 环境变量并激活环境
# export CONDA_ROOT=$HOME/anaconda3
# source $CONDA_ROOT/etc/profile.d/conda.sh
# conda activate pytorch222


# 执行脚本来设置 darknet，确保在 Makefile 中已将 OPENCV 设置为 0
chmod +x HPC_step1__setup_darknet.sh
sh ./HPC_step1__setup_darknet.sh

# 开始训练脚本
chmod +x HPC_step2__start_training.sh
sh ./HPC_step2__start_training.sh

