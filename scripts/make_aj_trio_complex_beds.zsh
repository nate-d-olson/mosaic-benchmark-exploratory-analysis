## Dependencies
# vcflib v1.0.1for vcfgeno2haplo
# bedtools v2.29.2 for mergeBed, subtractBed intersectBed, and multiIntersectBed
# htslib 1.10.2 for bgzip
## Using conda environment to manage dependencies


## Variables
GIABID=${1}
BENCHVERSION=v4.2.1
REF=GRCh37
## sed commands to sort beds assumes no "chr" prefix

## Resources
## hs37d5 downloaded from ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
## uncompressed with gunzip and bgzipped
ref_path=resources/hs37d5.fa ## Need to get ref genome
bench_dir=resources/giab_benchmark_${BENCHVERSION}/${REF}/
bench_vcf=${bench_dir}/${GIABID}_${REF}_1_22_${BENCHVERSION}_benchmark.vcf.gz
outroot=data/temp_beds/${GIABID}_${REF}_1_22_${BENCHVERSION}_benchmark ## This directory can be deleted after run
outbed_dir=data/panel_design
outbedroot=${outbed_dir}/${GIABID}_${REF}_1_22_${BENCHVERSION}_benchmark
sv_bed_dir=~/genome-stratifications/${REF}/GenomeSpecific/${GIABID}/SVs ## Need to verify

# ## Generating temp and panel_design directories
# mkdir -p data/{temp_beds,panel_design}

# ## Commented region numbers from HG002 V4.1 GRCh38

# ###############################################################################
# ## Generating complex variant beds ############################################
# ###############################################################################

# ## Merge nearby phased variants to create the subsets below 
# ##vcflib sometimes outputs extra duplicate lines, so need to sort and deduplicate
# vcfgeno2haplo \
#     -w 10 -r ${ref_path} \
#     ${bench_vcf}  \
#     > ${outroot}_geno2haplo10.vcf

# ########## comphetsnp10bp ###################################################

# echo "Making ${GIABID} comphetsnp10bp"

# ## Find compound hets with no length change
# ## i.e., only compound hets where both alleles contain only SNPs or MNPs within 10bp

# # mergeBed part of bedtools
# grep '1/2\|1|2\|2|1\|2/1' ${outroot}_geno2haplo10.vcf \
#     | awk 'BEGIN {FS = "\t\|,"; OFS = "\t"} {if (length($4)==length($5) && length($4)==length($6)) print $1,$2-50,$2+length($4)+50}' \
#     | sed 's/^X/23/;s/^Y/24/;' \
#     | sort -k1,1n -k2,2n \
#     | sed 's/^23/X/;s/^24/Y/' \
#     | mergeBed -i stdin -d 50 \
#     > ${outbedroot}_comphetsnp10bp_slop50.bed

# ## Region Number Check
# echo "Number of Variants in BED region"
# intersectBed \
#     -a ${bench_vcf} \
#     -b ${outbedroot}_comphetsnp10bp_slop50.bed \
#     | wc -l
# #   30475
# intersectBed \
#     -a ${outroot}_geno2haplo10.vcf \
#     -b ${outbedroot}_comphetsnp10bp_slop50.bed \
#     | cut -f1-5 | sort -k1,1 -k2,2n | uniq | wc -l
# #   18278

# ########## comphetindel10bp ################################################### 
# ## Find compound hets where at least 1 allele has a length change
# ## (i.e., only compound hets where at least one allele contains an indel within 10bp) 
# echo "Making ${GIABID} comphetindel10bp"

# grep '1/2\|1|2\|2|1\|2/1' ${outroot}_geno2haplo10.vcf \
#     | awk 'BEGIN {FS = "\t\|,"; OFS = "\t"} {if (length($4)!=length($5) || length($4)!=length($6)) print $1,$2-50,$2+length($4)+50}' \
#     | sed 's/^X/23/;s/^Y/24/;' \
#     | sort -k1,1n -k2,2n \
#     | sed 's/^23/X/;s/^24/Y/' \
#     | mergeBed -i stdin -d 50 \
#     > ${outbedroot}_comphetindel10bp_slop50.bed

# ## Region Number Check
# echo "Number of Variants in BED region"
# intersectBed \
#     -a ${bench_vcf} \
#     -b ${outbedroot}_comphetindel10bp_slop50.bed | wc -l
# #   65257
# intersectBed \
#     -a ${outroot}_geno2haplo10.vcf \
#     -b ${outbedroot}_comphetindel10bp_slop50.bed \
#     | cut -f1-5 | sort -k1,1 -k2,2n | uniq | wc -l
# #  62227

# ########## complexindel10bp ################################################### 
# ## Find complex variants that are not compound hets where there is a 
# ## length change and it is not a simple insertion or deletion
# echo "Making ${GIABID} complexindel10bp"

# grep -v '1/2\|1|2\|2|1\|2/1' ${outroot}_geno2haplo10.vcf \
#     | awk 'BEGIN {FS = "\t"; OFS = "\t"} {if (length($4)!=length($5) && length($4)>1 && length($5)>1) print $1,$2-50,$2+length($4)+50}' \
#     | sed 's/^X/23/;s/^Y/24/;' \
#     | sort -k1,1n -k2,2n \
#     | sed 's/^23/X/;s/^24/Y/' \
#     | mergeBed -i stdin -d 50 \
#     > ${outbedroot}_complexindel10bp_slop50.bed

# ## Region Number Check
# echo "Number of Variants in BED region"
# intersectBed \
#     -a ${bench_vcf} \
#     -b ${outbedroot}_complexindel10bp_slop50.bed \
#     | wc -l
# #   42098

# intersectBed \
#     -a ${outroot}_geno2haplo10.vcf \
#     -b ${outbedroot}_complexindel10bp_slop50.bed \
#     | cut -f1-5 | sort -k1,1 -k2,2n | uniq | wc -l
# #   23625

# ########## snpswithin10bp ##################################################### 
# #Find SNPs within 10bp that are not compound hets
# echo "Making ${GIABID} snpswithin10bp"

# grep -v '^#\|1/2\|1|2\|2|1\|2/1' ${outroot}_geno2haplo10.vcf \
#     | awk 'BEGIN {FS = "\t"; OFS = "\t"} {if (length($4)==length($5) && length($4)>1 ) print $1,$2-50,$2+length($4)+50}' \
#     | sed 's/^X/23/;s/^Y/24/;' \
#     | sort -k1,1n -k2,2n \
#     | sed 's/^23/X/;s/^24/Y/' \
#     | mergeBed -i stdin -d 50 > ${outbedroot}_snpswithin10bp_slop50.bed

# ## Region Number Check
# echo "Number of Variants in BED region"
# intersectBed \
#     -a ${bench_vcf} \
#     -b ${outbedroot}_snpswithin10bp_slop50.bed \
#     | wc -l
# #   227708
# intersectBed \
#     -a ${outroot}_geno2haplo10.vcf \
#     -b ${outbedroot}_snpswithin10bp_slop50.bed \
#     | cut -f1-5 | sort -k1,1 -k2,2n | uniq | wc -l
# #   101929

# ######### othercomplexwithin10bp #####################################################
# #Find additional unphased complex variants and overlapping variants that vcflib ignores
# echo "Making ${GIABID} othercomplexwithin10bp"

# bgzip -dc ${bench_vcf} \
#     | awk '{FS = OFS = "\t"} { print $1,$2,$2+length($4)}' \
#     | grep -v '^#' \
#     | mergeBed -i stdin -d 10 -c 3 -o count \
#     | awk '{FS = OFS = "\t"} { if($4>1) print $1,$2-50,$3+50}' \
#     | mergeBed -i stdin \
#     | subtractBed -a stdin -b ${outbedroot}_comphetindel10bp_slop50.bed \
#     | subtractBed -a stdin -b ${outbedroot}_comphetsnp10bp_slop50.bed \
#     | subtractBed -a stdin -b ${outbedroot}_complexindel10bp_slop50.bed \
#     | subtractBed -a stdin -b ${outbedroot}_snpswithin10bp_slop50.bed\
#      > ${outbedroot}_othercomplexwithin10bp_slop50.bed

########## othercomplexwithin10bp #####################################################
## find union of CNVs and SVs
#### TODO - Check if bed list is HG002 GRCh38 specific
# multiIntersectBed \
#     -i ${sv_bed_dir}/expanded_150_GRCh38_remapped_${GIABID}_SVs_Tier1plusTier2_v0.6.1.bed \
#         ${sv_bed_dir}/GRCh38_mrcanavar_intersect_ccs_1000_window_size_cnv_threshold_intersect_ont_1000_window_size_cnv_threshold.bed \
#         ${sv_bed_dir}/GRCh38_remapped_${GIABID}_SVs_Tier1plusTier2_v0.6.1.bed.gz \
#         ${sv_bed_dir}/GRCh38_union_${GIABID}_CCS_15kb_20kb_merged_ONT_1000_window_size_combined_elliptical_outlier_threshold.bed \
#         ${sv_bed_dir}/HG2_SKor_TrioONTCanu_intersect_HG2_SKor_TrioONTFlye_intersect_HG2_SKor_CCS15_gt10kb_GRCh38.bed \
#         ${sv_bed_dir}/SVMergeInversions.GRCh38.120519.clustered_slop150_chr1_22.bed \
#     | mergeBed -i stdin \
#     | bgzip -c > ${sv_bed_dir}/{$REF}_${GIABID}_GIAB${BENCHVERSION}_CNVsandSVs.bed.gz


## Union of complex stratifications
# #find union of complex variants and SVs
multiIntersectBed \
    -i ${outbedroot}_comphetindel10bp_slop50.bed \
        ${outbedroot}_comphetsnp10bp_slop50.bed \
        ${outbedroot}_complexindel10bp_slop50.bed \
        ${outbedroot}_snpswithin10bp_slop50.bed \
        ${outbedroot}_othercomplexwithin10bp_slop50.bed \
    | mergeBed -i stdin \
    | bgzip -c > ${outbed_dir}/${REF}_${GIABID}_GIAB${BENCHVERSION}_complex.bed.gz
