#Script para tunear redes con visnetwork
rm(list=ls()) #Eliminar todas las listas

#Cargar librerias
library("visNetwork")


#Seleccionar directorio de trabajo
setwd("/Users/diegoesquivel/Documents/Inmegen_postdoc/diabetes_tipo2_postdoc/datos/Sparcc_T2/IGT_preT2D/Genus/ResultsSparCC")
getwd()
#Examples
#require(visNetwork, quietly = TRUE)
# minimal example
#nodes <- data.frame(id = 1:3)
#edges <- data.frame(from = c(1,2), to = c(1,3))
#visNetwork(nodes, edges, width = "100%")

#Read Edges
edgesA<-read.table("edges_IGT_preT2D_045.txt", header=TRUE,sep="\t")

#Read Nodes 
nodesA<-read.table("nodes_IGT_preT2D_045.txt", header = TRUE, sep="\t")

#to html customizables 
#SITE B 

#site4t_network <- visNetwork(nodesA, edgesA, width = "100%")
str(edgesA)
class(edgesA)

str(nodesA)
class(nodesA)


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




#
#nxdes <- data.frame(id = 1:3,
#                    color.background = c("lightblue","red","blue"),
#                    color.border = "black")




#
#nods <- data.frame(id = 1:10, color = c(rep("blue", 6), rep("red", 3), rep("green", 1)))

#edgs <- data.frame(from = round(runif(6)*10), to = round(runif(6)*10))

#visNetwork(nods, edgs) %>%
#  visClusteringByColor(colors = c("blue"))

#nods <- data.frame(id = 1:10, label = paste("Label", 1:10), 
#                    group = sample(c("A", "B"), 10, replace = TRUE))
#edgs <- data.frame(from = c(2,5,10), to = c(1,2,10))

#visNetwork(nods, edgs) %>%
#  visGroups(groupname = "A", color = "red", shape = "square") %>%
#  visGroups(groupname = "B", color = "yellow", shape = "triangle") %>%
#  visClusteringByColor(colors = c("red"), label = "With color ") %>%
#  visClusteringByGroup(groups = c("B"), label = "Group : ") %>%
#  visLegend()


#nodxs <- data.frame(id = 1:3, color = rep("blue", 3))


#visDocumentation()
#vignette("Introduction-to-visNetwork") # with CRAN version
# shiny example
#shiny::runApp(system.file("shiny", package = "visNetwork"))
