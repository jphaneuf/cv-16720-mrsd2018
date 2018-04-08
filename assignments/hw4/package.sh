#!/bin/sh

################################################################################
###Define file and directory names##############################################
################################################################################

OUTPUT=jphaneuf
INPUT=$OUTPUT
OUTPUTDIR=$OUTPUT


################################################################################
###Remove outputs if already in existence#######################################
################################################################################

rm ${OUTPUTDIR}.zip
rm -rf $OUTPUTDIR

################################################################################
###Generate pdf and populate output dir#########################################
################################################################################

mkdir $OUTPUTDIR
cp -r python $OUTPUTDIR
cp -r ec     $OUTPUTDIR
pdflatex ${INPUT}.tex -o ${OUTPUT}.pdf
#mv ${OUTPUT}.pdf $OUTPUTDIR


rm ${OUTPUTDIR}/python/requirements.txt
rm ${OUTPUTDIR}/python/rotdata.csv
rm ${OUTPUTDIR}/python/testPattern.mat
rm ${OUTPUTDIR}/python/util.py
rm ${OUTPUTDIR}/python/*pyc

################################################################################
###package######################################################################
################################################################################

zip -r ${OUTPUTDIR}.zip $OUTPUTDIR

evince  ${OUTPUT}.pdf
################################################################################
###Cleanup######################################################################
################################################################################
#rm -rf $OUTPUTDIR
#rm doc/*.aux
#rm doc/*.log
#rm *.aux
#rm *.log

#Expected Matlab files:

