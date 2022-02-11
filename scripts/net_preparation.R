#https://rachaellappan.github.io/16S-analysis/correlation-between-otus-with-sparcc.html#running-sparcc
library(tidyverse)

rm(list=ls()) #delete all variables
setwd("/Users/davidgiron/maestria/articulo_diego")
getwd()

#read the genera and pvalue tables generated with sparcc
NPS.corr <- as.matrix(read.table("tabla_genera_sparcc.txt", header = T, row.names = 1, sep = "\t", check.names=F))
NPS.oneside <- as.matrix(read.table("pvals_one_sided.txt", header = T, row.names = 1, sep = "\t", check.names=F))

# Combine the correlation and p-value matrices
NPS.1 <- list(NPS.corr, NPS.oneside) 

# List the correlation coefficients
NPS.all <- NPS.corr
NPS.all[lower.tri(NPS.all, diag = TRUE)] <- NA
NPS.all <- as.data.frame(as.table(NPS.all))
NPS.all <- na.omit(NPS.all)
#change the column names of the correlations dataframe
names(NPS.all) <- c("Var1", "Var2", "Correlation")

# List the p-values
NPS.p <- NPS.oneside
NPS.p[lower.tri(NPS.p, diag = TRUE)] <- NA
NPS.p <- as.data.frame(as.table(NPS.p))
NPS.p <- na.omit(NPS.p)
names(NPS.p) <- c("Var1", "Var2", "p")

# Put the p-values and correlation coeficients 
#in a table and export, sorting by correlation magnitude
NPS.out <- merge(NPS.all, NPS.p)
NPS.out <- NPS.out[order(-abs(NPS.out$Correlation)),]
#write sorted table, you can upload the file later
write.table(NPS.out, "caseNPS_all_correlations.txt", sep = "\t", row.names = F, quote= FALSE)
#NPS.out <- as.data.frame(read.table("caseNPS_all_correlations.txt", header = T, row.names = NULL, sep = "\t", check.names=F))

#filter the  correlations and p values, you can determine which value you will use 
#for each filtering. In this case we used a value of 0.60 for correlations and 0.05 for p-values
str(NPS.out)
cutNPS.outC <- filter(NPS.out, NPS.out$Correlation < -0.60 | NPS.out$Correlation > 0.60) #filter by correlation value
cutNPS.out <- filter(cutNPS.outC, p < 0.05) #filter by p-value

#write filtered table with filtered correlations and p-values
write.table(cutNPS.out, "caseNPS_all_correlations_0.60.txt", sep = "\t", row.names = F, quote= FALSE)


#network preparation
#make a table for the edges with VisNetwork
names(cutNPS.out) <- c("from", "to", "value", "p")

# Drop the p-value columns
cutNPS.out <- select (cutNPS.out,-c(p))


#get the nodes from the network
V1 <- cutNPS.out %>% select(from) %>% sapply(as.character) %>% as.vector
V2 <- cutNPS.out %>% select(to) %>% sapply(as.character) %>% as.vector
Nodes <- sort(union(V1,V2))
lungo <- length(Nodes)

#make a data frame for the nodes
id <- Nodes 
label <- Nodes
shape <- rep_len("dot", lungo)
value <- rep_len(1, lungo)

Nodes.df<- data.frame(id, label,  
                      shape, value) 
Nodes.df 

#write a table for the nodes
write.table(Nodes.df, "nodes_T2D.txt", sep = "\t", row.names = F, quote= FALSE)



#######################################################################
#######################################################################
######################################################################
#on this step we will use a python script to  add a group column based on taxonomy (phylum, class, order, etc..)
#to the nodes table 
#first we need to prepare the tables to use python script to match full with short taxonomy

#table1
#load taxonomy data
setwd("/Users/davidgiron/maestria/articulo_diego")
getwd()
data <- read.delim("genus_matrix.txt", header=T, row.names=1, check.names=F)
class(data)

### remove full taxonomy and remain with the last name
nombres <- data.frame(completo=rownames(data))
V1_names <- as.character(nombres$completo)
#nombres$ultimo <- sapply(as.character(nombres$completo), function(x){strsplit(x, ";")[[1]][length(strsplit(x, ";")[[1]])]})
#change the last []to select phylum[2], class[], order, etc..
nombres$ultimo <- sapply(V1_names, function(x){strsplit(x, ";")[[1]][6]})
#rownames(data) <- nombres$ultimo

#prepare the df with full and short name
df_table1 <- nombres
names(df_table1) <- c("taxa", "searchterm")

#write table1, this is the table we will use as input to the  python notebook called merge_taxa.ipynb
write.table(df_table1, "table1M_df.txt", sep = "\t", row.names = F, col.names= T, quote= FALSE)



###########nodes preparation
#table2
#use the already prepared table for Nodes
#import the merged file prepared with python script
setwd("/Users/davidgiron/maestria/articulo_diego")
merged_nodesdf <- read.delim("df_genus_filled030.txt", header=T, row.names=NULL, check.names=F)

#remove all taxa names and remain just phylum or selected level
V2_names <- as.character(merged_nodesdf$taxa)
merged_nodesdf$phylum <- sapply(V2_names, function(x){strsplit(x, ";")[[1]][2]})

#add family
#merged_nodesdf$family <- sapply(V2_names, function(x){strsplit(x, ";")[[1]][5]})

#relocate columns to visNetwork
#library(dplyr)
table_nodesdf<- merged_nodesdf %>% select(id, label, phylum, shape, value)
#rownames(table_nodesdf) <- merged_nodesdf$id
names(table_nodesdf) <- c("id", "label", "group", "shape", "value")

#write modified nodes_table
#setwd("/Users/diegoesquivel/Documents/Inmegen_postdoc/diabetes_tipo2_postdoc/datos/Sparcc_T2/Full/genus/ResultsSparCC")
getwd()
write.table(table_nodesdf, "mod_nodes_healthy_045.txt", sep = "\t", row.names = F, col.names= T, quote= FALSE)

###############################################################
################################################################
################################################################
#edges preparation
#make a data frame for the edges
#get the values of the edge
V3 <- cutNPS.out %>% select(value) %>% sapply(as.numeric) %>% as.vector
length(V3)

#select values, positive or negative
V3L <- V3 > 0

#Assing a color based on their value (positive or negative)
#positive ("gray" color), negative ("salmon", color)
mutate(tibble(a=V3L),
       b=case_when(a %in% c(T) ~ "gray",
                   a %in% c(F) ~ "salmon"))
color <- c(.Last.value %>% pull(b))

#add the color column to a edges_dataframe
edges.df <-cutNPS.out %>% add_column(color)

#write a table for edges
write.table(edges.df, "edges_T2D_T2Dtreat_015.txt", sep = "\t", row.names = F, quote= FALSE)


#write a table for analysis with NetAn (edges)
#read tables to optimize this processes
edges.df <- as.data.frame(read.table("edges_T2D_T2Dtreat_015.txt", header = T, sep = "\t", check.names = F))

# Drop the columns of the color
edgesNetAn.df <- select (edges.df,-c(color))

#write a table for NetAn
write.table(edgesNetAn.df, "edges_T2D_T2Dtreat_015NA.txt", sep = "\t", row.names = F, col.names= F, quote= FALSE)

