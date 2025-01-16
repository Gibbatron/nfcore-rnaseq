#!/bin/bash

# Define colour codes
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

#############
# run fetchngs pipeline
nextflow run nf-core/fetchngs -r 1.10.0 -profile singularity -c resources/my.config -params-file resources/fetchngs-params.yaml
#############


#############
# checksums
# Generate md5checksum for downloaded files with only filenames
for file in input/fastq/*.fastq.gz; do
    md5sum "$file" | sed "s|$file|$(basename "$file")|" >> input/fastq/my-checksums.txt
done

# combine provided checksums into one file
cat input/fastq/md5/*.md5 > input/fastq/provided-checksums.txt

# Compare checksum files
if diff -q input/fastq/my-checksums.txt input/fastq/provided-checksums.txt > /dev/null; then
    echo -e "${GREEN}Checksums match: All downloaded files are verified successfully.${RESET}"
else
    echo -e "${RED}Checksums do not match: There may be issues with the downloaded files.${RESET}"
    echo -e "${YELLOW}Please investigate further. See below for details:${RESET}"
    diff input/fastq/my-checksums.txt input/fastq/provided-checksums.txt
fi
#############
