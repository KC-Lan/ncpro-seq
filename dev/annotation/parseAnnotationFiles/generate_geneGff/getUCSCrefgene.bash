#!/bin/bash

########################
##
## 1- Download refgene file from UCSC
## 2- Create a gff file
#######################

## TO EDIT
DOWNLOAD=1
FORMAT=1
CLEAN=1

ORGANISM="hg38"



if [ $DOWNLOAD -eq 1 ]; then
    if [ -d "./download/" ]; then
	rm ./download/*
    else
	mkdir download
    fi
    echo 'wget -P download/ http://hgdownload.cse.ucsc.edu/goldenPath/'$ORGANISM'/database/refGene.txt.gz' | sh
    gunzip download/*.gz
fi


if [ $FORMAT -eq 1 ]; then
    awk -v org=$ORGANISM 'BEGIN{OFS="\t"}{if($0!~/#/){exon_n=$9; split($10,lcord,","); split($11,rcord,","); for (x=1;x<=exon_n;x++){ exon_idx=x; if($4=="-"){exon_idx=exon_n-exon_idx+1} print $3,org"_refgene","exon",lcord[x]+1,rcord[x],".",$4,".","TranscriptID="$2";GeneName="$13";ExonIdx="exon_idx}}}' download/refGene.txt | grep -v 'random' |  grep -v 'chrUn' | grep -v 'hap' |sortBed -i stdin > coding_gene.gff
fi

if [ $CLEAN -eq 1 ]; then
    rm -fr ./download/*
fi
