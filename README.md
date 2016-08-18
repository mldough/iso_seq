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

Now you can run the snakemake.  It will take you through primer trimming.
