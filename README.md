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
