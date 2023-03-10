# GPU job script example.
#$ -S /bin/bash
#$ -l h_rt=48:0:0
#$ -l tmem=16G # Initial memory value
#$ -l h_vmem=64G
#$ -wd /home/chuniwu/Projects/WENO
#$ -j y
#$ -N WENO_TCGA
#$ -l gpu=true
#$ -pe gpu 4 # GPU count multiplies initial memory value.
#$ -R y
# Commands to be executed follow.
hostname
date
conda activate pytorch
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/chuniwu/.conda/envs/pytorch/lib/
python3 /home/chuniwu/Projects/WENO/train_TCGAFeat_BagDistillationDSMIL_SharedEnc_Similarity_StuFilterSmoothed_DropPos.py