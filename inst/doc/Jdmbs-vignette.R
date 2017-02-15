## ----echo=FALSE,warnings=FALSE,messages=FALSE,results='hide',fig.align='center', fig.width=60, fig.height=30, dpi=300,out.width='10cm'----
library(igraph);
company_1<- c(1,1,1,2,2,2,3,4,5,5,5,6);
company_2 <- c(2,5,4,1,3,5,2,1,1,2,6,5);
weight <- c(0.8,0.6,-0.8,0.2,0.5,0.4,0.6,-0.8,0.1,0.3,-0.2,-0.2);
dis.mat<- data.frame(Company_1=company_1, Company_2=company_2, WEIGHT=weight);
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
	vertex.label.cex=10,
	edge.label=E(g)$weight,
	edge.color="gray",
	edge.label.color="black",
	edge.label.cex = 10,
	edge.arrow.size =0.6,
	edge.width =0.5,
	edge.curved=seq(-0.75, -0.75, length = ecount(g))
	);

## ---- echo=FALSE, fig.width=60, fig.align='center', fig.height=25, dpi=300,out.width='16.5cm'----
load("../data/data.rda")
source('../R/Jdmbs.R')
normal_bs(3 ,simulation.length=90,monte_carlo=80, c(10000,7000,5000), c(0.0012, 0.0012, 0.0012),
+ c(sqrt(0.002),sqrt(0.002),sqrt(0.002)), c(2500,3000,1500), c("deeppink","royalblue","greenyellow"))

