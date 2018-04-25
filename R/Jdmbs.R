#' A Normal Monte Carlo Option Pricing Algorithm
#' @import utils
#' @import graphics
#' @import stats
#' @importFrom igraph graph.data.frame reciprocity dyad.census is.mutual E
#' @import rmarkdown
#' @param  companies : an integer of a company number in order to simulate.
#' @param  simulation.length : an integer of a time duration of simulation.
#' @param  monte_carlo : an integer of an iteration number for monte carlo.
#' @param  start_price : a vector of company's initial stock prices.
#' @param  mu : a vector of drift parameters of geometric Brownian motion.
#' @param  sigma : a vector of volatility parameters of geometric Brownian motion.
#' @param  K : a vector of option strike prices.
#' @param  color : a vector of colors in plot.
#' @return option prices : a list of (call_price, put_price)
#' @examples
#' price <- normal_bs(1, simulation.length=50, monte_carlo=1000,1000, 0.007, 0.03, 1500, "blue")
#' @export
normal_bs<- function(companies, simulation.length=180, monte_carlo=1000, start_price=start_price, mu=mu, sigma=sigma, K=K, color=color) {
  if(is.numeric(companies) == FALSE){
    print("Error: Input companies type is not numeric.")
    return(FALSE)
  }
  if(companies <= 0){
    print("Error: Input companies is less than or equal to zero.")
    return(FALSE)
  }
  if(is.numeric(simulation.length) == FALSE){
    print("Error: Input simulation.length type is not integer.")
    return(FALSE)
  }
  if(simulation.length <= 0){
    print("Error: Input simulation.length is less than or equal to zero.")
    return(FALSE)
  }
  if(is.numeric(monte_carlo) == FALSE){
    print("Error: Input monte_carlo type is not integer.")
    return(FALSE)
  }
  if(monte_carlo <= 0){
    print("Error: Input monte_carlo is less than or equal to zero.")
    return(FALSE)
  }
  price_sim <-array(0,c(companies, monte_carlo));
  price <- array(0,c(monte_carlo, companies, simulation.length))
  price_up_limit_graph <- 0
  price_down_limit_graph <- 0
  dW <- array(0,c(companies))
  W <- array(0,c(companies))

  for(count in 1 : monte_carlo){
    W <- array(0,c(companies))
    for(i in 2 : simulation.length){
      for(j in 1 : companies){
        if(i == 2){
          price[count, j, 1] <- start_price[j]
        }
        # W2 - W1 = N(mean=0, sd = 2 - 1)
        dW[j] <- rnorm(1, mean = 0, sd = 1)
        W[j] <- W[j] + dW[j]
        # about Geometric Brownian Motion from Wikipedia ( https://en.wikipedia.org/wiki/Geometric_Brownian_motion )
        price[count, j,i] <- start_price[j] * exp((mu[j] - (sigma[j] ^ 2) / 2) * (i - 1)  + sigma[j] * W[j])
        if(price[count, j,i] > price_up_limit_graph){
          price_up_limit_graph <- price[count, j, i]
        }
        if(price[count, j,i] < price_down_limit_graph){
          price_down_limit_graph <- price[count, j, i]
        }
      }
    }
    for (i in 1 : companies){
      price_sim[i,count] <- price[count, i, simulation.length];
    }
  }
  for(count in 1 : monte_carlo){
    if(count == 1){
      plot(price[count, 1, ], xlab="t", ylab="price", ylim = c(price_down_limit_graph, price_up_limit_graph), xlim=c(1, simulation.length), xaxp=c(0, simulation.length,simulation.length/10), type="l", col="black", lwd = 0.10, cex.axis = 0.6, cex.lab = 0.8)
      par(new=T)
      for (i in 1 : companies){
        plot(price[count, i,], ylim=c(price_down_limit_graph, price_up_limit_graph), xlim=c(0,simulation.length), xlab="", ylab="", axes=FALSE, type="l", col=color[i], lwd = 0.20, cex.axis = 0.6)
        par(new=T)
      }
    }
    else{
      for (i in 1:companies){
        plot(price[count, i,], ylim=c(price_down_limit_graph, price_up_limit_graph), xlim=c(0,simulation.length), xlab="", ylab="", axes=FALSE, type="l", col=color[i], lwd = 0.20, cex.axis = 0.6)
        par(new=T)
      }
    }
  }
  par(new=T)
  title(main = "Geometric Brownian Motion", col.main="black", font.main=1, cex.main = 0.8)
  #legend(1,8000, c("mu = 0.7,  sigma = 0.5"), cex=0.8, col=c("black"), pch=1, lty=1);

  call_price <- array(0,c(companies));
  put_price <- array(0,c(companies));
  for(i in 1 : companies){
    for(count in 1 : monte_carlo){
      if((price_sim[i,count] - K[i]) <= 0){
        call_price[i] <- call_price[i] + 0
      }
      else{
        call_price[i] <- call_price[i] + (price_sim[i,count] - K[i])
      }
    }
    call_price[i] <- call_price[i] / monte_carlo;
  }
  for(i in 1:companies){
    for(count in 1 : monte_carlo){
      if((K[i] - price_sim[i,count]) <= 0){
        put_price[i] <- put_price[i] + 0;
      }
      else{
        put_price[i] <- put_price[i] + (K[i] - price_sim[i,count])
      }
    }
    put_price[i] <- put_price[i] / monte_carlo;
  }
  print("Call Option Price:")
  print(call_price)
  print("Put Option Price:")
  print(put_price)
  names(call_price) <- "Call Option Price"
  names(put_price) <- "Put Option Price"
  price <- list(call_price,put_price)
  return (invisible(price))
}
