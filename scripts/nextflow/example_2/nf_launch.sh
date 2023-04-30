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
