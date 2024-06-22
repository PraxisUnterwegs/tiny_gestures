#!/usr/bin/zsh

#SBATCH --account=rwth1557
#SBATCH -p c23g 
#SBATCH --job-name=yolov4_tiny
#SBATCH --gres=gpu:2
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --output=output.%J.txt
#SBATCH --time=24:00:00
 
export CONDA_ROOT=$HOME/anaconda3 
export PATH="$CONDA_ROOT/bin:$PATH"
 
source activate pytorch222
 
module load CUDA
echo; export; echo; nvidia-smi; echo

# Get the directory where the script is located
script_dir=$(dirname "$0")

# Configuration file path
config_file="$script_dir/yolov4-tiny-custom.cfg"

# Use the sed command to modify the configuration file
sed -i '6s/^batch=64/batch=512/' "$config_file"
sed -i '7s/^subdivisions=4/subdivisions=8/' "$config_file"

echo "Configuration file is modified: "
echo "batch=512"
echo "subdivisions=8"

# start training script
chmod +x step2__start_training.sh
 
sh ./step2__start_training.sh
