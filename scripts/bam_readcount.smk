## Read Support Pipeline
###############################################################################
## Adding Read Count/ base support info
##  Root directory - /Volumes/giab/data/alignment/AshkenazimTrio/PacBio
## Input HiFi
## HG002:
## - PacBio_CCS_10kb/HG002.PacBio.10kbCCS.Q20.hs37d5.pbmm2.MAPQ60.HP10xtrioRTG.bam
## - PacBio_CCS_15kb/HG002.Sequel.15kb.pbmm2.hs37d5.whatshap.haplotag.RTG.10x.trio.bam
## - PacBio_CCS_15kb_20kb_chemistry2/GRCh37/HG002.SequelII.merged_15kb_20kb.GRCh37.duplomap.bam
## - PacBio_Sequel2_CCS_11kb/HG002.SequelII.pbmm2.hs37d5.whatshap.haplotag.RTG.10x.trio.bam

## HG003
## - PacBio_CCS_Google/GRCh37/HG003/HG003.grch37.bam
## - PacBio_CCS_15kb_20kb_chemistry2/GRCh37/HG003.hs37d5.consensusalignments.bam

## HG004
## - PacBio_CCS_Google/GRCh37/HG004/HG004.grch37.bam
## - PacBio_CCS_15kb_20kb_chemistry2/GRCh37/HG004.hs37d5.consensusalignments.bam

### Use bam-readcount to calculate read support
## https://github.com/genome/bam-readcount 
## Conda package - mamba install -c bioconda bam-readcount; requires python2.7 TODO add vt and cyvcf2 for helper script

## Pipeline dependencies - bam-readcount

## Import dependencies
import pandas as pd
from snakemake.utils import min_version
from snakemake.remote.FTP import RemoteProvider as FTPRemoteProvider
## File download
FTP = FTPRemoteProvider()

## Variables
bam_tbl_path="scripts/hifi_bams.tsv"
nas_bam_root="/Volumes/giab/data/alignment/AshkenazimTrio/PacBio"

## Read table of samples and set wildcard prefix and constraints
bam = pd.read_table(bam_tbl_path).set_index(["giab_id", "lib"], drop = False)

## Wildcards
GIABID = list(set(bam["giab_id"]))
LIB =list(set(bam["lib"]))
BAMID = f'bam["giab_id"]_bam["lib"]'

wildcard_constraints:
    giab_id="|".join(GIABID),
    lib="|".join(LIB)



## Ref URL
grch37_url = "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz"

## Running pipeline
rule all:
    input: 
        expand("data/readcount/{giab_id}-{lib}.txt", zip, 
            giab_id=bam["giab_id"], lib = bam["lib"])


# Get Reference

rule get_GRCh37:
    input: FTP.remote(grch37_url)
    output: "resources/GRCh37.fna"
    shell: "gunzip -c {input} > {output}"    

rule index_ref:
    input: "resources/GRCh37.fna"
    output: "resources/GRCh37.fna.fai"
    wrapper: "0.38.0/bio/samtools/faidx"

## Generate BED for candidate mosaic variants ---------------------------------
rule make_mosaic_bed:
    input: "data/panel_design/GRCh37_aj-trio_v4.2.1_candidate_mosaic.vcf"
    output: "data/readcount/GRCh37_aj-trio_v4.2.1_candidate_mosaic.bed"
    shell: """
        cut -f1-5 {input} \
            | sort -k1,1 -k2,2n \
            | uniq \
            > {output}
    """

## Decompose Candidate Mosaic Variants
rule decompose_vcf:
    input: "data/panel_design/GRCh37_aj-trio_v4.2.1_candidate_mosaic.vcf"
    output: "data/temp/decomposed_candidate_mosaic.vcf"
    conda: "../envs/bam-readcount.yaml" 
    shell: """
        vt decompose -s {input} -o {output}
    """

## Calculate Read Support  ----------------------------------------------------
def get_bam(wildcards):
    path=bam.loc[(wildcards.giab_id, wildcards.lib), "path"]
    return(f"{nas_bam_root}/{path}")

rule calc_readsupport:
    input: 
        bam=get_bam,
        vcf="data/temp/decomposed_candidate_mosaic.vcf",
        ref="resources/hs37d5.fa"
    output: "data/readcount/{giab_id}-{lib}.txt"
    conda: "../envs/bam-readcount.yaml"
    params: 
        prefix="{giab_id}-{lib}",
        outdir="data/readcount/"
    shell: """
        scripts/bam_readcount_helper.py \
            {input.vcf} \
            {params.prefix} \
            {input.ref} \
            {input.bam} \
            {params.outdir}
    """
