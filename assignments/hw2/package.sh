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

RGB2Lab.m
batchToVisualWords.m
buildRecognitionSystem.m
createFilterBank.m
dictionaryHarris.mat
dictionaryRandom.mat
evaluateRecognitionSystem.m
extractFilterResponses.m
getDictionary.m
getHarrisPoints.m
getImageDistance.m
getImageFeatures.m
getRandomPoints.m
getVisualWords.m
visionHarris.mat
visionRandom.mat
computeDictionary.m

confusion_matrix_harris_chi2.mat
confusion_matrix_harris_euclidean.mat
confusion_matrix_random_chi2.mat
confusion_matrix_random_euclidean.mat
dictionary.mat.attempt1
e2e.m
filter_viz.m
nms.m
pdist2_custom.m
