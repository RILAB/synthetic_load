library(data.table)
library(dplyr)
library(readr)


# This script takes SNPs called in individually filtered datasets and outputs the full list
# across all of them


teoparents<- fread("gunzip -c calls_angsd/TeoParentSNPs.mafs.gz",data.table=F) %>% 
  select(chromo,position)
print('Teosinte SNPs')
print(nrow(teoparents))
namparents<- fread("gunzip -c calls_angsd/NAMparentSNPs.mafs.gz",data.table=F) %>% 
  select(chromo,position)
print('NAM SNPs')
print(nrow(namparents))

dh <- fread("gunzip -c calls_angsd/synDH_SNPs.mafs.gz",data.table=F) %>% 
  select(chromo,position)
print('DH SNPs')
print(nrow(dh))

combined <- teoparents %>% full_join(namparents,by=c('chromo'='chromo','position'='position'))
combined <- combined %>% full_join(dh,by=c('chromo'='chromo','position'='position'))
print('Combined SNPs')
print(nrow(combined))

write_tsv(combined,'calls_angsd/sites/final_sites.txt',col_names=F)
