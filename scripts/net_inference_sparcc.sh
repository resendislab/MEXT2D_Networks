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

# Argument 1 is the path to the input file
# Argument 2 is the path to the output folder
# Argument 3 is SparCC root folder
# Argument 4 is the name of the input file
# Argument 5 is the number of iterations associated with SparCC.py
# Argument 6 is the number of iterations associated with MakeBootstraps.py

SparCC_inference () {
    
    mkdir $2/Resamplings
    mkdir $2/Bootstraps
    
    cd $3
    python $3/SparCC.py $1/$4 -i $5 --cor_file=$2/$4_sparcc.txt > $2/sparcc.log

    BOOT_PATH=$2/Resamplings
    cd $BOOT_PATH

    cp -v $1/$4 .

    python $3/MakeBootstraps.py $4 -n $6 --path=$2/Resamplings/boot

    cd $2

    # compute sparcc on resampled (with replacement) datasets

    for i in {1..$6}
    do
        python $3/SparCC.py $2/Resamplings/boot$4.permuted_$i.txt -i $5 --cor_file=$2/Bootstraps/sim_cor_$i.txt >> $2/sparcc.log
    done

    # compute p-value from bootstraps

    python $3/PseudoPvals.py $2/$4_sparcc.txt $2/Bootstraps/sim_cor_"#".txt $5 -o $2/pvals_one_sided.txt -t 'one_sided'  >> $2/sparcc.log

}