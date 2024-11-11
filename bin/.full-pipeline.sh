#!/bin/bash

#############
#run fetchngs pipeline
nextflow run nf-core/fetchngs -r dev -profile singularity -c resources/my.config -params-file resources/fetchngs-params.yaml
#############

#############
#download reference genome
#download the human GRCh38 reference DNA sequence
cd resources/
wget https://ftp.ensembl.org/pub/release-110/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz 
gunzip Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz

#download the human GRCh38 reference gene information file
wget https://ftp.ensembl.org/pub/release-110/gtf/homo_sapiens/Homo_sapiens.GRCh38.110.gtf.gz 
gunzip Homo_sapiens.GRCh38.110.gtf.gz
cd ../
#############

#############
#run rnaseq pipeline
nextflow run nf-core/rnaseq -profile singularity -c resources/my.config -params-file resources/rnaseq-params.yaml
#############

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
        match($2, /SRR[0-9]+/)     # Extract the sampleID from fastq_1 column
        sampleID = substr($2, RSTART, RLENGTH)
        print $0, (cond[sampleID] ? cond[sampleID] : "NA") # Add conditionOne if sampleID is found, otherwise "NA"
    }' resources/conditions.csv resources/diff-abundance-samplesheet.csv > resources/tmp && mv resources/tmp resources/diff-abundance-samplesheet.csv
#############

#############
#run differentialabundance pipeline
nextflow run nf-core/differentialabundance -params-file resources/diff-abundance-params.yaml -profile singularity -c resources/my.config
#############