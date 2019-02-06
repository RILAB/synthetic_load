#!/usr/bin/env bash

#SBATCH -D /group/jrigrp9/stetter_projects/synthetic_load/
#SBATCH -o /group/jrigrp9/stetter_projects/synthetic_load/logs/angsdcall_out-%j.txt
#SBATCH -t 14-00:00
#SBATCH -J angsdcall
#SBATCH --nodes=1-1
#SBATCH --ntasks 32
#SBATCH --exclude bigmem1


# write indF files
mkdir -p calls_angsd/indF
for i in {1..11}; do echo 0.0; done > calls_angsd/indF/TeoParentIndF.txt
for i in {1..27}; do echo 1.0; done > calls_angsd/indF/NAMparentIndF.txt
while read i; do echo 1.0; done<calls_angsd/filelists/synDH.filelist >calls_angsd/indF/SynDHIndF.txt

# Combine filelists
cat calls_angsd/filelists/TeoParents.filelist calls_angsd/filelists/NAMparents.filelist calls_angsd/filelists/synDH.filelist > calls_angsd/filelists/DH_with_parents.filelist 

# get all sites that can be called in the parents

code/allelefreq_angsd.sh calls_angsd/filelists/parents.filelist "-r 10: -P 32" calls_angsd/all_variant_sites

# extract list of sites that should be called in individual populations
gunzip -c calls_angsd/all_variant_sites.mafs.gz |awk '{print $1 "\t" $2}' | sed -e '1d' > calls_angsd/sites/sites_to_call.txt
$HOME/tools/angsd/angsd sites index calls_angsd/sites/sites_to_call.txt

##########################################################################
# call genotypes in parents and filter for missing values
##########################################################################
## TEOF1
code/call_genotypes_angsd.sh calls_angsd/filelists/TeoParents.filelist "-minInd 5 -sites calls_angsd/sites/sites_to_call.txt -r 10: -P 32" calls_angsd/TeoParentSNPs

## NAM
code/call_genotypes_angsd.sh calls_angsd/filelists/NAMparents.filelist "-minInd 13 -sites calls_angsd/sites/sites_to_call.txt -r 10: -P 32" calls_angsd/NAMparentSNPs

# synDH 
code/call_genotypes_angsd.sh calls_angsd/filelists/calls_angsd/filelists/synDH.filelist "-minInd 500 -sites calls_angsd/sites/sites_to_call.txt -r 10: -P 2" calls_angsd/synDH_SNPs


# extract list of sites that should be called in individual populations
Rscript code/get_SNPlist_for_calling.R
$HOME/tools/angsd/angsd sites index calls_angsd/sites/final_sites.txt

#####################################
# Call genotypes in each population
#####################################
# TeoF1
code/call_genotypes_angsd.sh calls_angsd/filelists/TeoParents.filelist "-minInd 1 -sites calls_angsd/sites/final_sites.txt -r 10: -indF calls_angsd/indF/TeoParentIndF.txt -P 32" calls_angsd/TeoParents

## NAM
code/call_genotypes_angsd.sh calls_angsd/filelists/NAMparents.filelist "-minInd 1 -sites calls_angsd/sites/final_sites.txt -r 10: -indF calls_angsd/indF/NAMparentIndF.txt -P 32" calls_angsd/NAMparent

## SynDH
code/call_genotypes_angsd.sh calls_angsd/filelists/synDH.filelist "-minInd 1 -sites calls_angsd/sites/final_sites.txt -r 10: -indF calls_angsd/indF/SynDHIndF.txt -P 2" calls_angsd/synDH


