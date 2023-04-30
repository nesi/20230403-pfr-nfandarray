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