#!/bin/sh
INPUT=jphaneuf
DIR=doc
pandoc ${DIR}/${INPUT}.md -o ${INPUT}.pdf
evince ${INPUT}.pdf
rm ${INPUT}.pdf
