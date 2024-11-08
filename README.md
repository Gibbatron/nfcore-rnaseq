# rnaseq-course
Repo for nf-core/fetchngs/rnaseq/differentialabundance pipelines to run on Cardiff Universities HAWK.


To clone this repo in your scratch space, use the following code:

```
cd /scratch/c.c1234567
git clone https://github.com/Gibbatron/rnaseq-course.git
```

Then cd to the bin directory and change modifications of the script files.
```
cd rnaseq-course/bin
chmod +x *.sh
```

---
---

Before running the pipelines, you first need to make custom changes:

# Change permissions of the cloned repository
- We need to do this to ensure that any file/directory created by the pipeline inherits the same permissions as the parent directory.
- This is required to avoid any permission-related errors whilst running the pipelines.

- In your scratch directory


## nf-core/fetchngs pipeline

#### my.config
- This is what the pipeline uses.

Things to change:

- Your email address:
`config_profile_contact = 'your-email@cardif.ac.uk'`

- Your SCW project ID:
`clusterOptions = '--account=scw1234'`

#### SRR_Acc_List.txt





#### conditions.csv
This is a simple 2 column table with **sampleID** and **conditionOne** column.
Note: This script currently only works for one condition column. If you would like to use multiple condition columns, please do this manually or contact Alex for support.
Note: This script can be used on your own fastq files as well as on fastq files downloaded using the nf-core/fetchngs pipeline.

**sampleID**
- This can be a list of Accession numbers (SRR or SRX) from the Sequence Read Archive (SRA), or just a list of your fastq files.
**Note: If using the script on your own fastq files, please make sure the name you use is in the name of the fastq file.**
Example: For the script to pick up sample_1_1.fastq, second_sample_1.fastq, this_is_the_third_sample_1.fastq, we could use the following sampleID's: sample_1, second_sample, and third_sample (or this_is_the_third_sample).


**conditionOne** - This is a list of conditions that each sample belongs to.

sampleID|conditionOne
|-------|-----------|
sample_1|Cancer
sample_2|Cancer
sample_3|Cancer
SRR123456|Control
SRR123457|Control
SRR123458|Control

- An `example-conditions.csv` can be found in `resources` directory which refer to the example fastq files within the `input/example_fastqs` directory.
















# To execute the full pipeline:
```
cd ../
module load tmux
tmux new -s full-pipeline
module load nextflow/23.10.0
module load singularity/singularity-ce/3.11.4
./bin/full-pipeline.sh
```

# To execute the individual pipelines:
```
cd ../
module load tmux
tmux new -s name-your-session
module load nextflow/23.10.0
module load singularity/singularity-ce/3.11.4
./bin/name-of-pipeline.sh
```
