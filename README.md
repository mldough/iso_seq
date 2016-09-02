# iso_seq

“We can't stop here, this is bat country!”

--Hunter S. Thompson

Now that you understand this is insane continue:

# dependencies

Pitchfork https://github.com/PacificBiosciences

installed here:

/net/eichler/vol18/zevk/great_apes/iso_seq/cc2_analysis/pitchfork/

pbtranscript and venn_tofu https://github.com/PacificBiosciences/pbtranscript

installed here

~zevk/projects

# Before running snakemake

qlogin with 5G

then run:

```
export SMRT_ROOT=/net/eichler/vol24/projects/sequencing/pacbio/software/smrtanalysis
${SMRT_ROOT}/current/smrtcmds/bin/smrtshell
export VENV_TOFU=~zevk/projects/VENV_TOFU
source ${VENV_TOFU}/bin/activate
```

VENV_TOFU was insane to install.  I'm sorry the install is in my home directory

Now you want to install snakemake.  Do not use anaconda or it overwrites the python pbtranscript needs.

```
pip install snakemake
```

Now you can run the snakemake.  It will take you through primer trimming.


#clustering with ICE

You need to request a big qlogin because blasr_nproc is local, ie, not qsubbed.

```
tofu_wrap.py --nfl_fa chimp_nfl.fastq --bas_fofn chimp.input.fofn  -d clusterOut --use_sge --max_sge_jobs 20 --blasr_nproc 4 --gcon_nproc 2 --quiver_nproc 2 --quiver --bin_manual "(0,1,2,3,8)" --output_seqid_prefix chimp_ice --sge_env_name serial --gmap_db /net/eichler/vol2/eee_shared/assemblies/GRCh38/indexes/gmap2 --gmap_name "GRCh38" chimp_flnc.fastq chimp.final.consensus.fasta
```


