## ----fig.width=3.1,fig.height=3.1,fig.align="center",echo=FALSE----------
library(png)
library(grid)
img <- readPNG("./companies.png")
 grid.raster(img)

## ---- echo=FALSE, fig.width=60, fig.align='center', fig.height=25, dpi=300,out.width='16.5cm'----
load("../data/data.rda")
source('../R/Jdmbs.R')
normal_bs(3 ,simulation.length=90,monte_carlo=80, c(10000,7000,5000), c(0.0012, 0.0012, 0.0012),
+ c(sqrt(0.002),sqrt(0.002),sqrt(0.002)), c(2500,3000,1500), c("deeppink","royalblue","greenyellow"))

