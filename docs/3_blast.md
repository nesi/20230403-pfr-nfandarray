# Multiple threaded BLAST  and local database copy

!!! pied-piper "How to find the size of a BLAST database associated with `BLASTDB` - using `nr` as an example"

    Run module show for the BLASTDB module and look for the path starting with /opt/nesi.. under setenv .i.e. 

    ```bash
    $ module show BLASTDB/2024-01 

       /opt/nesi/CS400_centos7_bdw/modules/all/BLASTDB/2024-01.lua:

    whatis("Description: BLAST databases downloaded from NCBI.")
    setenv("BLASTDB","/opt/nesi/db/blast/2024-01")
    ```
    In this instance, it is `/opt/nesi/db/blast/2024-01`

    Now run the following find command pointing to that path and use `nr` prefix for -name `nr.*` .  ( You can use the same command for other databases by replacing nr with the required prefix such as nt, etc
    
    ```bash
    $ find  /opt/nesi/db/blast/2024-01/ -type f -name 'nr.*' -exec du -ch {} + | grep total$
    485G	total
    ```

## Option 1. local copy on Memory 

For jobs which need more than 24 CPU-hours, eg: those that use large databases (> 10 GB) or large amounts of query sequence (> 1 GB), or slow BLAST searches such as classic blastn (blastn -task blastn).

This script copies the BLAST database into the per-job temporary directory `$TMPDIR` before starting the search. Since compute nodes do not have local disks, this database copy is in memory, and so must be allowed for in the memory requested by the job

!!! note ""

    ```bash 
    
    #!/bin/bash -e
    
    #SBATCH --job-name      BLAST
    #SBATCH --time          02:30:00
    #SBATCH --mem           120G  # 30 GB plus the database
    #SBATCH --ntasks        1
    #SBATCH --cpus-per-task 36    # half a node
    
    module load BLAST/2.13.0-GCC-11.3.0
    module load BLASTDB/2024-01
    
    # This script takes one argument, the FASTA file of query sequences.
    QUERIES=$1
    FORMAT="6 qseqid qstart qend qseq sseqid sgi sacc sstart send staxids sscinames stitle length evalue bitscore"
    BLASTOPTS="-task blastn"
    BLASTAPP=blastn
    DB=nt
    #BLASTAPP=blastx
    #DB=nr
    
    # Keep the database in RAM
    cp $BLASTDB/{$DB,taxdb}.* $TMPDIR/ 
    export BLASTDB=$TMPDIR
    
    $BLASTAPP $BLASTOPTS -db $DB -query $QUERIES -outfmt "$FORMAT" \
        -out $QUERIES.$DB.$BLASTAPP -num_threads $SLURM_CPUS_PER_TASK
    ```
    
    
## Option 2. Local copy on **milan** partition local SSD

* NeSI Mahuika cluster `milan` partition compute nodes comes with local NVMe SSDs which can host up to ~1.5TB of data during runtime
* Base Slurm script will be very similar to above with following two Slurm variables

```bash
#SBATCH --partition milan
#SBATCH --gres=ssd
```

* Also we can lower the memory to Blast operational requirements 

!!! note ""

    ```bash 
    
    #!/bin/bash -e
    
    #SBATCH --job-name      BLAST
    #SBATCH --time          02:30:00
    #SBATCH --mem           120G  # 30 GB plus the database
    #SBATCH --ntasks        1
    #SBATCH --cpus-per-task 64    # half a node
    #SBATCH --mem           60G
    #SBATCH --partition     milan
    #SBATCH --gres          ssd
    
    module load BLAST/2.13.0-GCC-11.3.0
    module load BLASTDB/2024-01
    
    # This script takes one argument, the FASTA file of query sequences.
    QUERIES=$1
    FORMAT="6 qseqid qstart qend qseq sseqid sgi sacc sstart send staxids sscinames stitle length evalue bitscore"
    BLASTOPTS="-task blastn"
    BLASTAPP=blastn
    DB=nt
    #BLASTAPP=blastx
    #DB=nr
    
    # Keep the database in RAM
    cp $BLASTDB/{$DB,taxdb}.* $TMPDIR/ 
    export BLASTDB=$TMPDIR
    
    $BLASTAPP $BLASTOPTS -db $DB -query $QUERIES -outfmt "$FORMAT" \
        -out $QUERIES.$DB.$BLASTAPP -num_threads $SLURM_CPUS_PER_TASK
    ```