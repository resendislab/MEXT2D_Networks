#!/bin/bash

#########################
#
# Simple SparCC wrapper
#
# Use:
# chmod 755 sparccWrapper.sh
# ./sparccWrapper.sh &
#
# Author: Karoline Faust
# Mod: Diego Esquivel
#
#########################

# here goes the path to the input file
INPUT_PATH="/home/dagivi/articulo_diego"
# here goes the path to the output folder
OUTPUT_PATH="/home/dagivi/articulo_diego/resultados/T2D"
# here goes the sparcc root folder
SPARCC_PATH="/home/dagivi/.conda/envs/articulo/bin"
ITER=10
BOOT_ITER=100
WORKDIR=$PWD

mkdir $OUTPUT_PATH/Resamplings
mkdir $OUTPUT_PATH/Bootstraps

# run SparCC to infer correlation networks
cd $SPARCC_PATH
python $SPARCC_PATH/SparCC.py $INPUT_PATH/tabla_genera_T2D.txt -i $ITER --cor_file=$OUTPUT_PATH/tabla_genera_sparcc_T2D.txt > $OUTPUT_PATH/sparcc_T2D.log

# here goes the bootstraps folder
BOOT_PATH=$OUTPUT_PATH/Resamplings
echo "$BOOT_PATH"

cd $BOOT_PATH
echo "verify cd"
change=$(pwd)
echo "$change"

echo "$INPUT_PATH"
cp -v $INPUT_PATH/tabla_genera_T2D.txt .

echo "now let's make a ls to verify that the files were created"
list=$(ls)
echo "$list"

python $SPARCC_PATH/MakeBootstraps.py tabla_genera_T2D.txt -n $BOOT_ITER --path=$OUTPUT_PATH/Resamplings/boot

#Returns previous directory


$OUTPUT_PATH

#compute sparcc on resampled (with replacement) datasets
for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99
do
    python $SPARCC_PATH/SparCC.py $OUTPUT_PATH/Resamplings/boottabla_genera_T2D.txt.permuted_$i.txt -i $ITER --cor_file=$OUTPUT_PATH/Bootstraps/sim_cor_$i.txt >> $OUTPUT_PATH/sparcc_T2D.log
done

# compute p-value from bootstraps
python $SPARCC_PATH/PseudoPvals.py $OUTPUT_PATH/tabla_genera_sparcc_T2D.txt $OUTPUT_PATH/Bootstraps/sim_cor_"#".txt $ITER -o $OUTPUT_PATH/pvals_one_sided_T2D.txt -t 'one_sided'  >> $OUTPUT_PATH/sparcc_T2D.log

# visualization requires parsing and thresholding the p-value OTU matrix
