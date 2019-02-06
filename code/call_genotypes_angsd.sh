#!/usr/bin/env bash

FILELIST=$1 #calls_angsd/TeoParents.filelist
OPTIONS=$2 #e.g "-indF INDFFILE -r 10: -sites SITESFILE"
OUT=$3 #calls_angsd/test_teoF1
REFERENCE=/group/jrigrp/Share/assemblies/Zea_mays.AGPv4.dna.chr.fa



$HOME/tools/angsd/angsd \
        -bam $FILELIST \
        -ref $REFERENCE \
        -out $OUT \
        -postCutoff 0.95 \
        -doMaf 1 \
        -GL 2 \
        -doGlf 2 \
        -doGeno 5 \
        -doPost 1 \
        -doMajorMinor 4 \
        -skipTriallelic 0.05 \
        $OPTIONS