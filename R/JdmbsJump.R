#' A Monte Carlo Option Pricing Algorithm for Jump Diffusion Model
#' @import poisson
#' @param  companies is a number of simulate companies.
#' @param  simulation.length is a duration of simulation.
#' @param  monte_carlo is a iteration number of monte carlo.
#' @param  start_price is a vector of initial price of company stock prices.
#' @param  mu is a vector of parameters of geometric brown motions.
#' @param  sigma is a voctor of parameters of geometric brown motions.
#' @param  K is a vector of option execution prices.
#' @param  lambda is Parameter of Poisson process.
#' @param  k is a number something happen in Poisson process.
#' @param  color is a vector of colors in plot.
#' @return premium of a list with (call_premium, put_premium)
#' @examples
#' jdm_bs(1, simulation.length=50, monte_carlo=100, 1000, 1, 0.6, 1200, 2, 5,  "blue");
#' @export
jdm_bs<- function(companies, simulation.length=180, monte_carlo=1000, start_price, mu, sigma, K, lambda, k, color) {
  #simulation.length <- 180;
  #start_price <- c(1000,500,500,1500,1250,800);
  #mu <- c(1,1.5,2,0.8,0.4,0.25);
  #sigma <- c(0.4,0.4,0.5,0.3,0.8,0.15);
  #monte_carlo <- 1000;
  #K <- c(1000,1000,1000,2100,1800,200);
  #lambda <- 2;
  #k <- 5;
  #companies <- 6;
  #color <- c("red","blue","green","blueviolet","pink","deepskyblue","mediumvioletred");

  dt <-  1 / simulation.length
  timeline <- seq(0,simulation.length-1,1)
  price_sim <-array(0,c(companies, monte_carlo))
  g <- array(0,c(companies, simulation.length))
  jump <- c()
  jump_count <- 1
  premium <- c()
  price_graph_limit <-0
  f <- array(0,c(companies, simulation.length))
  for(company in 1:companies){
    g[company,1] <- start_price[company]
    jump[company] <- 0
  }
  for(count in 1:monte_carlo){
    S <- c()
    expdt <- 1
    for(j in 1 : simulation.length){
      p <- pexp((expdt * qexp(1-1e-8,rate=1)) / simulation.lengt,rate=1)
      print(p)
      if(runif(1,min=0,max=1) < p){
        S <- c(S, j)
        expdt <- 1
        print(j)
      }
      else{
        expdt <- expdt + 1
      }
      print(S)
    }
    plot(x = S, y = 1 : length(S), type = "s", xlim = c(0, simulation.length),axes=FALSE,lwd = 0.10,xlab="",ylab="")
    par(new=T)
    for(i in 2:simulation.length){
      flag_jump <- "off";
      for(number in 1:companies){
        if(S[jump_count] <= i && jump_count <= length(S)){
          flag_jump <- "on";
          jump[number] <- jump[number] + rnorm(1,mean=0, sd=0.5)
          f[number,i] <- f[number,i-1]+sqrt(dt)*rnorm(1)
          g[number,i] <- g[number,1]*exp((mu[number] - (sigma[number]^2)/2)*(i-1)*dt+sigma[number]*f[number,i] + jump[number])
        }
        else{
          f[number,i] <- f[number,i-1]+sqrt(dt)*rnorm(1)
          g[number,i] <- g[number,1]*exp((mu[number] - (sigma[number]^2)/2)*(i-1)*dt+sigma[number]*f[number,i] + jump[number])
        }
        if(g[number,i] > price_graph_limit){price_graph_limit <- g[number,i]}

      }
      if(flag_jump == "on"){jump_count <- jump_count + 1}
    }
    for (j in 1:companies){
      price_sim[j,count] <- g[j,simulation.length];
    }

    if(count == 1){
      plot(timeline,g[1,],xlab="t",ylab="price", ylim=c(-1000,price_graph_limit+100),xlim=c(0,simulation.length),xaxp=c(0,simulation.length,simulation.length/10),type="l", col="black",lwd = 0.10,cex.axis = 0.6,cex.lab = 0.8);
      par(new=T)
      for (i in 1:companies){
        plot(timeline,g[i,], ylim=c(0,price_graph_limit+100),xlim=c(0,simulation.length),xlab="",ylab="",axes=FALSE,type="l", col=color[i],lwd = 0.10,cex.axis = 0.6);
        par(new=T)
        print("plot1")
      }
    }
    else{
      for (i in 1:companies){
        plot(timeline,g[i,], ylim=c(0,price_graph_limit+100),xlim=c(0,simulation.length),xlab="",ylab="",axes=FALSE,type="l", col=color[i],lwd = 0.10,cex.axis = 0.6);
        par(new=T)
      }
    }
  }

  matplot(x = S, y=1:length(S), type ="s", col="black", ylim=c(0,price_graph_limit+100), xlim=c(0,simulation.length), lwd = 0.1, cex.axis = 0.6, cex.lab = 0.8, axes=FALSE, xlab="", ylab="");
  par(new=T)
  title(main="Geometric Brownian Motion", col.main="black", font.main=1,cex.main = 0.8);

  call_premium <- numeric(companies);
  put_premium <- numeric(companies);
  for(i in 1:companies){
    for(count in 1:monte_carlo){
      if((price_sim[i,count] - K[i]) <= 0){
        call_premium[i] <- call_premium[i] + 0;
      }
      else{
        call_premium[i] <- call_premium[i] + price_sim[i,count];
      }
    }
    call_premium[i] <- call_premium[i] / monte_carlo;
  }
  for(i in 1:companies){
    for(count in 1:monte_carlo){
      if((K[i] - price_sim[i,count]) <= 0){
        put_premium[i] <- put_premium[i] + 0;
      }
      else{
        put_premium[i] <- put_premium[i] + price_sim[i,count];
      }
    }
    put_premium[i] <- put_premium[i] / monte_carlo;
  }
  print("Call Option Price:");
  print(call_premium);
  print("Put Option Price:");
  print(put_premium);

  premium <- list(call_premium,put_premium);
  return (invisible(premium));
}
test <- function(lambda, simulation.length){
  dt <-  1 / simulation.length
  S <- c()
  for(count in 1 : simulation.length){
    p <- pexp(dt,rate=1)
    print(p)
    if(runif(1,min=0,max=1) < p){
      S <- c(S, count)
      dt <-1 / simulation.length
      print(count)
    }
    dt <- dt + 1 / simulation.length
  }
  print(S)
}
