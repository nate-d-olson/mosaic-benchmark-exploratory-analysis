#!/bin/zsh

echo "AJ V4.2.1 benchmark bed intersection"
bench_intersect_bed=data/panel_design/aj_trio_benchmark_intersect.bed
## Modify to filter
multiIntersectBed \
    -i resources/giab_benchmark_v4.2.1/GRCh37/HG00{2,3,4}_GRCh37_1_22_v4.2.1_benchmark_noinconsistent.bed \
    | awk '$4==3' \
    | mergeBed -i stdin \
    > ${bench_intersect_bed}


echo "Checking number of regions"
## Calculating number of regions and total region size
wc -l ${bench_intersect_bed}

echo "Checking region size"
## Calculating total region size
awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}' \
    ${bench_intersect_bed}

###############################################################################
echo "AJ V4.2.1 benchmark complex union"
complex_union_bed=data/panel_design/aj_trio_complex_union.bed
multiIntersectBed \
    -i data/panel_design/GRCh37_HG00{2,3,4}_GIABv4.2.1_complex.bed.gz \
    | mergeBed -i stdin \
    > ${complex_union_bed}

echo "Checking number of regions"
## Calculating number of regions and total region size
wc -l ${complex_union_bed}

echo "Checking region size"
## Calculating total region size
awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}' \
    ${complex_union_bed}


###############################################################################
## Mosaic Target Regions - benchmark intersect minus complex intersect

echo "Generating Mosaic Target Region Bed"
mosaic_target=data/panel_design/GRCh37_aj-trio_v4.2.1_mosaic-target.bed

subtractBed \
    -a ${bench_intersect_bed} \
    -b ${complex_union_bed} \
    | mergeBed -i stdin \
    > ${mosaic_target}

echo "Checking number of regions"
## Calculating number of regions and total region size
wc -l ${mosaic_target}

echo "Checking region size"
## Calculating total region size
awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}' \
    ${mosaic_target}


###############################################################################
## Identifying variants in target region 

echo "Candidate Mosaic Variants"
candidate_mosaic_vars=data/panel_design/GRCh37_aj-trio_v4.2.1_candidate_mosaic.vcf

## Note the output is a headerless VCF
intersectBed -header \
    -a data/strelka2_wgs_parents-vs-child/vcfeval_comparison/fp.vcf.gz \
    -b ${mosaic_target} \
    > ${candidate_mosaic_vars}

echo "Number of putative mosaic variants"
grep -v "^#" ${candidate_mosaic_vars} | wc -l 

echo "Number of candidate mosaic variants"
grep "PASS" ${candidate_mosaic_vars} | wc -l

