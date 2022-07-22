
We denoised microbiota data with [mb-PHENIX]  (https://doi.org/10.1101/2022.06.23.497285) 
## Installation

We used google colab with python 3 at Friday, 22 March 2022,
In the colab notebook there is code, we selected knn= 17 in order to avoid over-smoothing of data.

Then we colapsed imputed asv data for taxa information. Then to observe shits among taxa with the colapsed and imputed data 
,we apply EMD(Earth mover's Distances) metric by clusters(cluster status vs the rest of samples).


