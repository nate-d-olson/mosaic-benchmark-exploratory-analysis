# Scripts
<!-- File use description
- Scripts use in primary and secondary analysis. 
- Can group scripts in subfolders when appropraite, e.g. by language or analysis.
-->

- `bam_readcount.smk`: Calculate read support for strelka2 variants
- `bam_readcount_helper.py`: Helper scripts for parsing read count output, used by `bam_readcount.smk`.
- `hifi_bams.tsv`: config table for `bam_readcount.smk`.
- `make_aj_trio_complex_beds.zsh`: Generates complex variant beds for V4.2.1 AJ trio benchmarks. 
- `merge_bechmark_vcfs.zsh`: Combining AJ Trio V4.2.1 benchmark vcfs, combined vcf used for panel design.
- `run_make_complex.zsh`: Helper script for running the `make_aj_trio_complex_beds.zsh` on all trio members.