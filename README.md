<!--
Project Description
- Summary/ Objective
- Analysis dependencies
- Note for how to run analyses
- Analyis limitations
-->
# GIAB Mosaic Variant Benchmark Set
Data analysis for manuscript describing the 
development of the HG002 mosaic variant benchmark set.


__Manuscript__ https://docs.google.com/document/d/1Fvm-_wQHCeGCXchjYXFuxLyJllsu90EluqmdQibFjQ0/edit?usp=sharing

## Project Structure
This repository structure is based off of the giab-analysis-template repo,
https://gitlab.nist.gov/gitlab/nolson/giab-analysis-template,
 commit 2e60b1dd8a5b2fa670577e1c5c31d08dbc18c3aa. 


## Analysis Components

### Limit of Detection Analysis

### Candidate Mosaic Variant List Generation
strelka2 run
candidate list generation

### Mosaic Variant List Evaluation

#### In Silico
Snakemake pipeline to calculating PacBio and Illumina read support, `bam_readcount.smk`.

#### Duplex Sequencing
Panel design, `analysis/targeted_panel_design.Rmd`.


