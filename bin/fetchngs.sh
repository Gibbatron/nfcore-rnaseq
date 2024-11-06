#!/bin/bash

#############
#run fetchngs pipeline
nextflow run nf-core/fetchngs -r dev -profile singularity -c resources/my.config -params-file resources/fetchngs-params.yaml
#############