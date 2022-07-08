library(tidyverse)
library(here)
## Initial AF evaluation by JZ - wiht modifications by NDO

cbbPalette <-
    c(
        "#000000",
        "#E69F00",
        "#56B4E9",
        "#009E73",
        "#F0E442",
        "#0072B2",
        "#D55E00",
        "#CC79A7"
    )

#son-specific SNPs matching a v4.1 SNP
tp <-
    read.table(
        text = gsub(
            "[:,]",
            "\t",
            readLines(
                here("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/tp_snp.vcf")
            )
        ),
        header = FALSE,
        comment.char = "#",
        sep = "\t"
    )
tp$ref <- 0
for (i in 1:nrow(tp)) {
    tp[i, "ref"] <-
        tp[i, ifelse(tp[i, 4] == "A", 22, ifelse(tp[i, 4] == "C", 24, ifelse(tp[i, 4] == "G", 26, 28)))]
}

tp$alt <- 0
for (i in 1:nrow(tp)) {
    tp[i, "alt"] <-
        tp[i, ifelse(tp[i, 5] == "A", 22, ifelse(tp[i, 5] == "C", 24, ifelse(tp[i, 5] ==
                                                                                 "G", 26, 28)))]
}

plot(tp$ref, tp$alt)
ggplot(tp, aes(x = alt / (alt + ref))) +  geom_histogram(binwidth = 0.005)
tp$type = "TP"

#son-specific SNPs not matching a v4.1 SNP
fp <-
    read.table(
        text = gsub(
            "[:,]",
            "\t",
            readLines(
                here("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/fp_snp.vcf")
            )
        ),
        header = FALSE,
        comment.char = "#",
        sep = "\t"
    )

fp$ref <- 0
for (i in 1:nrow(fp)) {
    fp[i, "ref"] <-
        fp[i, ifelse(fp[i, 4] == "A", 22, ifelse(fp[i, 4] == "C", 24, ifelse(fp[i, 4] ==
                                                                                 "G", 26, 28)))]
}
fp$alt <- 0
for (i in 1:nrow(fp)) {
    fp[i, "alt"] <-
        fp[i, ifelse(fp[i, 5] == "A", 22, ifelse(fp[i, 5] == "C", 24, ifelse(fp[i, 5] ==
                                                                                 "G", 26, 28)))]
}
plot(fp$ref, fp$alt)
hist(fp$alt / (fp$ref + fp$alt), bin = 0.02)
ggplot(fp, aes(x = alt / (alt + ref))) +  geom_histogram(binwidth = 0.005)
fp$type = "FP"

ggplot(rbind(fp, tp), aes(x = alt / (alt + ref))) +  geom_histogram(binwidth =
                                                                        0.005, aes(colour = factor(type)))
ggplot(rbind(fp, tp), aes(x = alt / (alt + ref))) +  geom_histogram(binwidth =
                                                                        0.0025, aes(colour = factor(type))) + ylim(0, 200) + xlim(0, 0.1)

#son-specific variants not in v4.1 bed or in complex variants (excluded from fps and tps)
all <-
    read.table(
        text = gsub(
            "[:,]",
            "\t",
            readLines(here("data/strelka2_wgs_parents-vs-child/HG002_hs37d5_300X_wg_snp_PASS_notinv4.1bed.vcf"))
        ),
        header = FALSE,
        comment.char = "#",
        sep = "\t"
    )
all$ref <- 0
for (i in 1:nrow(all)) {
    all[i, "ref"] <-
        all[i, ifelse(all[i, 4] == "A", 22, ifelse(all[i, 4] == "C", 24, ifelse(all[i, 4] ==
                                                                                    "G", 26, 28)))]
}
all$alt <- 0
for (i in 1:nrow(all)) {
    all[i, "alt"] <-
        all[i, ifelse(all[i, 5] == "A", 22, ifelse(all[i, 5] == "C", 24, ifelse(all[i, 5] ==
                                                                                    "G", 26, 28)))]
}
plot(all$ref,
     all$alt,
     xlim = c(0, 400),
     ylim = c(0, 400))
hist(all$alt / (all$ref + all$alt), bin = 0.02)
ggplot(all, aes(x = alt / (alt + ref))) +  geom_histogram(binwidth = 0.005)
all$type = "NotInv4.1"

allmosaic <- rbind(rbind(all, tp), fp)
ggplot(allmosaic[allmosaic$alt + allmosaic$ref > 200 &
                     allmosaic$alt + allmosaic$ref < 400, ], aes(x = alt / (alt + ref))) +  geom_histogram(binwidth =
                                                                                                               0.0025, aes(colour = factor(type))) + scale_color_manual(values = cbbPalette) +
    ylim(0, 300) + xlim(0, 0.1)
ggplot(allmosaic[allmosaic$alt + allmosaic$ref > 200 &
                     allmosaic$alt + allmosaic$ref < 400, ], aes(x = alt / (alt + ref))) +  geom_histogram(binwidth =
                                                                                                               0.005, aes(colour = factor(type))) + scale_color_manual(values = cbbPalette) +
    ylim(0, 700) + xlim(0, 1)

ggplot(allmosaic[allmosaic$alt + allmosaic$ref > 200 &
                     allmosaic$alt + allmosaic$ref < 400, ], aes(x = alt)) +  geom_histogram(binwidth =
                                                                                                 1, aes(colour = factor(type))) + scale_color_manual(values = cbbPalette) +
    xlim(0, 200)

library(tidyverse)

allmosaic %>%
    filter(alt / (ref + alt) > 0.05, type == "NotInv4.1")
