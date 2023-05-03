# Nextflow 

??? microphone "For the demonstrator"
    * Working directory is **/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/nextflow/**

    * Content of **/example_1** directory is 
      ```bash
      main.nf  Makefile  nextflow.config  nf-clean.sh
      ```
        - If any of the files are missing, download them from [the repo](https://github.com/nesi/20230503-pfr-nfandarray/tree/main/scripts/nextflow/example_1)

    * Content of **/example_2** directory is 
      ```bash
      local_config/nesi_mahuika.config  nf_launch.sh
      ```

??? example "Example 1"
    - Objective is to create the directory **/output**, populate it with three files `bar.txt  baz.txt  foo.txt` where the content of each file is a single string matching the filename
    -  Launching the workflow can be done with 
    ```bash
    $ module load Nextflow/22.10.3 

    $ nextflow run main.nf
    ```
    !!! danger "It's interactive"
            - Similar to other some workflow management systems, executing `nextflow run main.nf` will launch it as an interactive process. Therefore, it has to be launched as a background process with a utility such as `tmux` , `screen` , `nohup`. 
            - OR....use Slurm's `wrap` function which is much better than above options 😊
    
    - Therefore, best way to launch is

    !!! terminal "code"
        ```bash
        sbatch --wrap 'nextflow run main.nf'
        ```
    - Check the status with 
    !!! terminal "code"
        ```bash
        #OR use `squeue -j JOBID`
        squeue --me     
        ```
    !!! tower-observation "Can use `nextflow tower`"
        
        No restrictions (firewall rules,etc) with respect to using `nf tower`.  As long as the `TOWER_ACCESS_TOKEN` is defined on current session ( Ideally add it to *~/.bashrc*), tower can be called as usual via `-with-tower` flag and runtime information will be propagated to https://tower.nf/
        ```bash
        sbatch --wrap 'nextflow run main.nf -with-tower'
        ```

??? example "Example 2"

    - This is using the **"image segmentation and extraction of single cell expression data"** pipeline provided by `nf-core` https://nf-co.re/imcyto/1.0.0
    - Given this is a Singularity container based workflow, it required few variables such as `SINGULARITY_BIND`. Ideal approach is to prepare a launch script as below and then submit it with `sbatch`

    
    ```bash
    #!/bin/bash -e

    module purge
    module load Singularity       #Or Apptainer
    module load Nextflow/22.10.3


    #Singularity and Nextflow variables
    export SINGULARITY_BIND="/nesi/project,nesi/nobackup,/opt/nesi"
    export SINGULARITY_TMPDIR=/nesi/nobackup/nesi99999/Dinindu/cache
    export SINGULARITY_CACHEDIR=$SINGULARITY_TMPDIR
    setfacl -b "$SINGULARITY_TMPDIR"
    setfacl -b "/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/nextflow/example_3"

    export NXF_EXECUTOR=slurm
    export NXF_SINGULARITY_CACHEDIR=$SINGULARITY_CACHEDIR

    srun nextflow run nf-core/imcyto -profile test,singularity \
    -c local_config/nesi_mahuika.config  -resume -with-tower
    ```
    - Submit the script with `sbatch nf_launch.sh`