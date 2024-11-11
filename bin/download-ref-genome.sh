#!/bin/bash

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