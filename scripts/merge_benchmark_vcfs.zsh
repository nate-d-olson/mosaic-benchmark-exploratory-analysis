#!/bin/zsh

BENCHDIR=resources/giab_benchmark_v4.2.1/GRCh37

## Fix sample names in benchmark VCF files
echo "INTEGRATION   HG002" > hg002_name_fix.txt
bcftools reheader \
    -s hg002_name_fix.txt \
    ${BENCHDIR}/HG002_GRCh37_1_22_v4.2.1_benchmark.vcf.gz \
    > hg002.vcf.gz
bcftools index hg002.vcf.gz

echo "INTEGRATION   HG003" > hg003_name_fix.txt
bcftools reheader \
    -s hg003_name_fix.txt \
    ${BENCHDIR}/HG003_GRCh37_1_22_v4.2.1_benchmark.vcf.gz \
    > hg003.vcf.gz
bcftools index hg003.vcf.gz

echo "INTEGRATION   HG004" > hg004_name_fix.txt
bcftools reheader \
    -s hg004_name_fix.txt \
    ${BENCHDIR}/HG004_GRCh37_1_22_v4.2.1_benchmark.vcf.gz \
    > hg004.vcf.gz
bcftools index hg004.vcf.gz

## Merging VCFs
bcftools merge -m all -O z \
    -R data/panel_design/GRCh37_aj-trio_v4.2.1_mosaic-target.bed \
    --threads 7 \
    hg00{2,3,4}.vcf.gz \
    > merged-variants.vcf.gz

tabix data/panel_design/GRCh37_aj-trio_v4.2.1_merged-variants.vcf.gz

## Cleaning up files
rm hg00{2,3,4}.vcf.gz* hg00{2,3,4}_name_fix.txt