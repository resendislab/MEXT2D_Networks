#load phyloseq
library("phyloseq")
#load edgeR
library("edgeR")
#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("edgeR")
#load phatostat
library("PathoStat")
#if (!require("BiocManager", quietly = TRUE))
# install.packages("BiocManager")
#BiocManager::install("PathoStat")
library("ggplot2")

rm(list=ls()) 
setwd("/Users/davidgiron/maestria/articulo_diego/EdgeR")
getwd()

#import data from otu table
otu.out <- as.matrix(read.csv("abund_asv.txt", header = T, row.names = NULL, sep = "\t", check.names=F))
str(otu.out)
#generate the transposed table
otu1 <- t(otu.out)
class(otu1)
#assign colnames
colnames(otu1) <-otu1[1,]
#remove duplicate rows
otu2<- otu1[-1,]
class(otu2)

#convert to numeric matrix
ncol(otu2)
otu5 <- matrix(
  as.numeric(otu2), ncol = ncol(otu2)) 

#reassign rownames and colnames
rownames(otu5) <- rownames(otu2)
colnames(otu5) <- colnames(otu2)

class(otu5)
str(otu5)

#import data from taxonomy
taxa.out <- as.matrix(read.table("taxa_asvedger.txt", header = T, row.names = NULL, sep = "\t", check.names=F))
str(taxa.out)

#assign rownames
rownames(taxa.out) <- taxa.out[,1]

#remove duplicate columns
taxa<- taxa.out[,-1]
class(taxa)

#prepare to make phyloseq object
OTU = otu_table(otu5, taxa_are_rows = TRUE)
TAX = tax_table(taxa)
OTU
TAX

#add sample data
#import data from taxonomy
sample.out <- as.data.frame(read.table("mod_tabla_sample.txt", header = T, row.names = 1, sep = "\t", check.names=F))
str(sample.out)

#prepare a phyloseq sample object
samplingdata <- sample_data(sample.out)

#create physeq object with otu, taxonomy and sample data

physeq2 = phyloseq(OTU, TAX, samplingdata)
physeq2


#comparison between Healthy and IFG
#first filter the phyloseq object for the selected groups
physeq3 = prune_samples(physeq2@sam_data[["status"]] == "healthy"  | physeq2@sam_data[["status"]] == "IFG", physeq2)

#independent filtering
filtcp = transform_sample_counts(physeq3, function(x){x/sum(x)})
hist(log10(apply(otu_table(filtcp), 1, var)),
     xlab="log10(variance)", breaks=50,
     main="A large fraction of OTUs have very low variance")

varianceThreshold = 1e-5
keepOTUs = names(which(apply(otu_table(filtcp), 1, var) > varianceThreshold))
filtcB = prune_taxa(keepOTUs, physeq3)
filtcB 


#save image of OTus variance
#save image
png("OtusHealthyvsIFG.png", 
    width = 16*300, 
    height = 9*300, 
    res = 400, 
    pointsize = 10)
hist(log10(apply(otu_table(filtcp), 1, var)),
     xlab="log10(variance)", breaks=50,
     main="A large fraction of OTUs have very low variance (Healthy vs IFG)")
dev.off()


#Now let’s use our newly-defined function to convert the phyloseq data object kosticB into 
#an edgeR “DGE” data object, called dge.
#make the comparison with the status column
dge = phyloseq_to_edgeR(filtcB, group="status")
# Perform binary test
et = exactTest(dge)
# Extract values from test results, we used the genera with a FDR lower than 0.001
tt = topTags(et, n=nrow(dge$table), adjust.method="BH", sort.by="PValue")
res = tt@.Data[[1]]
alpha = 0.001
sigtab1 = res[(res$FDR < alpha), ]
sigtab1 = cbind(as(sigtab1, "data.frame"), as(tax_table(filtcB)[rownames(sigtab1), ], "matrix"))
dim(sigtab1)

head(sigtab1)

#make a plot with ggplot2
#this is a dot plot that positions the genera according to their log fold change in the graph
#also it colours the genera according to their corresponding phylum
#library("ggplot2"); packageVersion("ggplot2")

theme_set(theme_bw())
scale_fill_discrete <- function(palname = "Set1", ...) {
  scale_fill_brewer(palette = palname, ...)
}
sigtabgen1 = subset(sigtab1, !is.na(Genus))
# Phylum order
x = tapply(sigtabgen1$logFC, sigtabgen1$Phylum, function(x) max(x))
x = sort(x, TRUE)
sigtabgen1$Phylum = factor(as.character(sigtabgen1$Phylum), levels = names(x))
# Genus order
x = tapply(sigtabgen1$logFC, sigtabgen1$Genus, function(x) max(x))
x = sort(x, TRUE)
sigtabgen1$Genus = factor(as.character(sigtabgen1$Genus), levels = names(x))
PW1 <- ggplot(sigtabgen1, aes(x = Genus, y = logFC, color = Phylum)) + geom_point(size=6) + 
  theme(axis.text.x = element_text(angle = -90, hjust = 0, vjust = 0.5))

#save image
ggsave("pwHealthyvsIFG.png",
  plot = PW1,
  device = "png",
  width = 10,
  height = 7,
  units = c("in", "cm", "mm", "px"),
  dpi = 300)


##########################################
##########################################