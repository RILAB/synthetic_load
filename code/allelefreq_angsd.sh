#!/usr/bin/env bash


#run with 
#allelefreq_angsd.sh FILELIST OPTIONS OUTFILENAME


FILELIST=$1 #calls_angsd/TeoParents.filelist
OPTIONS=$2 #e.g "-indF INDFFILE -r 10: -sites SITESFILE -r 10:"
OUT=$3 #calls_angsd/test_teoF1
REFERENCE=/group/jrigrp/Share/assemblies/Zea_mays.AGPv4.dna.chr.fa

$HOME/tools/angsd/angsd \
        -bam $FILELIST \
        -ref $REFERENCE \
        -out $OUT \
        -GL 2 \
        -doPost 1 \
        -doMaf 1 \
        -doMajorMinor 4 \
        -skipTriallelic 0.05 \
        -minMapQ 40 \
		-minQ 20 \
		$OPTIONS