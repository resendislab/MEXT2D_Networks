This repository contains all the code to implement all examples showed in our paper:

XXXXXXXXX

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

![image](https://user-images.githubusercontent.com/71458550/151588872-299f311a-9e5f-4904-9ef7-467e106a399b.png)


## Network inference

#### Correlations

We used SparCC to infer microbial interactions for every group of study. Run the next command in your terminal to infer the microbial network:

`bash net_inference_sparcc.sh`

#### Network preparation

Run the next script in R to get the nodes and edges of each network for every group of study:

[net_preparation.R](www.abcdefgh.com)

Note:  you will need to run an additional script in python. It is available in [notebook](www.abcdegfhg) format. 

#### Network visualization

Run the next script in R, it will create an html file with the network visualization:

[net_visualization.R](www.abcdefgh.com)









