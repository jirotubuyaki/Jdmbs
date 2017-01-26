library(igraph);
dis.mat <- read.table("~/Desktop/GitHub/Jdmbs/data/graph.csv", sep=",");
g <- graph.data.frame(dis.mat[1:2]);
E(g)$weight <- dis.mat[[3]];
reciprocity(g)
dyad.census(g)
is.mutual(g)
plot(g,
	layout=layout.fruchterman.reingold,
	vertex.size=30,
	vertex.color="deepskyblue",
	vertex.label.color="white",
	vertex.label.cex=1.5,
	edge.label=E(g)$weight,
	edge.color="gray",
	edge.label.color="black",
	edge.label.cex = 1.3,
	edge.arrow.size =0.6,
	edge.width =0.5,
	edge.curved=seq(-0.75, -0.75, length = ecount(g))
	);
