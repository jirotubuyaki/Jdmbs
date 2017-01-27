## ----echo=FALSE,warnings=FALSE,messages=FALSE,results='hide',fig.align='center', fig.width=60, fig.height=30, dpi=300,out.width='10cm'----
library(igraph);
dis.mat <- read.table("../data/graph.csv", sep=",");
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

## ---- echo=FALSE, fig.width=60, fig.align='center', fig.height=28, dpi=300,out.width='16.5cm'----
load("../data/data.rda")
source('../R/Jdmbs.R')
simulation.length <- 180;
start_price<- c(1000,500,500,1500,1250,800);
mu <- c(1,1.5,2,0.8,0.4,0.25);
sigma <- c(0.15,0.2,0.25,0.18,0.2,0.11);
monte_carlo <- 1000;
K <- c(1000,70,1000,1500,1800,600);
companies <- 6;
color <- c("red","blue","green","blueviolet","pink","deepskyblue","mediumvioletred");
normal_bs(companies, simulation.length=180, monte_carlo=1000, start_price, mu, sigma, K, color);

