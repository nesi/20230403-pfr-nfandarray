# Nextflow 

!!! microphone "For the demonstrator"
    * Working directory is **/nesi/project/nesi99999/Dinindu/20230503-pfr-demo/nextflow/**

    * Content of **/example_1** directory is 
      ```bash
      main.nf  Makefile  nextflow.config  nf-clean.sh
      ```
        - If any of the files are missing, download them from [the repo](https://github.com/nesi/20230503-pfr-nfandarray/tree/main/scripts/nextflow/example_1)


!!! example "Example 1"
    - Objective is to create the directory **/output**, populate it with three files `bar.txt  baz.txt  foo.txt` where the content of each file is a single string matching the filename
    -  Launching the workflow can be done with 
    ```bash
    $ module load Nextflow/22.10.3 

    $ nextflow run main.nf
    ```
    !!! danger "It's interactive"
            - Similar to other some workflow management systems, executing `nextflow run main.nf` will launch it as an interactive process. Therefore, it has to be launched as a background process with utilisty such as `tmux` , `screen` , `nohup`. 
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
    