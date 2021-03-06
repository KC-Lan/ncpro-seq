#!/bin/bash

########################
##
## 1- Download rmsk file from UCSC
## 2- Create a gff file
#######################

## TO EDIT
DOWNLOAD=1
FORMAT=1
CLEAN=1

ORGANISM="hg38"


RMSK_FILE=$ORGANISM"_rmsk"


if [ $DOWNLOAD -eq 1 ]; then
## For Mouse - have to download all individual files
    if [ $ORGANISM != "hg38" ]; then
	
	if [ -d "./download/" ]; then
	    rm ./download/*
	else
	    mkdir download
	fi
	
#	for i in $CHR
#	do
	echo 'wget -r --no-parent -w 5 --timestamping -A "*_rmsk.txt.gz" -P download/ ftp://hgdownload.cse.ucsc.edu/goldenPath/'$ORGANISM'/database/' | sh
#	done
	
	if [ -f $RMSK_FILE ]; then
	    rm $RMSK_FILE
	fi
	
#	echo "#bin\tswScore\tmilliDiv\tmilliDel\tmilliIns\tgenoName\tgenoStart\tgenoEnd\tgenoLeft\tstrand\trepName\trepClass\trepFamily\trepStart\trepEnd\trepLeft\tid" > $RMSK_FILE
	
	gunzip download/hgdownload.cse.ucsc.edu/goldenPath/$ORGANISM/database/*.gz
#	for i in $CHR
#	do
	cat $(ls download/hgdownload.cse.ucsc.edu/goldenPath/$ORGANISM/database/*_rmsk.txt | grep -v "random") >> $RMSK_FILE
#	done
    fi

    if [ $ORGANISM == "hg38" ]; then
	echo 'wget -P download/ http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/rmsk.txt.gz' | sh
	gunzip download/*.gz
	grep -v "random" download/rmsk.txt > $RMSK_FILE
    fi
fi


if [ $FORMAT -eq 1 ]; then
#    awk -F"\t" -v org=$ORGANISM 'BEGIN{OFS="\t"}(NR>1){print $6,"rmsk"org,$12,$7+1,$8,".",$10,".","repName=\""$11"\";repClass=\""$12"\";repFamily=\""$13"\";"}' $RMSK_FILE > $RMSK_FILE.gff3
    awk -F"\t" -v org=$ORGANISM 'BEGIN{OFS="\t"}{if(($10=="-") || ($10=="C")){gsub(/\(|\)|-/,"",$14);full_len=$14+$15;print $6,"rmsk"org,$12,$7+1,$8,".",$10,".","repName="$11";repClass="$12";repFamily="$13";repSt="$16";repEnd="$15";repFullLen="full_len";"} else{gsub(/\(|\)|-/,"",$16);full_len=$16+$15;print $6,"rmsk"org,$12,$7+1,$8,".",$10,".","repName="$11";repClass="$12";repFamily="$13";repSt="$14";repEnd="$15";repFullLen="full_len";"}}' $RMSK_FILE > rmsk.gff
    gzip $RMSK_FILE
fi


if [ $CLEAN -eq 1 ]; then
    rm -fr ./download/*
fi
