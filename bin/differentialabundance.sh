#!/bin/bash

# Define colour codes
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

#############
# create custom samplesheet for differential abundance pipeline
# take first 4 columns from the samplesheet.csv from fetchngs pipeline
echo -e "${YELLOW}Creating custom samplesheet${RESET}"

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

echo -e "${GREEN}Custom samplesheet created.${RESET}"
#############

#############
# run differentialabundance pipeline
echo -e "${YELLOW}Running differential abundance pipeline${RESET}"
nextflow run nf-core/differentialabundance -params-file resources/diff-abundance-params.yaml -profile singularity -c resources/my.config
echo -e "${GREEN}Differential abundance pipeline completed.${RESET}"
#############

#############
# merge the resulting data tables
echo -e "${YELLOW}Merging output tables${RESET}"
./make-table-diff-abundance.sh
echo -e "${GREEN}Tables merged.${RESET}"
#############

#############
# Remove Ensemble IDs that map to the same gene
echo -e "${YELLOW}Removing duplicate genes from table${RESET}"

# Input table file
input_file="merged_table.tsv"

# Output files
unique_file="merged_table_unique.tsv"
duplicates_file="duplicate_gene_names.tsv"

# Extract the two header rows
head -n 2 "$input_file" > "$unique_file"
head -n 2 "$input_file" > "$duplicates_file"

# Find duplicate gene_name values (column 2 after skipping 2 header rows)
awk -F'\t' 'NR > 2 {count[$2]++} END {for (name in count) if (count[name] > 1) print name}' "$input_file" > duplicates_list.txt

# Filter duplicates into a separate file
awk -F'\t' 'NR <= 2 {next} FNR == NR {dup[$1]; next} $2 in dup' duplicates_list.txt "$input_file" >> "$duplicates_file"

# Filter unique rows into another file
awk -F'\t' 'NR <= 2 {next} FNR == NR {dup[$1]; next} !($2 in dup)' duplicates_list.txt "$input_file" >> "$unique_file"

# Cleanup intermediate file
rm duplicates_list.txt

echo -e "${GREEN}Processing complete. Unique values saved to $unique_file, duplicates saved to $duplicates_file."
#############
echo -e "${GREEN}Pipeline complete.${RESET}"