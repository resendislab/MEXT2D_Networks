#this script will create an html of the networks prepared during the last step
rm(list=ls()) #clean space

#load library 
library("visNetwork")


#select working directory
setwd("/Users/diegoesquivel/Documents/Inmegen_postdoc/diabetes_tipo2_postdoc/datos/Sparcc_T2/IGT_preT2D/Genus/ResultsSparCC")
getwd()


#read Edges
edgesA<-read.table("edges_IGT_preT2D_045.txt", header=TRUE,sep="\t")

#read Nodes 
nodesA<-read.table("nodes_IGT_preT2D_045.txt", header = TRUE, sep="\t")

#check edges and nodes
str(edgesA)
class(edgesA)

str(nodesA)
class(nodesA)

#create network visualization in html format
siteA_network<-visNetwork(nodesA,edgesA, height = "700px", width = "100%",main = "Healthy Corte 0.45 (Genus)") %>%
  visLegend()%>%
  visEdges(arrows="to")%>%
  visOptions(selectedBy = NULL,
             highlightNearest = TRUE, 
             nodesIdSelection = TRUE,
             manipulation=TRUE) %>%
  visPhysics(enable=TRUE) %>%
  visConfigure(enabled=TRUE)
visSave(siteA_network, file = "networkhealthy_045_genus_prueba1.html")

