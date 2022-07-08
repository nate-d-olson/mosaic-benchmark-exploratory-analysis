# Data files
<!-- File use description
- primary analysis output used in secondary analysis
- mature datasets released with publication should have accompanying README files and data descriptor files as appropraite.
- Use subfolders for multifile datasets when appropriate and it facilitates documentation
-->

## insilico_lod
Benchmarking results for LOD analysis, hap.py output summary.csv files for allele fractions; 0, 0.01, 0.05, 0.1, 0.25, and 0.5. 
Happy was run on precisionFDA. 

[TODO - Add links to precisionFDA benchmarking results.]

## candidate mosaic variants
- 300X Ill whole genome sequencing data: HG002 tumor, HG003 + HG004 normal  
- Strelka2 variant calling and benchmarking results in `strelka2_wgs_parents-vs-child`


## Duplex Sequencing 
### Panel Design

- See `analysis/targeted_panel_design.Rmd` for file descriptions and code used to the following files. 
    - `putative_mosaic_snvs.txt`: non-passing potential mosaic variants detected using strelka included in the panel design request (potentially not included in the final panel due to probe design limitations)
    - `putative_mosaic_indels.txt`:same as the snvs file but for indels.
    - `putative_mosaic_indels_twist_formated.txt`: reformatted version of above for submission to twist
    - `control_variants.txt`: list of control variants included in assay for validation. Control variants are heterozygous for HG003 and homozygous reference for HG002. (TODO - check genotype for HG004) Control variants were the nearest variant within 1.5kb but more that 50bp from a putative/ candidate variant. 
- `twinstrand_panel.bed` - panel design bed file for individual variants see `docs/panel_design` for design documentation provided by TwinStrand.  

- Files provided by Twinstrand in email to Nate Olson from Ellie
```
MD5 (CAP-1_NIST_CellLine_Mutagenesis_targets_hg38.bed) = b587a2ed3a3325e88fcc7cfdb513d8b5
MD5 (FOR_TWIST_probe_placement_CAP-1_NIST_CellLine_Mutagenesis_hg38.fa) = e6924d47a8a14e9e4e1860bf29996cda
MD5 (Merged_Probe_Placement_CAP-1_NIST_CellLine_Mutagenesis_hg38.bed) = a81f79ac3a6cc203e8d15ecf71a413c0
MD5 (Overview_CAP-1_NIST_CellLine_Mutagenesis.pdf) = 6fa8dca2a2e2c68e8e643e54452c1741
MD5 (Targets_with_NO_coverage_CAP-1_NIST_CellLine_Mutagenesis_hg38.bed) = a115623710a19dd285245f3bad867778
MD5 (Targets_with_partial_coverage_CAP-1_NIST_CellLine_Mutagenesis_hg38.bed) = 4b9c6f221464b57b3a36cb9b80999e1b
```

Intermediate files in `panel_design` subdirectory.

### Experimental Metadata Sheets
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

