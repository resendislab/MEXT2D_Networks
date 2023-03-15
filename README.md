This repository contains all the code to implement all examples showed in our paper:

The gut microbiota and the progression of preT2D to T2D are linked to keystone taxa in Mexican cohort study: A multidimensional perspective on microbial ecology

## Data

We obtained the data from a mexican cohort of Type 2 Diabetes (T2D) patients from [Diener et al 2021](https://doi.org/10.3389/fendo.2020.602326). Abundances and taxonomy of the samples can be found [here](https://github.com/resendislab/mext2d/tree/master/data).

We organized the data in separated tables according to their T2D status, healthy, impaired fasting glycemia (IFG), impaired glucose tolerance (IGT), IFG + IGT, DT2 and Diabetes Type 2 treated (DT2_treated), you can find this files in the folder data.

## Requirements

* SparCC
* Python = 2.7
  * Numpy = 1.16.5
  * Pandas = 0.22.0
* R packages
  * tidyverse
  * visNetwork
  * EdgeR
  * Phyloseq

## Methodology

The next figure presents the methods used in our paper. Every step is detailled in the following sections

![methods_flowchart](https://user-images.githubusercontent.com/93368152/175101577-d1007864-a419-4bfe-937e-0af09b4157c0.png)

## Network inference

#### Correlations

We used SparCC to infer microbial interactions for every group of study. Run the next command in your terminal to infer the microbial network:

`bash net_inference_sparcc.sh`

#### Network preparation

Run the next script in R to get the nodes and edges of each network for every group of study:

[net_preparation.R](https://github.com/resendislab/MEXT2D_Networks/blob/main/scripts/net_preparation.R)

Note:  you will need to run an additional script in python. It is available in [notebook](https://github.com/resendislab/MEXT2D_Networks/blob/main/scripts/merge_taxa.ipynb) format. 

#### Network visualization

Run the next script in R, it will create an html file with the network visualization:

[net_visualization.R](https://github.com/resendislab/MEXT2D_Networks/blob/main/scripts/net_visualization.r)

## Network analysis

In this step we used [Netshift](https://doi.org/10.1038/s41396-018-0291-x) to evaluate the topoligical features of each network and also to compare between different clinical conditions. To do that upload the filtered tables previously obtained during the network preparation step. Netshift has an online interface, you can find it [here](https://web.rniapps.net/netshift/)

We perfomed the following comparisons between groups.

| Control | Case |
| --- | --- |
| Healthy | IFG |
| IFG | IGT |
| IGT | IFG + IGT |
| IFG + IGT | T2D |
| T2D | T2D_treated |

## Differential abundance analysis

In this step, we used [EdgeR](https://bioconductor.org/packages/release/bioc/html/edgeR.html) to infer how the abundance of gut microbiota is related to the clinical status of patients. The analysis was carried out at the genus level using the same groups described above.

## Microbial structure analysis

We used [Upset R library](https://cran.r-project.org/web/packages/UpSetR/index.html) to generate absence/presence plots from the nodes network for each clinical condition.

### Results

Please, follow the next links to visualize the results

## Krona Plots

## Networks



