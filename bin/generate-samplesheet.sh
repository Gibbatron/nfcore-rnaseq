#!/bin/bash

# Define colour codes
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Define base directory
myDir=$(pwd)

# Define the output CSV file name
output_csv="$myDir/input/samplesheet/samplesheet.csv"
output_dir=$(dirname "$output_csv")

# Make samplesheet directory if it doesn't already exist
mkdir -p  "$output_dir"

# Print the header of the CSV file
echo "sample,fastq_1,fastq_2,strandedness" > $output_csv

# Define the base directory where the FASTQ files are located
fastq_dir="$myDir"/input/fastq

########################################################################
########################################################################
# Function to process FASTQ files with '_R1_001.fastq.gz' and '_R2_001.fastq.gz' naming convention
process_r1_r2() {
    for fastq_1 in "$fastq_dir"/*_R1_001.fastq.gz; do
        # Derive the sample name from the FASTQ file path
        sample=$(basename "$fastq_1" | sed 's/_R1_001.fastq.gz//')
        
        # Construct the path for the second FASTQ file
        fastq_2="${fastq_dir}/${sample}_R2_001.fastq.gz"
        
        # Check if the second FASTQ file exists
        if [[ -f "$fastq_2" ]]; then
            # Append the row to the CSV file
            echo "${sample},${fastq_1},${fastq_2},auto" >> $output_csv
        else
            echo -e "${YELLOW}Warning: Paired file for ${fastq_1} not found!${RESET}"
        fi
    done
}
########################################################################
########################################################################


########################################################################
########################################################################
# Function to process FASTQ files with '_1.fastq.gz' and '_2.fastq.gz' naming convention
process_1_2() {
    for fastq_1 in "$fastq_dir"/*_1.fastq.gz; do
        # Derive the sample name from the FASTQ file path
        sample=$(basename "$fastq_1" | sed 's/_1.fastq.gz//')
        
        # Construct the path for the second FASTQ file
        fastq_2="${fastq_dir}/${sample}_2.fastq.gz"
        
        # Check if the second FASTQ file exists
        if [[ -f "$fastq_2" ]]; then
            # Append the row to the CSV file
            echo "${sample},${fastq_1},${fastq_2},auto" >> $output_csv
        else
            echo -e "${YELLOW}Warning: Paired file for ${fastq_1} not found!${RESET}"
        fi
    done
}
########################################################################
########################################################################


########################################################################
########################################################################
# Function to process FASTQ files with '_1.fq.gz' and '_2.fq.gz' naming convention
process_fq1_fq2() {
    for fastq_1 in "$fastq_dir"/*_1.fq.gz; do
        # Derive the sample name from the FASTQ file path
        sample=$(basename "$fastq_1" | sed 's/_1.fq.gz//')
        
        # Construct the path for the second FASTQ file
        fastq_2="${fastq_dir}/${sample}_2.fq.gz"
        
        # Check if the second FASTQ file exists
        if [[ -f "$fastq_2" ]]; then
            # Append the row to the CSV file
            echo "${sample},${fastq_1},${fastq_2},auto" >> $output_csv
        else
            echo -e "${YELLOW}Warning: Paired file for ${fastq_1} not found!${RESET}"
        fi
    done
}
########################################################################
########################################################################


########################################################################
########################################################################
# Check for FASTQ files with the above naming conventions
if ls "$fastq_dir"/*_R1_001.fastq.gz 1> /dev/null 2>&1; then
    echo -e "${YELLOW}Processing files with '_R1_001.fastq.gz' naming convention...${RESET}"
    process_r1_r2
fi

if ls "$fastq_dir"/*_1.fastq.gz 1> /dev/null 2>&1; then
    echo -e "${YELLOW}Processing files with '_1.fastq.gz' naming convention...${RESET}"
    process_1_2
fi

if ls "$fastq_dir"/*_1.fq.gz 1> /dev/null 2>&1; then
    echo -e "${YELLOW}Processing files with '_1.fq.gz' naming convention...${RESET}"
    process_fq1_fq2
fi

# Check if any rows (beyond the header) were added to the CSV file
if [[ $(wc -l < "$output_csv") -le 1 ]]; then
    echo -e "${RED}No compatible FASTQ files found in $fastq_dir${RESET}"
else
    echo -e "${GREEN}CSV file created: $output_csv${RESET}"
fi
########################################################################
########################################################################
