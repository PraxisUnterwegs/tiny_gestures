# download the Dataset

This step is the same with `README.md`

The download link from onedrive is here: 
https://m365rwthaachende.sharepoint.com/:f:/s/GINI/EmVqjWBB-qdKtGxH_1NiHjcBxwssn5BMaZ_F7c3wc1bwTA

The dataset includes: images_train.zip & images_val.zip

They are all put into the directory, which path is: "Development/ai/gesture_recognition/tinyyolov4/dataset"

# upload the dataset to the HPC

use scp command to upload the dataset (zip file) to the HPC account.

Then use the command `unzip images_train.zip` to unzip the dataset. This process is the same with `README.md`

# begin to train

`cd` to the path `tiny_gestures`.

And the command is : `sbatch sbatch.sh`

Then the training process will begin.

U can monitor the training process through checking the slurm job log file, like "output.46350467.txt". 46350467 is the id of the job u submitted by sbatch script.
