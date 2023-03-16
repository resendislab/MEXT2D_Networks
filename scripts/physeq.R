library(tidyverse)
library(phyloseq)

#### here it is the description to obtain the phyloseq object 
setwd("/Users/davidgiron/maestria/articulo_diego")

#read the asv table
taxa <- read.table("taxa_asvid_annotated.txt", header = TRUE)
taxa
#subset until the taxonomic level you prefer
taxa = subset(taxa, select = -c(sequence,Species) )


names(taxa)[1]="OTU_ID"

rownames(taxa) <- taxa$OTU_ID

taxa$OTU_ID<- NULL
#save as matrix this will be useful for the phyloseq object function
taxa <- as.matrix(taxa)


#write.table(taxa, file = "taxa_id_clean.txt", quote = FALSE)

#add the abundance table
otumat <- read.table("abund_asv.txt",header = TRUE,check.names = FALSE)

otumat<- t(otumat)

otumat <- as.data.frame(otumat)

names(otumat) <- lapply(otumat[1, ], as.character)
otumat<- otumat[-1,]

#save as matrix
otumat <- data.matrix(otumat)


#assign the asv table and abundance table to their specific phyloseq function
OTU = otu_table(otumat, taxa_are_rows = TRUE)

TAX = tax_table(taxa)
OTU
TAX

#add sample information
samples<- read.table("mod_tabla_sample.txt", header = TRUE)
rownames(samples) <- samples$sample_id
samples$sample_id<- NULL
#assign sample data to their phyloseq function
SAM = sample_data(samples)

sample_names(SAM)
#Prepare phyloseq object
physeq2 = phyloseq(OTU, TAX,SAM)
physeq


taxa_names(TAX)

#remove all stranger characters to prepare data
# find and substitute
#Escherichia/shigella
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="Escherichia/Shigella",replacement="Escherichia.Shigella")

#all - for .
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="-",replacement=".")

#UBA1819
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="UBA1819",replacement="Faecalibacterium_sp.UBA1819")

#CAG.56
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="CAG.56",replacement="Firmicutes_bacterium_CAG.56")

#CAG.352
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="CAG.352",replacement="Clostridium_CAG.352")

#DTU089
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="DTU089",replacement="Clostridiales_bacterium_DTU089")

#GCA.900066575
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="GCA.900066575",replacement="GCA.900066575_genus")

#GCA.900066225
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="GCA.900066225",replacement="GCA.900066225_genus")

#UC5.1.2E3
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="UC5.1.2E3",replacement="Clostridia_bacterium_UC5.1.2E3")

#DNF00809
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="DNF00809",replacement="Coriobacteriales_bacterium_DNF00809")

#S5.A14a
tax_table(physeq2)[,colnames(tax_table(physeq2))] <- gsub(tax_table(physeq2)[,colnames(tax_table(physeq2))],pattern="S5.A14a",replacement="Clostridiales_bacterium_S5.A14a")



