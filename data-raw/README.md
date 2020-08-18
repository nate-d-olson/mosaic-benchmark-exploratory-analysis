# Data Raw
<!-- File use description
- Raw input data files (read-only)
- datasets released with publication should have accompanying README files and data descriptor files as appropraite.
- Use subfolders for multifile datasets when appropriate and it facilitates documentation
-->

All data files, vcfs and bams, excluding benchmarking results on NAS, file paths relative to mosaic
project bioinformatic directory, `giab/analysis/giab-mosaic-variants/`

## In-Silico AF Analysis


AF numbers - 00, 01, 05, 10, 25, and 50

__BAM Files__  
Files generated using snakemake, `pipelines/make_chrom20_300X_mixtures.smk`.  
- Normal: `data/mixtures/chrom20/300X/normal_sorted.bam`  
- Tumor: `data/mixtues/chrom20/300X/tumor_af{##}_sorted.bam`  

__VCFs__  
- loFreq: `data/vcfs/mixtures/loFreq_chr20_300X_results/tumor_af{#}_sorted.somatic-snvs.vcf.gz`  
- strelka2: `data/vcfs/mixtures/strelka_chr20_300X_results/tumor_af{##}_sorted.{snvs,indels}.vcf.gz`  

## Whole Genome Analysis
__BAMs__: Files removed from NAS, generated using snakemane, `pipelines/make_wg_parents.smk`.   

__VCF__: `data/vcfs/strelka_wgs_combined_parents/HG002_hs37d5_300X_wg.{snvs,indels}.vcf.gz`, see README for additional details.  