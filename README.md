# rnaseq-course
Repo for nf-core/fetchngs/rnaseq/differentialabundance pipelines to run on Cardiff Universities HAWK.

**Note: Ensure that when you login to HAWK, you login to a specific node (cl1 or cl2) and make note of which one you are logged into: c.c1234567@hawklogin01.cf.ac.uk OR c.c1234567@hawklogin02.cf.ac.uk**

## Clone the repository
- To clone this repo in your scratch space, use the following code:

```
cd /scratch/c.c1234567
git clone https://github.com/Gibbatron/rnaseq-course.git
```

---
---

Before running the pipelines, you first need to make custom changes:

## Change permissions of the cloned repository
- We need to do this to ensure that any file/directory created by the pipeline inherits the same permissions as the parent directory.
- This is required to avoid any permission-related errors whilst running the pipelines.

- In your scratch directory, input the following command:

```
chmod -R 777 rnaseq-course

setfacl -d -m u::rwx,g::rwx,o::rwx rnaseq-course
```

- chmod -R 777 recursively gives the directory and its contents read, write, and execute permissions for everyone
- setfacl is used to set access controls for files and directories. Here, all new files and directories created within the rnaseq-course directory will inherit the same permissions as the parent directory.

---
---

## Change permissions of the scripts
- We can now move into the course directory and modify the permissions of the scripts.

```
cd rnaseq-course
chmod +x bin/*.sh
```
---
---

## nf-core/fetchngs pipeline
- Before running the pipeline, you will firstly need to edit the following:

#### my.config
- This file contains the configurations required by the pipieline to correctly run on HAWK.

Things to change:

- Your email address:
`config_profile_contact = 'your-email@cardif.ac.uk'`

- Your SCW project ID:
`clusterOptions = '--account=scw1234'`

- To change these parameters, open the file in the nano editor, make your changes, then save:

```
nano rnaseq-course/resources/my.config

#make the required changes

#save and exit
ctrl + x
y
enter
```

---

#### ids.csv
- This is the file that contains a list of ID's for each sample that we want to download.
- It can contain SRA-related ID's such as SRRXXXXXX, SRXXXXXXX, SRSXXXXX, SAMNXXXXXX, SRPXXXXXX, SRAXXXXXX, or PRJNAXXXXXXX, ID's from the ENA, DDBJ, or from GEO such as GSMXXXXXXX or GSEXXXXXXX.
- A list of accession ID's can be downloaded from the SRA and used as input here.
- We have covered how to get this list of IDs, we now need to copy and paste them here:

```
nano resources/ids.csv

#delete the first two lines by using backspace, OR:
ctrl + k
ctrl + k

#now paste the IDs. Make sure they are one ID per line.

#save
ctrl + x
y
enter
```

---

#### fetchngs-params.yaml
- This file contains all of the parameter options for the pipeline.
- Instead of including the parameters in the one line that we use to execute the command (which can make it long and prone to typos), we can input them into this file.
- This makes the pipeline execution cleaner and simpler.

Things to change:

- Your email address:
``` email: your-email@cardiff.ac.uk```

- To make the changes, use the nano editor, make changes, and save:

```
nano rnaseq-course/resources/fetchngs-params.yaml

#make the required changes

#save and exit
ctrl + x
y
enter
```

---

### Executing the nf-core/fetchngs pipeline
- Now that we have edited the required files, we can execute the pipeline.
- We firstly need to load and open a tmux session, then load the required modules for the pipeline to run, and then execute the pipeline.

```
#move to course directory (if not already there)
cd rnaseq-course

#load tmux module
module load tmux

#load tmux session named fetchngs
tmux new -s fetchngs

#load nextflow and singularity modules
module load nextflow/23.10.0
module load singularity/singularity-ce/3.11.4

#execute the pipeline
./bin/fetchngs.sh

#stick around for a few minutes to make sure pipeline is running, then exit:
ctrl + b
d
```

---
---

## nf-core/rnaseq pipeline
- Before running the pipeline, you will firstly need to edit the following:

#### my.config
- If you have run the nf-core/fetchngs pipeline, ignore this section. We already have this file created.
- This file contains the configurations required by the pipieline to correctly run on HAWK.

Things to change:

- Your email address:
`config_profile_contact = 'your-email@cardif.ac.uk'`

- Your SCW project ID:
`clusterOptions = '--account=scw1234'`

- To change these parameters, open the file in the nano editor, make your changes, then save:

```
nano rnaseq-course/resources/my.config

#make the required changes

#save and exit
ctrl + x
y
enter
```

---

#### rnaseq-params.yaml
- This file contains all of the parameter options for the pipeline.
- Instead of including the parameters in the one line that we use to execute the command (which can make it long and prone to typos), we can input them into this file.
- This makes the pipeline execution cleaner and simpler.

Things to change:

- Your email address:
``` email: your-email@cardiff.ac.uk```

- **If using mouse/any other species sequencing data, you will need to change the `gtf:` and `fasta:` names to the relevant species. Contact Alex for help with this.**

- To make the changes, use the nano editor, make changes, and save:

```
nano rnaseq-course/resources/rnaseq-params.yaml

#make the required changes

#save and exit
ctrl + x
y
enter
```

---

#### samplesheet.csv
- This file is required by the pipeline so that it knows where the sample sequencing files are located, what each sample ID is etc etc.
- **If you have run the nf-core/fetchngs pipeline, this file will have been generated for you and is located in ```rnaseq-course/input/samplesheet/```.**

- If you need to generate a samplesheet, you can run the `generate-samplesheet.sh` script in `rnaseq-course/bin/` which will generate one for you.
- You will need to move your fastq files to the input directory firstly, then run the script from the course directory:

```
#move to the course directory
cd rnaseq-course

#run the generate-samplesheet.sh script
./bin/generate-samplesheet.sh
```

- In this file, we need the following **four columns at the start of the file**: sample, fastq_1, fastq_2, strandedness.
- You can check this by calling the `head` command:
``` head -1 input/samplesheet/samplesheet.csv```

---

#### reference genome files
- The human reference genome files are required in order for the pipeline to run.
- We don't have to worry about downloading these, as I have included this download step in the pipeline execution script.
- Note: If you need to download a different species reference genome, you will need to edit the bin/rnaseq.sh to include the correct files. Contact Alex for help with this.

---

#### Executing the nf-core/rnaseq pipeline
- Now that we have edited the required files, we can execute the pipeline.
- We firstly need to load and open a tmux session, then load the required modules for the pipeline to run, and then execute the pipeline.

```
#move to course directory (if not already there)
cd rnaseq-course

#load tmux module
module load tmux

#load tmux session named fetchngs
tmux new -s rnaseq

#load nextflow and singularity modules
module load nextflow/23.10.0
module load singularity/singularity-ce/3.11.4

#execute the pipeline script
./bin/rnaseq.sh

#stick around for a few minutes to make sure pipeline is running, then exit:
ctrl + b
d
```

---
---

## nf-core/differentialabundance pipeline`
- Before running the pipeline, you will firstly need to edit the following:

#### my.config
- If you have run the nf-core/fetchngs and /rnaseq pipelines, ignore this section. We already have this file created.
- This file contains the configurations required by the pipieline to correctly run on HAWK.

Things to change:

- Your email address:
`config_profile_contact = 'your-email@cardif.ac.uk'`

- Your SCW project ID:
`clusterOptions = '--account=scw1234'`

- To change these parameters, open the file in the nano editor, make your changes, then save:

```
nano rnaseq-course/resources/my.config

#make the required changes

#save and exit
ctrl + x
y
enter
```

---

#### diff-abundance-params.yaml
- This file contains all of the parameter options for the pipeline.
- Instead of including the parameters in the one line that we use to execute the command (which can make it long and prone to typos), we can input them into this file.
- This makes the pipeline execution cleaner and simpler.

Things to change:

- Your email address:
``` email: your-email@cardiff.ac.uk```

- Study name:
``` study_name: NAME-YOUR-PROJECT```

- **If using mouse/any other species sequencing data, you will need to change the `gtf:` name to the relevant species. Contact Alex for help with this.**

- To make the changes, use the nano editor, make changes, and save:

```
nano rnaseq-course/resources/diff-abundance-params.yaml

#make the required changes

#save and exit
ctrl + x
y
enter
```

---

#### reference genome gene reference
- The human reference genome files are required in order for the pipeline to run.
- We don't have to worry about downloading these, as I have included this download step in the pipeline execution script.
- Note: If you need to download a different species reference genome, you will need to edit the bin/rnaseq.sh to include the correct files. Contact Alex for help with this.

- We will need to specify the human gene reference file.
- If you have run the nf-core/rnaseq pipeline, you will already have this file downloaded.
- If you need to download the reference files, run the following:

```
#move to course directory
cd rnaseq-course

#execute script
./bin/download-ref-genome.sh
```

---

#### diff-abundance-samplesheet.csv
- This file is required by the pipeline so that it knows where the sample sequencing files are located, what each sample ID is etc etc. 
- For this pipeline, we need to use the samplesheet that we used for the rnaseq pipeline, but with an additional column(s).
- **If you have run the nf-core/fetchngs pipeline, this file will have been generated for you and is located in ```rnaseq-course/input/samplesheet/```.**

- For this pipeline, I will assume you already have a `samplesheet.csv` file located within the `input/samplesheet/` directory.
- If you do not have a `samplesheet.csv` file, you can create one by runing the `generate-samplesheet.csv` script:

```
#move to course directory (if not already there)
cd rnaseq-course

#execute the generate-samplesheet.sh script
./bin/generate-samplesheet.sh
```

- The diff-abundance-samplesheet.csv gile will be generated by the script that I have made, which then runs the differentialabundance pipeline afterwards.

---

#### conditions.csv
- This is a simple 2 column table with **sampleID** and **conditionOne** column.
- Note: This script currently only works for one condition column. If you would like to use multiple condition columns, please do this manually or contact Alex for support.
- Note: This script can be used on your own fastq files as well as on fastq files downloaded using the nf-core/fetchngs pipeline.

**sampleID**
- This can be a list of Accession numbers (SRR or SRX) from the Sequence Read Archive (SRA), or just a list of your fastq files.
- **Note: If using the script on your own fastq files, please make sure the name you use is in the name of the fastq file.**
- Example: For the script to pick up sample_1_1.fastq, second_sample_1.fastq, this_is_the_third_sample_1.fastq, we could use the following sampleID's: sample_1, second_sample, and third_sample (or this_is_the_third_sample).


**conditionOne**
- This is a list of conditions that each sample belongs to.

sampleID|conditionOne
|-------|-----------|
sample_1|Cancer
sample_2|Cancer
sample_3|Cancer
SRR123456|Control
SRR123457|Control
SRR123458|Control

- An `example-conditions.csv` can be found in `resources` directory which refer to the example fastq files within the `input/example_fastqs` directory.

- Edit the `conditions.csv` file in nano:

```
nano resources/conditions.csv

#make the required changes

#save and exit
ctrl + x
y
enter
```

---

#### contrasts.csv
- This is another simple file required by the pipeline in order to perform differential testing.
- It consists of 4 columns: id, variable, reference, target
- id: name of the analysis.
- variable: name of the column that you want the pipeline to use for groupings.
- reference: this is the group name of your CONTROL group. i.e. what you want to compare against.
- target: this is the group name of your COMPARISON group.
- I have already made this file, so there is no need to edit it.

---
---

#### Executing the nf-core/rnaseq pipeline
- Now that we have edited the required files, we can execute the pipeline.
- We firstly need to load and open a tmux session, then load the required modules for the pipeline to run, and then execute the pipeline.

```
#move to course directory (if not already there)
cd rnaseq-course

#load tmux module
module load tmux

#load tmux session named fetchngs
tmux new -s diff-abundance

#load nextflow and singularity modules
module load nextflow/23.10.0
module load singularity/singularity-ce/3.11.4

#execute the pipeline script
./bin/differentialabundance.sh

#stick around for a few minutes to make sure pipeline is running, then exit:
ctrl + b
d
```

---
---