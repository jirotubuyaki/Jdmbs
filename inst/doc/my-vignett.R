## ---- echo=FALSE, fig.width=60, fig.height=30, dpi=300,out.width='16.5cm'----
load("~/Desktop/GitHub/Jdmbs/data/data.rda")
simulation.length <- 180;
start_price<- c(1000,500,500,1500,1250,800);
mu <- c(1,1.5,2,0.8,0.4,0.25);
sigma <- c(0.15,0.2,0.25,0.18,0.2,0.11);
monte_carlo <- 1000;
K <- c(1000,70,1000,1500,1800,600);
companies <- 6;
color <- c("red","blue","green","blueviolet","pink","deepskyblue","mediumvioletred");
normal_bs(companies, simulation.length=180, monte_carlo=1000, start_price, mu, sigma, K, color);

