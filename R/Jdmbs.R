##' Normal Monte Carlo Option Pricing Algorithm
#' @import utils
#' @import graphics
#' @import stats
#' @import rmarkdown
#' @param  companies is a j of simulate companies.
#' @param  simulation.length is a duration of simulation.
#' @param  monte_carlo is a iteration j of monte carlo.
#' @param  start_price is a vector of initial price of j stock prices.
#' @param  mu is a vector of parameters of geometric brown motions.
#' @param  sigma is a voctor of parameters of geometric brown motions.
#' @param  K is a vector of option execution prices.
#' @param  color is a vector of colors in plot.
#' @return premium of a list with (call_premium, put_premium)
#' @examples
#' normal_bs(1, simulation.length=50, monte_carlo=1000,1000, 0.007, 0.03, 3000, "blue")
#' @export
normal_bs<- function(companies, simulation.length=180, monte_carlo=1000, start_price, mu, sigma, K, color) {

  price_sim <-array(0,c(companies, monte_carlo));
  price <- array(0,c(companies, simulation.length))
  premium <- c()
  price_up_limit_graph <- 0;
  price_down_limit_graph <- 0;
  dW <- array(0,c(companies))
  W <- array(0,c(companies))

  for(count in 1 : monte_carlo){
    for(i in 2 : simulation.length){
      for(j in 1 : companies){
        if(i == 2){
          W[j] <- 0
          price[j,1] <- start_price[j]
        }
        # W2 - W1 = N(mean=0, sd = 2 - 1)
        dW[j] <- rnorm(1, mean = 0, sd = 1)
        W[j] <- W[j] + dW[j]
        # about Geometric Brownian Motion from Wikipedia ( https://en.wikipedia.org/wiki/Geometric_Brownian_motion )
        price[j,i] <- start_price[j] * exp((mu[j] - (sigma[j] ^ 2) / 2) * (i - 1)  + sigma[j] * W[j])
        if(price[j,i] > price_up_limit_graph){
          price_up_limit_graph <- price[j,i]
        }
        if(price[j,i] < price_down_limit_graph){
          price_down_limit_graph <- price[j,i]
        }
      }
    }
    for (i in 1 : companies){
      price_sim[i,count] <- price[i, simulation.length];
    }
    if(count == 1){
      plot(price[1, 1 : simulation.length], xlab="t", ylab="price", ylim = c(price_down_limit_graph, price_up_limit_graph), xlim=c(0, simulation.length), xaxp=c(0, simulation.length,simulation.length/10), type="l", col="black", lwd = 0.10, cex.axis = 0.6, cex.lab = 0.8)
      par(new=T)
      for (i in 1 : companies){
        plot(price[i, 1 : simulation.length], ylim=c(price_down_limit_graph, price_up_limit_graph), xlim=c(0,simulation.length), xlab="", ylab="", axes=FALSE, type="l", col=color[i], lwd = 0.20, cex.axis = 0.6)
        par(new=T)
      }
    }
    else{
      for (i in 1:companies){
        plot(price[i, 1 : simulation.length], ylim=c(price_down_limit_graph, price_up_limit_graph), xlim=c(0,simulation.length), xlab="", ylab="", axes=FALSE, type="l", col=color[i], lwd = 0.20, cex.axis = 0.6)
        par(new=T)
      }
    }
  }
  par(new=T)
  title(main = "Geometric Brownian Motion", col.main="black", font.main=1, cex.main = 0.8)
  #legend(1,8000, c("mu = 0.7,  sigma = 0.5"), cex=0.8, col=c("black"), pch=1, lty=1);

  call_premium <- numeric(companies);
  put_premium <- numeric(companies);
  for(i in 1 : companies){
    for(count in 1 : monte_carlo){
      if((price_sim[i,count] - K[i]) <= 0){
        call_premium[i] <- call_premium[i] + 0
      }
      else{
        call_premium[i] <- call_premium[i] + price_sim[i,count]
      }
    }
    call_premium[i] <- call_premium[i] / monte_carlo;
  }
  for(i in 1:companies){
    for(count in 1 : monte_carlo){
      if((K[i] - price_sim[i,count]) <= 0){
        put_premium[i] <- put_premium[i] + 0;
      }
      else{
        put_premium[i] <- put_premium[i] + price_sim[i,count]
      }
    }
    put_premium[i] <- put_premium[i] / monte_carlo;
  }
  print("Call Option Price:")
  print(call_premium)
  print("Put Option Price:")
  print(put_premium)
  names(call_premium) <- "Call Option Price"
  names(put_premium) <- "Put Option Price"
  premium <- list(call_premium,put_premium)
  return (invisible(premium))
}
