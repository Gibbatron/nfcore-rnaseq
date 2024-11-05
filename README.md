# rnaseq-course
Repo for nf-core/fetchngs/rnaseq/differentialabundance pipelines to run on Cardiff Universities HAWK.


To clone this repo in your scratch space, use the following code:

```
git clone https://github.com/Gibbatron/rnaseq-course.git
```

Then cd to the bin directory and change modifications to make executable
```
cd rnaseq-course/bin
chmod +x pipeline.sh
```

Then to execute pipeline, move into the rnaseq-course directory, open a new tmux session, load modules, and run the script:
```
cd ../
module load tmux
tmux new -s pipeline
module load nextflow/23.10.0
module load singularity/singularity-ce/3.11.4
./pipeline.sh
```