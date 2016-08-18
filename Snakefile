shell.prefix("source config.sh;")

configfile: "config.json"

import os
import glob
import csv

TOPGROUP = "human chimp gorilla rhesus".split()

NAMES  = []
LOOKUP = {}

for i in config.keys():
    for j in config[i].keys():
        LOOKUP[j] = i
        NAMES.append(j)

def _get_group_by_name(wildcards):
    return print(LOOKUP[wildcards.names])

def _get_files_by_name(wildcards):
    return config[LOOKUP[wildcards.names]][wildcards.names]

rule dummy:
     input: expand("primer_trimmed/{top}/isoseq_flnc.fasta", top=TOPGROUP), expand("merged_fastq/{top}.post-pbccs.fq", top=TOPGROUP)

rule primerTrim:
     input:   FAS="merged_fasta/{top}.post-pbccs.fa", BCC="do_barcode.sh"
     output: "primer_trimmed/{top}/isoseq_flnc.fasta"
     params:  sge_opts="-l mfree=20G -l h_rt=12:00:00 -q eichler-short.q -V -cwd"
     shell:  "cd primer_trimmed/{wildcards.top} ; ln -s ../../{input.FAS} ccs.fasta ; cp ../../{input.BCC} . ; source {input.BCC}"

rule mergeFa:
     input:   FASTA=expand("post_pbccs_fasta/{names}.fa", names=NAMES), FASTQ=expand("post_pbccs_fastq/{names}.fq", names=NAMES)
     output:  FAS="merged_fasta/{top}.post-pbccs.fa" , FAQ="merged_fastq/{top}.post-pbccs.fq"
     params:  sge_opts="-l mfree=1G -l h_rt=12:00:00 -q eichler-short.q"
     shell:   "cat post_pbccs_fasta/{wildcards.top}*fa > {output.FAS} && cat post_pbccs_fastq/{wildcards.top}*fq > {output.FAQ}"

rule bamToFastq:
     input: BAM="pbccs_results/{names}.pbccs.bam", XML="pbccs_results/{names}.pbccs.consensusreadset.xml"
     output: "post_pbccs_fastq/{names}.fq"
     params:  sge_opts="-l mfree=3G -l h_rt=48:00:00 -q eichler-short.q"
     shell: "bamtools convert -in {input.BAM} -format fastq > {output}"

rule bamToFasta:
     input: BAM="pbccs_results/{names}.pbccs.bam", XML="pbccs_results/{names}.pbccs.consensusreadset.xml"
     output: "post_pbccs_fasta/{names}.fa"
     params:  sge_opts="-l mfree=3G -l h_rt=48:00:00 -q eichler-short.q"
     shell: "bamtools convert -in {input.BAM} -format fasta > {output}"

rule ccs:
     input : BAM="cc2_bams/{names}.subreads.bam", CCS="pitchfork/deployment/bin/ccs"
     output: "pbccs_results/{names}.pbccs.bam", "pbccs_results/{names}.pbccs.consensusreadset.xml"
     params:  sge_opts="-l mfree=4G -l h_rt=48:00:00 -q eichler-short.q -pe serial 4"
     shell : "{input.CCS} --numThreads=4 --minLength=200 {input.BAM} {output[0]}"

rule bax2bam:
     input : BAX2BAM="pitchfork/deployment/bin/bax2bam", FL=_get_files_by_name
     output: "cc2_bams/{names}.subreads.bam"
     params:  sge_opts="-l mfree=15G -l h_rt=06:00:00 -q eichler-short.q",  FD=_get_group_by_name
     shell :  "{input.BAX2BAM} -o cc2_bams/{wildcards.names} {input.FL}"

rule pitchfork:
     output: "pitchfork/deployment/bin/bax2bam", "pitchfork/deployment/bin/ccs"
     params:  sge_opts="-l mfree=5G -l h_rt=24:00:00 -q eichler-short.q"
     shell : "git clone https://github.com/PacificBiosciences/pitchfork.git ; cd pitchfork ; make init ; make blasr ;  make pbccs ; "