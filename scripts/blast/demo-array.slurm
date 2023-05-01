#!/bin/bash -e

#SBATCH --account        nesi99999
#SBATCH --job-name       blast_fastaSplit
#SBATCH --cpus-per-task  1
#SBATCH --mem            2G
#SBATCH --time           24:00:00
#SBATCH --array          0-149%10
#SBATCH --output         /nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast/slurm-logs/%A_%a.out

date;hostname;pwd

module load BLASTDB/2023-04
module load BLAST/2.13.0-GCC-11.3.0
 
export INPUT_DIR=/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast/input-queries
export OUTPUT_DIR=/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast/blast-out

 
RUN_ID=$(( $SLURM_ARRAY_TASK_ID + 1 ))
 
QUERY_FILE=$( ls ${INPUT_DIR} | sed -n ${RUN_ID}p )
QUERY_NAME="${QUERY_FILE%.*}"
 
QUERY="${INPUT_DIR}/${QUERY_FILE}"
OUTPUT="${OUTPUT_DIR}/${QUERY_NAME}.out"
 
echo -e "Command:\nblastn –query ${QUERY} –db nt –out ${OUTPUT} -outfmt 6 -max_target_seqs 1 -num_threads $SLURM_CPUS_PER_TASK"
 
blastn -query ${QUERY} -db nt -out ${OUTPUT} -outfmt 6 -max_target_seqs 1 -num_threads $SLURM_CPUS_PER_TASK 
 
date
