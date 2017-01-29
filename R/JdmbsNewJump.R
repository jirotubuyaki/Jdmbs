#' Monte Carlo Option Pricing Algorithm for Jump Diffusion Model with Correlation Companies
#' @import utils
#' @import graphics
#' @import stats
#' @import rmarkdown
#' @param  companies_data is a correlation coefficients of companies in “data.csv” file.
#' @param  companies is a j of simulate companies.
#' @param  simulation.length is a duration of simulation.
#' @param  monte_carlo is a iteration j of monte carlo.
#' @param  start_price is a vector of initial price of j stock prices.
#' @param  mu is a vector of parameters of geometric brown motions.
#' @param  sigma is a voctor of parameters of geometric brown motions.
#' @param  event_times is somethings happen how many times in Unit time.
#' @param  K is a vector of option execution prices.
#' @param  color is a vector of colors in plot.
#' @return premium of a list with (call_premium, put_premium)
#' @examples
#' jdm_new_bs(matrix(c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9), nrow=3, ncol=3),
#' 3, simulation.length=100,monte_carlo=80, c(1000,500,500), c(0.005, 0.025, 0.01),
#' c(0.08,0.04,0.06), 3,c(2500,3000,1500), c("red","blue","green"))
#' @export
jdm_new_bs<- function(companies_data, companies, simulation.length=180, monte_carlo=1000, start_price, mu, sigma, event_times, K, color) {
  price_sim <-array(0, c(companies, monte_carlo));
  price <- array(0, c(companies, simulation.length))
  premium <- c()
  price_up_limit_graph <- 0;
  price_down_limit_graph <- 0;
  dW <- array(0, c(companies))
  W <- array(0, c(companies))
  J <- array(0, c(companies))
  J_affect <- array(0, c(companies))
  jump_time <- c(0)
  jump_count <- 1
  jump_flag <- "off"

  for(count in 1 : monte_carlo){
    jump_time <- c(0)
    jump_company_id <- c(0)
    jump_count <- 1
    J <- array(0, c(companies))
    J_affect <- array(0, c(companies))
    # somethings happen 3times in 100 mins. lambda = 3 / 100
    lambda = event_times / simulation.length
    while(jump_time[jump_count] < simulation.length){
      # http://preshing.com/20111007/how-to-generate-random-timings-for-a-poisson-process/ from The Art of Computer Programming
      jump_time[jump_count + 1] = jump_time[jump_count] - log(1 - runif(1,min=0,max=1)) / lambda
      # which company occur jump. this company's jump affect other companies. company id is memorize.
      jump_company_id[jump_count + 1] <- as.integer(runif(1,min=1,max=companies+1))
      J[jump_count+ 1] <- runif(1,min=0,max=1) * rnorm(1, mean = 0, sd = 1)
      jump_count <- jump_count + 1
    }
    # jump_count <- 2 because jump_time[1] = 0. So start from "2"
    jump_count <- 2
    for(i in 2 : simulation.length){
      for(j in 1 : companies){
        if(i == 2){
          W[j] <- 0
          price[j,1] <- start_price[j]
        }
        if(jump_time[jump_count] <= i){
          print(jump_company_id[jump_count])
          print(j)
          print(companies_data[jump_company_id[jump_count],j])
          J_affect[j] <- J_affect[j] + J[jump_count] * companies_data[jump_company_id[jump_count],j]
          jump_flag = "on"
        }
        # W2 - W1 = N(mean=0, sd = 2 - 1)
        dW[j] <- rnorm(1, mean = 0, sd = 1)
        W[j] <- W[j] + dW[j]
        # about Geometric Brownian Motion from Wikipedia ( https://en.wikipedia.org/wiki/Geometric_Brownian_motion )
        price[j,i] <- start_price[j] * exp((mu[j] - (sigma[j] ^ 2) / 2) * (i - 1)  + sigma[j] * W[j] + J_affect[j])
        if(price[j,i] > price_up_limit_graph){
          price_up_limit_graph <- price[j,i]
        }
        if(price[j,i] < price_down_limit_graph){
          price_down_limit_graph <- price[j,i]
        }
      }
      if(jump_flag == "on"){
        jump_count <- jump_count + 1
        jump_flag = "off"
      }
    }
    for (i in 1 : companies){
      price_sim[i,count] <- price[i, simulation.length];
    }
    if(count == 1){
      plot(price[1, 1 : simulation.length], xlab="t", ylab="price", ylim = c(price_down_limit_graph, price_up_limit_graph), xlim=c(0, simulation.length), xaxp=c(0, simulation.length,simulation.length/10), type="l", col="black", lwd = 0.10, cex.axis = 0.6, cex.lab = 0.8)
      par(new=T)
      plot(x = jump_time, y = 1:length(jump_time), type = "s", xlim = c(0, simulation.length),axes=FALSE,lwd = 0.10,xlab="",ylab="")
      par(new=T)
      for (i in 1 : companies){
        plot(price[i, 1 : simulation.length], ylim=c(price_down_limit_graph, price_up_limit_graph), xlim=c(0,simulation.length), xlab="", ylab="", axes=FALSE, type="l", col=color[i], lwd = 0.20, cex.axis = 0.6)
        par(new=T)
      }
    }
    else{
      plot(x = jump_time, y = 1:length(jump_time), type = "s", xlim = c(0, simulation.length),axes=FALSE,lwd = 0.10,xlab="",ylab="")
      par(new=T)
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
