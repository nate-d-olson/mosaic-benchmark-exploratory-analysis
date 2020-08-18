library(ggplot2)
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

#son-specific SNPs matching a v4.1 SNP
tp<-read.table(text = gsub("[:,]", "\t", readLines("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/tp_snp_ref_alt_support_noquotes.vcf")),header=FALSE,comment.char = "#",sep="\t")
tp$illref<-0
for(i in 1:nrow(tp)){
    tp[i,"illref"]<-tp[i,ifelse(tp[i,4]=="A",22,ifelse(tp[i,4]=="C",24,ifelse(tp[i,4]=="G",26,28)))]
}
tp$illalt<-0
for(i in 1:nrow(tp)){
    tp[i,"illalt"]<-tp[i,ifelse(tp[i,5]=="A",22,ifelse(tp[i,5]=="C",24,ifelse(tp[i,5]=="G",26,28)))]
}
tp$ccsalt<-tp$V32+tp$V34+tp$V36+tp$V38
tp$ccsref<-tp$V31+tp$V33+tp$V35+tp$V37-tp$ccsalt
tp$ccssupp<-(tp$ccsalt>0)
plot(tp$illref,tp$illalt)
plot(tp$ccsref,tp$ccsalt)

tpHG3<-read.table("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/tp_snp_HG003_CCS_15_20kb_merged_SequelII_ref_alt_support_noquotes.vcf",header=FALSE,comment.char = "#",sep="\t")
tpHG3$ccsaltHG3<-tpHG3$V12
tpHG3$ccsrefHG3<-tpHG3$V11-tpHG3$ccsaltHG3
plot(tpHG3$ccsrefHG3,tpHG3$ccsaltHG3)

tpHG4<-read.table("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/tp_snp_HG004_CCS_15_20kb_merged_SequelII_ref_alt_support_noquotes.vcf",header=FALSE,comment.char = "#",sep="\t")
tpHG4$ccsaltHG4<-tpHG4$V12
tpHG4$ccsrefHG4<-tpHG4$V11-tpHG4$ccsaltHG4
plot(tpHG4$ccsrefHG4,tpHG4$ccsaltHG4)

hist(tp$illalt/(tp$illref+tp$illalt),bin=0.02)
ggplot(tp, aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005) 
ggplot(tp, aes(x=ccsalt/(ccsalt+ccsref))) +  geom_histogram(binwidth=0.005) 
ggplot(tp, aes(x=illref,y=illalt)) +  geom_point(aes(colour = factor(ccssupp))) 
ggplot(tp, aes(x=ccsalt/(ccsalt+ccsref),y=illalt/(illalt+illref))) +  geom_point() 
ggplot(tp, aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(ccssupp))) 
tp$type="TP"

#son-specific SNPs not matching a v4.1 SNP
fp<-read.table(text = gsub("[:,]", "\t", readLines("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/fp_snp_ref_alt_support_noquotes.vcf")),header=FALSE,comment.char = "#",sep="\t")
fp$illref<-0
for(i in 1:nrow(fp)){
  fp[i,"illref"]<-fp[i,ifelse(fp[i,4]=="A",22,ifelse(fp[i,4]=="C",24,ifelse(fp[i,4]=="G",26,28)))]
}
fp$illalt<-0
for(i in 1:nrow(fp)){
  fp[i,"illalt"]<-fp[i,ifelse(fp[i,5]=="A",22,ifelse(fp[i,5]=="C",24,ifelse(fp[i,5]=="G",26,28)))]
}
fp$ccsalt<-fp$V32+fp$V34+fp$V36+fp$V38
fp$ccsref<-fp$V31+fp$V33+fp$V35+fp$V37-fp$ccsalt
fp$ccssupp<-(fp$ccsalt>0)
plot(fp$illref,fp$illalt)
plot(fp$ccsref,fp$ccsalt)

fpHG3<-read.table("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/fp_snp_HG003_CCS_15_20kb_merged_SequelII_ref_alt_support_noquotes.vcf",header=FALSE,comment.char = "#",sep="\t")
fpHG3$ccsaltHG3<-fpHG3$V12
fpHG3$ccsrefHG3<-fpHG3$V11-fpHG3$ccsaltHG3
plot(fpHG3$ccsrefHG3,fpHG3$ccsaltHG3)

fpHG4<-read.table("data/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/fp_snp_HG004_CCS_15_20kb_merged_SequelII_ref_alt_support_noquotes.vcf",header=FALSE,comment.char = "#",sep="\t")
fpHG4$ccsaltHG4<-fpHG4$V12
fpHG4$ccsrefHG4<-fpHG4$V11-fpHG4$ccsaltHG4
plot(fpHG4$ccsrefHG4,fpHG4$ccsaltHG4)

fpHG234<-merge(merge(fp,fpHG3[,c(1,2,13,14)]),fpHG4[,c(1,2,13,14)])
hist(fp$illalt/(fp$illref+fp$illalt),bin=0.02)
ggplot(fp, aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005) 
ggplot(fp, aes(x=ccsalt/(ccsalt+ccsref))) +  geom_histogram(binwidth=0.005) 
ggplot(fp, aes(x=ccsalt/(ccsalt+ccsref),y=illalt/(illalt+illref))) +  geom_point() 
ggplot(fp, aes(x=illref,y=illalt)) +  geom_point(aes(colour = factor(ccssupp))) 
ggplot(fp, aes(x=ccsalt/(ccsalt+ccsref),y=illalt/(illalt+illref))) +  geom_point() +xlim(0,0.1) +ylim(0,0.1)
ggplot(fp, aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(ccssupp))) 
fp$type="FP"

ggplot(rbind(fp,tp), aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(type)))
ggplot(rbind(fp,tp), aes(x=ccsalt/(ccsalt+ccsref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(type)))

#son-specific variants not in v4.1 bed or in complex variants (excluded from fps and tps)
notin41<-read.table(text = gsub("[:,]", "\t", readLines("data/strelka2_wgs_parents-vs-child/HG002_hs37d5_300X_wg_snp_PASS_notinv4.1bed_ref_alt_support_noquotes.vcf")),header=FALSE,comment.char = "#",sep="\t")
notin41$illref<-0
for(i in 1:nrow(notin41)){
    notin41[i,"illref"]<-notin41[i,ifelse(notin41[i,4]=="A",22,ifelse(notin41[i,4]=="C",24,ifelse(notin41[i,4]=="G",26,28)))]
}
notin41$illalt<-0
for(i in 1:nrow(notin41)){
    notin41[i,"illalt"]<-notin41[i,ifelse(notin41[i,5]=="A",22,ifelse(notin41[i,5]=="C",24,ifelse(notin41[i,5]=="G",26,28)))]
}
notin41$ccsalt<-notin41$V32+notin41$V34+notin41$V36+notin41$V38
notin41$ccsref<-notin41$V31+notin41$V33+notin41$V35+notin41$V37-notin41$ccsalt
notin41$ccssupp<-(notin41$ccsalt>0)
plot(notin41$illref,notin41$illalt)
plot(notin41$ccsref,notin41$ccsalt)

notin41HG3<-read.table("data/strelka2_wgs_parents-vs-child/HG002_hs37d5_300X_wg_snp_PASS_notinv4.1bed_HG003_CCS_15_20kb_merged_SequelII_ref_alt_support_noquotes.vcf",header=FALSE,comment.char = "#",sep="\t")
notin41HG3$ccsaltHG3<-notin41HG3$V12
notin41HG3$ccsrefHG3<-notin41HG3$V11-notin41HG3$ccsaltHG3
plot(notin41HG3$ccsrefHG3,notin41HG3$ccsaltHG3)

notin41HG4<-read.table("data/strelka2_wgs_parents-vs-child/HG002_hs37d5_300X_wg_snp_PASS_notinv4.1bed_HG004_CCS_15_20kb_merged_SequelII_ref_alt_support_noquotes.vcf",header=FALSE,comment.char = "#",sep="\t")
notin41HG4$ccsaltHG4<-notin41HG4$V12
notin41HG4$ccsrefHG4<-notin41HG4$V11-notin41HG4$ccsaltHG4
plot(notin41HG4$ccsrefHG4,notin41HG4$ccsaltHG4)

hist(notin41$illalt/(notin41$illref+notin41$illalt),bin=0.02)
ggplot(notin41, aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005) 
ggplot(notin41, aes(x=ccsalt/(ccsalt+ccsref))) +  geom_histogram(binwidth=0.005) 
ggplot(notin41, aes(x=ccsalt/(ccsalt+ccsref),y=illalt/(illalt+illref))) +  geom_point(size=1,alpha=0.3) 
ggplot(notin41, aes(x=illref,y=illalt)) +  geom_point(size=1,aes(colour = factor(ccssupp))) 
ggplot(notin41, aes(x=ccsalt/(ccsalt+ccsref),y=illalt/(illalt+illref))) +  geom_point(size=1,alpha=0.3) +xlim(0,0.1) +ylim(0,0.1)
ggplot(notin41, aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(ccssupp))) 

notin41$type="NotInv4.1"

allmosaic<-rbind(rbind(notin41,tp),fp)
ggplot(allmosaic[allmosaic$illalt+allmosaic$illref>200 & allmosaic$illalt+allmosaic$illref<400,], aes(x=illalt/(illalt+illref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+ylim(0,700)+ facet_grid(  ccssupp ~ . )
ggplot(allmosaic[allmosaic$illalt+allmosaic$illref>200 & allmosaic$illalt+allmosaic$illref<400,], aes(x=ccsalt/(ccsalt+ccsref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+ylim(0,700)

ggplot(allmosaic[allmosaic$illalt+allmosaic$illref>200 & allmosaic$illalt+allmosaic$illref<400,], aes(x=illalt)) +  geom_histogram(binwidth=1,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+xlim(0,200)+ facet_grid(  ccssupp ~ . )

niaid<-read.table("data/NIAID_A2_commonsites.txt",header=FALSE,sep="\t")

niaidmerge<-merge(allmosaic,niaid,by.x="V2",by.y="V3")

niaidallbed<-read.table("data/A2_NIAID_all_calls.bed",header=FALSE,sep="\t")

niaidallmerge<-merge(allmosaic,niaidallbed,by.x="V2",by.y="V3")
ggplot(niaidallmerge[niaidallmerge$illalt+niaidallmerge$illref>200 & niaidallmerge$illalt+niaidallmerge$illref<400,], aes(x=illalt)) +  geom_histogram(binwidth=1,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+xlim(0,200)+ facet_grid(  ccssupp ~ . )
ggplot(niaidallmerge, aes(x=illalt)) +  geom_histogram(binwidth=1,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+xlim(0,200)+ facet_grid(  ccssupp ~ . )
ggplot(niaidallmerge, aes(x=illalt,y=ccsalt)) +  geom_point(aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+xlim(0,200)
ggplot(niaidallmerge, aes(x=ccsalt/(ccsalt+ccsref),y=illalt/(illalt+illref))) +  geom_point(aes(colour = factor(type)))+scale_color_manual(values=cbbPalette) 



## Code from mosaic_AF.R script under vcfeval comparison
library(ggplot2)
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

#son-specific SNPs matching a v4.1 SNP
tp<-read.table(text = gsub("[:,]", "\t", readLines("~/Desktop/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/tp_snp.vcf")),header=FALSE,comment.char = "#",sep="\t")
tp$ref<-0
for(i in 1:nrow(tp)){
  tp[i,"ref"]<-tp[i,ifelse(tp[i,4]=="A",22,ifelse(tp[i,4]=="C",24,ifelse(tp[i,4]=="G",26,28)))]
}
tp$alt<-0
for(i in 1:nrow(tp)){
  tp[i,"alt"]<-tp[i,ifelse(tp[i,5]=="A",22,ifelse(tp[i,5]=="C",24,ifelse(tp[i,5]=="G",26,28)))]
}
plot(tp$ref,tp$alt)
ggplot(tp, aes(x=alt/(alt+ref))) +  geom_histogram(binwidth=0.005) 
tp$type="TP"

#son-specific SNPs not matching a v4.1 SNP
fp<-read.table(text = gsub("[:,]", "\t", readLines("~/Desktop/strelka2_wgs_parents-vs-child/vcfeval_comparison/HG002_GRCh37_1_22_truth_v4.1_query_strelka_wg_SNPs/fp_snp.vcf")),header=FALSE,comment.char = "#",sep="\t")
fp$ref<-0
for(i in 1:nrow(fp)){
  fp[i,"ref"]<-fp[i,ifelse(fp[i,4]=="A",22,ifelse(fp[i,4]=="C",24,ifelse(fp[i,4]=="G",26,28)))]
}
fp$alt<-0
for(i in 1:nrow(fp)){
  fp[i,"alt"]<-fp[i,ifelse(fp[i,5]=="A",22,ifelse(fp[i,5]=="C",24,ifelse(fp[i,5]=="G",26,28)))]
}
plot(fp$ref,fp$alt)
hist(fp$alt/(fp$ref+fp$alt),bin=0.02)
ggplot(fp, aes(x=alt/(alt+ref))) +  geom_histogram(binwidth=0.005) 
fp$type="FP"

ggplot(rbind(fp,tp), aes(x=alt/(alt+ref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(type)))
ggplot(rbind(fp,tp), aes(x=alt/(alt+ref))) +  geom_histogram(binwidth=0.0025,aes(colour = factor(type)))+ylim(0,200)+xlim(0,0.1)

#son-specific variants not in v4.1 bed or in complex variants (excluded from fps and tps)
all<-read.table(text = gsub("[:,]", "\t", readLines("~/Desktop/strelka2_wgs_parents-vs-child/HG002_hs37d5_300X_wg_snp_PASS_notinv4.1bed.vcf")),header=FALSE,comment.char = "#",sep="\t")
all$ref<-0
for(i in 1:nrow(all)){
  all[i,"ref"]<-all[i,ifelse(all[i,4]=="A",22,ifelse(all[i,4]=="C",24,ifelse(all[i,4]=="G",26,28)))]
}
all$alt<-0
for(i in 1:nrow(all)){
  all[i,"alt"]<-all[i,ifelse(all[i,5]=="A",22,ifelse(all[i,5]=="C",24,ifelse(all[i,5]=="G",26,28)))]
}
plot(all$ref,all$alt, xlim=c(0,400), ylim=c(0,400))
hist(all$alt/(all$ref+all$alt),bin=0.02)
ggplot(all, aes(x=alt/(alt+ref))) +  geom_histogram(binwidth=0.005) 
all$type="NotInv4.1"

allmosaic<-rbind(rbind(all,tp),fp)
ggplot(allmosaic[allmosaic$alt+allmosaic$ref>200 & allmosaic$alt+allmosaic$ref<400,], aes(x=alt/(alt+ref))) +  geom_histogram(binwidth=0.0025,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+ylim(0,300)+xlim(0,0.1)
ggplot(allmosaic[allmosaic$alt+allmosaic$ref>200 & allmosaic$alt+allmosaic$ref<400,], aes(x=alt/(alt+ref))) +  geom_histogram(binwidth=0.005,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+ylim(0,700)+xlim(0,1)

ggplot(allmosaic[allmosaic$alt+allmosaic$ref>200 & allmosaic$alt+allmosaic$ref<400,], aes(x=alt)) +  geom_histogram(binwidth=1,aes(colour = factor(type)))+scale_color_manual(values=cbbPalette)+xlim(0,200)

library(tidyverse)

allmosaic %>% 
  filter(alt/(ref+ alt) > 0.05, type == "NotInv4.1")