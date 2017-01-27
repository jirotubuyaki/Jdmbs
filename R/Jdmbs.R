#' Normal A Monte Carlo Option Pricing Algorithm
#' @param  companies is a number of simulate companies.
#' @param  simulation.length is a duration of simulation.
#' @param  monte_carlo is a iteration number of monte carlo.
#' @param  start_price is a vector of initial price of company stock prices.
#' @param  mu is a vector of parameters of geometric brown motions.
#' @param  sigma is a voctor of parameters of geometric brown motions.
#' @param  K is a vector of option execution prices.
#' @param  color is a vector of colors in plot.
#' @return premium of a list with (call_premium, put_premium)
#' @examples
#' normal_bs(1, simulation.length=180, monte_carlo=1000, 1000, 1, 0.6, 1200, "blue")
#' @export
normal_bs<- function(companies, simulation.length=180, monte_carlo=1000, start_price, mu, sigma, K, color) {
  #simulation.length <- 180;
  #start_price<- c(1000,500,500,1500,1250,800);
  #mu <- c(1,1.5,2,0.8,0.4,0.25);
  #sigma <- c(0.4,0.4,0.5,0.3,0.8,0.15);
  #monte_carlo <- 1000;
  #K <- c(1000,1000,1000,2100,1800,200);
  #companies <- 6;
  #color <- c("red","blue","green","blueviolet","pink","deepskyblue","mediumvioletred");

  dt <-  1 / simulation.length
  timeline <- seq(0,simulation.length-1,1)
  price_sim <-array(0,c(companies, monte_carlo));
  g <- array(0,c(companies, simulation.length))
  premium <- c(0,0,0,0,0,0);
  price_limit <-0;

  f <- array(0,c(companies, simulation.length))
  for(count in 1:companies){
    g[count,1] <- start_price[count];
  }
  for(count in 1:monte_carlo){
    for(i in 2:simulation.length){
      for(number in 1:companies){
        f[number,i] <- f[number,i-1]+sqrt(dt)*rnorm(1)
        g[number,i] <- g[number,1]*exp((mu[number] - (sigma[number]^2)/2)*(i-1)*dt+sigma[number]*f[number,i])
        if(g[number,i] > price_limit){price_limit <- g[number,i];}
      }
    }
    for (j in 1:companies){
      price_sim[j,count] <- g[j,simulation.length];
    }
    if(count == 1){
      plot(timeline,g[1,],xlab="t",ylab="price", ylim=c(-1000,price_limit),xlim=c(0,simulation.length),xaxp=c(0,simulation.length,simulation.length/10),type="l", col="black",lwd = 0.10,cex.axis = 0.6,cex.lab = 0.8);
      par(new=T)
      for (i in 1:companies){
        plot(timeline,g[i,], ylim=c(0,price_limit),xlim=c(0,simulation.length),xlab="",ylab="",axes=FALSE,type="l", col=color[i],lwd = 0.10,cex.axis = 0.6);
        par(new=T)
      }
    }
    else{
      for (i in 1:companies){
        plot(timeline,g[i,], ylim=c(0,price_limit),xlim=c(0,simulation.length),xlab="",ylab="",axes=FALSE,type="l", col=color[i],lwd = 0.10,cex.axis = 0.6);
        par(new=T)
      }
    }
  }
  par(new=T)
  title(main="Geometric Brownian Motion", col.main="black", font.main=1,cex.main = 0.8)
  #legend(1,8000, c("mu = 0.7,  sigma = 0.5"), cex=0.8, col=c("black"), pch=1, lty=1);

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
  names(call_premium) <- "Call Option Price";
  names(put_premium) <- "Put Option Price";
  premium <- list(call_premium,put_premium);
  return (invisible(premium));
}
