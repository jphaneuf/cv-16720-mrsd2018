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
cp -r matlab $OUTPUTDIR
cp -r ec     $OUTPUTDIR
pdflatex ${INPUT}.tex -o ${OUTPUT}.pdf
mv ${OUTPUT}.pdf $OUTPUTDIR


rm ${OUTPUTDIR}/e2e.m
rm ${OUTPUTDIR}/*mat
rm ${OUTPUTDIR}/plotgen.m

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

#Backward.m (10 points)
#- Classify.m (2 points)
#- ComputeAccuracyAndLoss.m (3 points)
#- extractImageText.m (10 points)
#- findLetters.m (10 points)
#- finetune36.m (2 points)
#- Forward.m (5 points)
#- InitializeNetwork.m (5 points)
#- Train.m (5 points)
#- testFindLetters.m (5 points)
#- testExtractImageText.m (5 points)
#- train26.m (5 points)
#- UpdateParameters.m (5 points)
#- define autoencoder.m (2 points)
#- train autoencoder.m (4 points)
#- eval autoencoder.m (4 points)
#- Any other code or helper functions you used
