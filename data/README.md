# Data files
<!-- File use description
- primary analysis output used in secondary analysis
- mature datasets released with publication should have accompanying README files and data descriptor files as appropraite.
- Use subfolders for multifile datasets when appropriate and it facilitates documentation
-->

## insilico_lod
Benchmarking results for LOD analysis, hap.py output summary.csv files for allele fractions; 0, 0.01, 0.05, 0.1, 0.25, and 0.5. 
Happy was run on precisionFDA. 

__TODO__ Add links to precisionFDA benchmarking results.

## candidate mosaic variants
- 300X Ill whole genome sequencing data: HG002 tumor, HG003 + HG004 normal  
- Strelka2 variant calling and benchmarking results in `strelka2_wgs_parents-vs-child`

## Duplex Sequencing 
Intermediate files in `panel_design` subdirectory.

- `mosaic-dupseq_sample_sheet.tsv`: Metadata sheet for sequenced samples
    - columns: 
        - `sample_id`: project sample id,
        - `project`: "GIAB" or "GEC" for genome in a bottle or genome editing consortium
        - `sample_type`: in vitro mixture (mixed) or unmixed sample
        - `exp_AF`: Expected AF based on mixture design
        - `n_reps`: Number of library/ sequencing replicates

- `mosaic-dupseq_probe-metadata.tsv`: metadata sheet for custom probes
    - columns:
        - `CHROM_GRCh37`: GRCh37 chromosome
        - `START_GRCh37`: GRCh37 start coordinate
        - `STOP_GRCh37`: GRCh37 stop coordinate
    	- `CHROM_GRCh38`: GRCh38 chromosome
    	- `START_GRCh38`: GRCh87 start coordinate
    	- `STOP_GRCh38`: GRCh38 stop coordinate
    	- `rsid`: variant id
    	- `var_id`: project specific variant id
    	- `var_type`: variant type (SNP or InDel)
    	- `var_cat`: variant category either control, putative, or candidate. candidate variants PASS the strelka2 filter, putative variants are identified by strelka2 but filtered commonly due to low SomaticEVS
    	- `filter`: strelka2 assigned filter value
    	- `SomaticEVS`: somatic variant quality score provided by strelka2
    	- `AF`: allele frequency from strelka2
    	- `grch38_lftovr_err`: variants where lift reciprocal liftover did not match GRCh38 coords.
    	- `grch37_lftovr_err`: variants where lift reciprocal liftover did not match GRCh37 coords.
