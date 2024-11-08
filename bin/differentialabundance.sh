#!/bin/bash

#############
#create custom samplesheet for differential abundance pipeline
#take first 4 columns from the samplesheet.csv from fetchngs pipeline
awk -F, 'BEGIN {OFS=","} {print $1, $2, $3, $4}' input/samplesheet/samplesheet.csv > resources/diff-abundance-samplesheet.csv

#merge conditions.csv with fastq_1 column in diff-abundance-samplesheet.csv
awk -F, 'BEGIN {OFS=","}
    NR==FNR {
        cond[$1] = $2; next   # Store conditionOne from conditions.csv in an array indexed by sampleID
    }
    FNR==1 {
        print $0, "conditionOne"   # Print header and add new column header
    }
    FNR>1 {
        # Use regex to match any alphanumeric and underscore characters in the fastq_1 column as sampleID
        if (match($2, /[a-zA-Z0-9_]+/)) {
            sampleID = substr($2, RSTART, RLENGTH)
        } else {
            sampleID = "NA"  # Default to NA if no match is found
        }
        print $0, (cond[sampleID] ? cond[sampleID] : "NA") # Add conditionOne if sampleID is found, otherwise "NA"
    }' resources/conditions.csv resources/diff-abundance-samplesheet.csv > resources/tmp && mv resources/tmp resources/diff-abundance-samplesheet.csv
#############

#############
#run differentialabundance pipeline
nextflow run nf-core/differentialabundance -params-file resources/diff-abundance-params.yaml -profile singularity -c resources/my.config
#############