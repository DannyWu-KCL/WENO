# GPU job script example.
#$ -S /bin/bash
#$ -l h_rt=1:0:0
#$ -l tmem=2G # Initial memory value. Note no h_vmem.
#$ -wd /home/users/Projects/WENO
#$ -j y
#$ -N Base_WENO_TCGA
#$ -l gpu=true
#$ -pe gpu 2 # GPU count multiplies initial memory value.
#$ -R y
# Commands to be executed follow.
hostname
date
/home/users/Projects/WENO/train_TCGAFeat_BagDistillationDSMIL_SharedEnc_Similarity_StuFilterSmoothed_DropPos.py