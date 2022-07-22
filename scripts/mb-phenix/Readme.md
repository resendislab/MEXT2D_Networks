
We denoised microbiota data with [mb-PHENIX](https://doi.org/10.1101/2022.06.23.497285) 
## mb-phenix implementation

We used google colab with python 3 at Friday, 22 March 2022,
In the colab notebook there is code of the denoising process(imputation), We used different knn values but we  selected knn= 17 in order to avoid over-smoothing of data and recover clusters structure as much as posible (hierarchical heatmap). This can be found in the folder [Imputation with mb-phenix(https://github.com/resendislab/MEXT2D_Networks/tree/main/scripts/mb-phenix/Imputation%20with%20mb-phenix)

Then we colapsed imputed asv data for taxa information. Then to observe shits among taxa with the colapsed and imputed data 
,we apply EMD(Earth mover's Distances) metric by clusters(cluster status vs the rest of samples). This can be found in [here(https://github.com/resendislab/MEXT2D_Networks/tree/main/scripts/mb-phenix)


