#!/bin/zsh
## Running script to generate complex variant beds for AJ Trio

# making directory for log file
mkdir -p logs/complex_var_beds

for GIABID in HG002 HG003 HG004; do
    echo "Processing ${GIABID}"
    scripts/make_aj_trio_complex_beds.zsh ${GIABID} \
        1> logs/complex_var_beds/${GIABID}.log 2>logs/complex_var_beds/${GIABID}.err
done