#!/usr/bin/env bash

#SBATCH -D /group/jrigrp9/stetter_projects/synthetic_load/
#SBATCH -o /group/jrigrp9/stetter_projects/synthetic_load/logs/angsdcall_out-%j.txt
#SBATCH -t 14-00:00
#SBATCH -J angsdcall
#SBATCH --nodes=1-1
#SBATCH --ntasks 32
#SBATCH --exclude bigmem1


#code/allelefreq_angsd.sh calls_angsd/filelists/parents.filelist "-r 10: -P 32" calls_angsd/all_variant_sites

# extract list of sites that should be called in individual populations

#gunzip -c calls_angsd/all_variant_sites.mafs.gz |awk '{print $1 "\t" $2}' | sed -e '1d' > calls_angsd/sites_to_call.txt
#$HOME/tools/angsd/angsd sites index calls_angsd/sites_to_call.txt

mkdir -p calls_angsd/mafs/
$HOME/tools/angsd/angsd sites index calls_angsd/sites/gerpV4_sites.txt

code/allelefreq_angsd.sh calls_angsd/filelists/TeoParents.filelist "-P 32 -sites calls_angsd/sites/gerpV4_sites.txt -indF calls_angsd/indF/TeoParentIndF.txt" calls_angsd/mafs/TeoF1

code/allelefreq_angsd.sh calls_angsd/filelists/NAMparents.filelist "-P 32 -sites calls_angsd/sites/gerpV4_sites.txt -indF calls_angsd/indF/NAMparentIndF.txt" calls_angsd/mafs/nam

code/allelefreq_angsd.sh calls_angsd/filelists/syn0.filelist "-P 32 -sites calls_angsd/sites/gerpV4_sites.txt" calls_angsd/mafs/syn0

code/allelefreq_angsd.sh calls_angsd/filelists/syn4.filelist "-P 32 -sites calls_angsd/sites/gerpV4_sites.txt" calls_angsd/mafs/syn4

code/allelefreq_angsd.sh calls_angsd/filelists/syn6.filelist "-P 5 -sites calls_angsd/sites/gerpV4_sites.txt" calls_angsd/mafs/syn6

code/allelefreq_angsd.sh calls_angsd/filelists/synDH.filelist "-P 5 -sites calls_angsd/sites/gerpV4_sites.txt -indF calls_angsd/indF/SynDHIndF.txt" calls_angsd/mafs/synDH
