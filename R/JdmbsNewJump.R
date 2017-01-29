#' A Monte Carlo Option Pricing Algorithm for Jump Diffusion Model with Correlation Companies
#' @import poisson
#' @param  companies_data is a correlation coefficients of companies in “data.csv” file.
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
#' jdm_new_bs(matrix(0.1:0.9, nrow=3, ncol=3), 3 ,simulation.length=50,
#' monte_carlo=100, c(1000,500,500), c(1,1.5,2),
#' c(0.4,0.4,0.5), c(1000,1000,1000), 2, 4, c("red","blue","green"))
#' @export
jdm_new_bs<- function(companies_data, companies, simulation.length=180, monte_carlo=1000, start_price, mu, sigma, K, lambda, k, color) {
  #companies_data <- read.table("data.csv", sep=",");
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
  price_sim <-array(0,c(companies, monte_carlo));
  g <- array(0,c(companies, simulation.length))
  jump <- c(0,0,0,0,0,0);
  jump_count <- 2;
  premium <- c(0,0,0,0,0,0);
  price_limit <-0;
  f <- array(0,c(companies, simulation.length))
  for(count in 1:companies){
    g[count,1] <- start_price[count];
  }
  for(count in 1:monte_carlo){
    S <- poisson::hpp.event.times(lambda, k, num.sims = 1, t0 = 0)
    S <- S * simulation.length
    plot(x = S, y = 1:k, type = "s", xlim = c(0, simulation.length),axes=FALSE,lwd = 0.10,xlab="",ylab="")
    par(new=T)
    for(i in 2:simulation.length){
      flag_jump <- "off";
      jump_company <- rep(0:0, length=jump_count);
      for(j in 1: jump_count){
        jump_company[j-1] <- as.integer(runif(1,min=1,max=companies+1));
      }
      for(number in 1:companies){
        if(S[jump_count] <= i && jump_count <= k){
          flag_jump <- "on";

          if(runif(1,min=0,max=1) >= 0.5){
            jump[number] <- rnorm(1,mean=0, sd=0.5) * companies_data[jump_company[jump_count-1],number];
          }
          else{
            jump[number] <- rnorm(1,mean=0, sd=0.5) * companies_data[jump_company[jump_count-1],number];
          }
          f[number,i] <- f[number,i-1]+sqrt(dt)*rnorm(1)
          g[number,i] <- g[number,1]*exp((mu[number] - (sigma[number]^2)/2)*(i-1)*dt+sigma[number]*f[number,i] + jump[number])
        }
        else{
          f[number,i] <- f[number,i-1]+sqrt(dt)*rnorm(1)
          g[number,i] <- g[number,1]*exp((mu[number] - (sigma[number]^2)/2)*(i-1)*dt+sigma[number]*f[number,i])
        }
        if(g[number,i] > price_limit){price_limit <- g[number,i];}

      }
      if(flag_jump == "on"){jump_count <- jump_count + 1}
    }
    for (j in 1:companies){
      price_sim[j,count] <- g[j,simulation.length];
    }

    if(count == 1){
      plot(timeline,g[1,],xlab="t",ylab="price", ylim=c(-1000,price_limit+100),xlim=c(0,simulation.length),xaxp=c(0,simulation.length,simulation.length/10),type="l", col="black",lwd = 0.10,cex.axis = 0.6,cex.lab = 0.8);
      par(new=T)
      for (i in 1:companies){
        plot(timeline,g[i,], ylim=c(0,price_limit+100),xlim=c(0,simulation.length),xlab="",ylab="",axes=FALSE,type="l", col=color[i],lwd = 0.10,cex.axis = 0.6);
        par(new=T)
      }
    }
    else{
      for (i in 1:companies){
        plot(timeline,g[i,], ylim=c(0,price_limit+100),xlim=c(0,simulation.length),xlab="",ylab="",axes=FALSE,type="l", col=color[i],lwd = 0.10,cex.axis = 0.6);
        par(new=T)
      }
    }
  }

  matplot(x = S, y=1:k, type ="s", col="black", ylim=c(0,price_limit+100), xlim=c(0,simulation.length), lwd = 0.5, cex.axis = 0.6, cex.lab = 0.8, axes=FALSE, xlab="", ylab="")
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

  premium <- list(call_premium,put_premium);
  return (invisible(premium));
}
