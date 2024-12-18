#!/bin/bash

# Script to merge data from multiple sources with annotation data.

# Define colour codes
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Define file paths
NORMALISED_COUNTS="output/tables/processed_abundance/all.normalised_counts.tsv"
VST_COUNTS="output/tables/processed_abundance/all.vst.tsv"
ANNOTATION="output/tables/annotation/Mus_musculus.anno.tsv"
OUTPUT_FILE="output/tables/merged_table.tsv"

# Dynamically locate the DEGS file
DEGS=$(ls differential/*.deseq2.results.tsv 2>/dev/null)
if [ -z "$DEGS" ]; then
    echo -e "${RED}Error: No file ending with 'deseq2.results.tsv' found in the 'output/tables/differential' directory. Your nf-core/differentialabundance pipeline may not had run correctly.${RESET}"
    exit 1
fi

# Step 1: Extract the correct columns ('gene_id', 'gene_name', 'gene_biotype') from the annotation table
awk -F'\t' 'BEGIN {
    OFS="\t";
}
NR==1 {
    # Identify the column indices for gene_id, gene_name, and gene_biotype
    for (i=1; i<=NF; i++) {
        if ($i == "gene_id") gene_id_idx = i;
        else if ($i == "gene_name") gene_name_idx = i;
        else if ($i == "gene_biotype") gene_biotype_idx = i;
    }
}
NR>1 {
    # Print the selected columns
    print $gene_id_idx, $gene_name_idx, $gene_biotype_idx;
}' "$ANNOTATION" > annotations.tsv

# Step 2: Extract headers from each input table
normalised_header=$(head -n 1 "$NORMALISED_COUNTS")
vst_header=$(head -n 1 "$VST_COUNTS" | cut -f2-)  # Exclude gene_id
degs_header=$(head -n 1 "$DEGS" | cut -f2-)	  # Exclude gene_id

# Step 3: Create the source row
{
    echo -e "data_type\tgene_name\tgene_biotype\t$(echo "$normalised_header" | awk '{for(i=2;i<=NF;i++) printf("normalised_counts\t"); print ""}')$(echo "$vst_header" | awk '{for(i=1;i<=NF;i++) printf("vst_counts\t"); print ""}')$(echo "$degs_header" | awk '{for(i=1;i<=NF;i++) printf("degs\t"); print ""}')" \
        | sed 's/\t$//'  # Remove trailing tab
} > source_row.tsv

# Step 4: Merge NORMALISED_COUNTS with VST_COUNTS and DEGS
cut -f1 "$NORMALISED_COUNTS" > gene_id_column.tsv  # Extract gene_id as reference
paste "$NORMALISED_COUNTS" <(cut -f2- "$VST_COUNTS") > temp_normalised_vst.tsv
paste temp_normalised_vst.tsv <(cut -f2- "$DEGS") > temp_merged.tsv

# Step 5: Add 'gene_name' and 'gene_biotype' columns based on 'gene_id'
awk -F'\t' 'BEGIN {OFS="\t"}
NR==FNR {anno[$1] = $2 "\t" $3; next}
FNR==1 {print "gene_id", "gene_name", "gene_biotype", $0; next}
{
    # If gene_id exists in annotations, use its gene_name and gene_biotype; otherwise, insert "NA"
    print $1, (anno[$1] ? anno[$1] : "NA\tNA"), $0
}' annotations.tsv temp_merged.tsv > temp_with_annotations.tsv

# Step 6: Add the source row to the final table
cat source_row.tsv temp_with_annotations.tsv > "$OUTPUT_FILE"

# Cleanup intermediate files
rm annotations.tsv gene_id_column.tsv temp_normalised_vst.tsv temp_merged.tsv temp_with_annotations.tsv source_row.tsv

echo -e "${GREEN}Merged table created with annotations >> saved to '$OUTPUT_FILE'.${RESET}"
