#!/bin/sh
OUTPUT=jphaneuf
INPUT=$OUTPUT
OUTPUTDIR=$OUTPUT
rm -rf $OUTPUTDIR
mkdir $OUTPUTDIR
cp -r matlab $OUTPUTDIR
#pandoc doc/${INPUT}.md -o $OUTPUTDIR/${OUTPUT}.pdf
pdflatex doc/${INPUT}.tex -o $OUTPUTDIR/${OUTPUT}.pdf
zip -r ${OUTPUTDIR}.zip $OUTPUTDIR
rm -rf $OUTPUTDIR
