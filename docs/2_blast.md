# Slurm array: Run multiple BLAST queries in parallel with a single submission script

**BLAST** finds regions of similarity between biological sequences. The program compares nucleotide or protein sequences to sequence databases and calculates the statistical significance


??? microphone "For the demonstrator"
    
    - Working directory **/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast**
    - Sequences were delivered in a single file **/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast/parent_file/demo-hic.fa**
    - Sequence file was split to **150** separate queries **by** sequence with `faSplit` and stored in **input-queries** 
      ```bash 
      $ pwd
      /nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast
      
      $ faSplit sequence parent_file/demo-hic.fa 150 split-queries/demo-hic

      $ ls split-queries/

      demo-hic000.fa  demo-hic019.fa  demo-hic038.fa  demo-hic057.fa  demo-hic076.fa  demo-hic095.fa  demo-hic114.fa  demo-hic133.fa
      demo-hic001.fa  demo..............................
      ```
    - Slurm Submission script is **/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast/scripts/demo-array.slurm**
    - Query outputs will be saved to **/blast-out** and the Slurm StdOut to **/slurm-logs**

    
!!! file-code "Slurm array script" 

    ```bash
    #!/bin/bash -e
    
    #SBATCH --account        nesi99999
    #SBATCH --job-name       blast_fastaSplit
    #SBATCH --cpus-per-task  1
    #SBATCH --mem            2G
    #SBATCH --time           24:00:00
    #SBATCH --array          0-149
    #SBATCH --output         /nesi/project/nesi99999/Dinindu/20230503-pfr-demo/blast/slurm-logs/%A_%a.out
    
    date;hostname;pwd
    
    module load BLASTDB/2024-01
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
    ```
    !!! terminal "submit"

        - submit the script with `sbatch scripts/demo-array.slurm` 
             -  If needed, use array throttling (eeping only a certain number of tasks **RUNNING** at a time). Let's say we want to run only 20 queries at a time (out of 149), then adding `#SBATCH --array 0-149%20` to the submission script or call during submission to `sbatch` command with `sbatch --array 0-149%20 scripts/demo-array.slurm`
        - Review the status of submission with `squeue -j jobid`