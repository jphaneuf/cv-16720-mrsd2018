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
#rm -rf $OUTPUTDIR

################################################################################
###Generate pdf and populate output dir#########################################
################################################################################

mkdir $OUTPUTDIR
cp -r matlab $OUTPUTDIR
cp -r ec     $OUTPUTDIR
pdflatex doc/${INPUT}.tex -o ${OUTPUT}.pdf
mv ${OUTPUT}.pdf $OUTPUTDIR
rm ${OUTPUTDIR}/matlab/houghScript*
rm ${OUTPUTDIR}/matlab/drawLine.m

################################################################################
###package######################################################################
################################################################################

zip -r ${OUTPUTDIR}.zip $OUTPUTDIR

################################################################################
###Cleanup######################################################################
################################################################################
#rm -rf $OUTPUTDIR
#rm doc/*.aux
#rm doc/*.log
#rm *.aux
#rm *.log

evince $OUTPUTDIR/${OUTPUT}.pdf
