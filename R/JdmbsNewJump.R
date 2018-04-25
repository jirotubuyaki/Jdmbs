#' A Monte Carlo Option Pricing Algorithm for Jump Diffusion Model with Correlation Companies
#' @param  companies_data : a matrix of a correlation coefficient of companies
#' @param  companies : an integer of company number in order to simulate.
#' @param  simulation.length : an integer of a duration of simulation.
#' @param  monte_carlo : an integer of iterations of monte carlo.
#' @param  start_price : a vector of company's initial stock prices.
#' @param  mu : a vector of drift parameter of geometric Brownian motion.
#' @param  sigma : a vector of volatility parameter of geometric Brownian motion.
#' @param  event_times : an integer of how many times jump in Unit time.
#' @param  jump : a vector of jump parameter.
#' @param  K : a vector of option strike prices.
#' @param  color : a vector of colors in plot.
#' @return option prices : a list of (call_price, put_price)
#' @examples
#' jdm_new_bs(matrix(c(1,0.2,0.3,0.4,1,0.6,0.7,0.8,1), nrow=3, ncol=3),
#' 3, simulation.length=60,monte_carlo=60, c(1000,500,500), c(0.005, 0.025, 0.01),
#' c(0.08,0.04,0.06), 3, c(0.1,0.1,0.1), c(2500,3000,1500), c("red","blue","green"))
#' @export
jdm_new_bs<- function(companies_data, companies, simulation.length=180, monte_carlo=1000, start_price=start_price, mu=mu,sigma=sigma, event_times=event_times, jump=jump, K=K, color=color) {
  if(is.matrix(companies_data) == FALSE){
    print("Error: Input companies type is not matrix.")
    return(FALSE)
  }
  if(is.numeric(companies) == FALSE){
    print("Error: Input companies type is not numeric.")
    return(FALSE)
  }
  if(companies <= 0){
    print("Error: Input companies type is less than or equal to zero.")
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
  if(simulation.length <= 0){
    print("Error: Input monte_carlo is less than or equal to zero.")
    return(FALSE)
  }
  price_sim <-array(0, c(companies, monte_carlo));
  price <- array(0, c(monte_carlo, companies, simulation.length))
  price_up_limit_graph <- 0;
  price_down_limit_graph <- 0;
  dW <- array(0, c(companies))
  W <- array(0, c(companies))
  J <- array(0, c(companies))
  jump_time <- array(0, c(monte_carlo, simulation.length))
  jump_time_count <- array(0, c(monte_carlo))
  jump_count <- 1
  jump_flag <- "off"

  for(count in 1 : monte_carlo){
    jump_count <- 1
    J <- array(0, c(companies))
    J_affect <- array(0, c(companies))
    jump_company_id <- c(0)
    W <- array(0, c(companies))
    # somethings happen 3times in 100 mins. lambda = 3 / 100
    lambda = event_times / simulation.length
    while(jump_time[count, jump_count] < simulation.length){
      # http://preshing.com/20111007/how-to-generate-random-timings-for-a-poisson-process/ from The Art of Computer Programming
      jump_time[count, jump_count + 1] = jump_time[count, jump_count] - log(1 - runif(1,min=0,max=1)) / lambda
      # which company occur jump. this company's jump affect other companies. company id is memorize.
      jump_company_id[jump_count + 1] <- as.integer(runif(1,min=1,max=companies+1))
      J[jump_count+ 1] <- runif(1,min=0,max=1) * rnorm(1, mean = 0, sd = 1)
      jump_count <- jump_count + 1
      jump_time_count[count] <- jump_time_count[count] + 1
    }
    # jump_count <- 2 because jump_time[count, 1] = 0. So start from "2"
    jump_count <- 2
    for(i in 2 : simulation.length){
      for(j in 1 : companies){
        if(i == 2){
          price[count, j, 1] <- start_price[j]
        }
        if(jump_time[count, jump_count] <= i){
          J_affect[j] <- J_affect[j] + J[jump_count] * companies_data[jump_company_id[jump_count],j]
          jump_flag <- "on"
        }
        # W2 - W1 = N(mean=0, sd = 2 - 1)
        dW[j] <- rnorm(1, mean = 0, sd = 1)
        W[j] <- W[j] + dW[j]
        # about Geometric Brownian Motion from Wikipedia ( https://en.wikipedia.org/wiki/Geometric_Brownian_motion )
        price[count, j,i] <- start_price[j] * exp((mu[j] - (sigma[j] ^ 2) / 2) * (i - 1)  + sigma[j] * W[j] + jump[j] * J_affect[j])
        if(price[count, j,i] > price_up_limit_graph){
          price_up_limit_graph <- price[count, j,i]
        }
        if(price[count, j,i] < price_down_limit_graph){
          price_down_limit_graph <- price[count, j,i]
        }
      }
      if(jump_flag == "on"){
        jump_count <- jump_count + 1
        jump_flag = "off"
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
      plot(x = jump_time[count,1:jump_time_count[count]], y = 1 : jump_time_count[count] - 1, type = "s", xlim = c(1, simulation.length),axes=FALSE,lwd = 0.10,xlab="",ylab="")
      par(new=T)
      for (i in 1 : companies){
        plot(price[count, i, ], ylim=c(price_down_limit_graph, price_up_limit_graph), xlim=c(1,simulation.length), xlab="", ylab="", axes=FALSE, type="l", col=color[i], lwd = 0.20, cex.axis = 0.6)
        par(new=T)
      }
    }
    else{
      plot(x = jump_time[count,1:jump_time_count[count]], y = 1 : jump_time_count[count] - 1, type = "s", xlim = c(1, simulation.length),axes=FALSE,lwd = 0.10,xlab="",ylab="")
      par(new=T)
      for (i in 1:companies){
        plot(price[count, i, ], ylim=c(price_down_limit_graph, price_up_limit_graph), xlim=c(1,simulation.length), xlab="", ylab="", axes=FALSE, type="l", col=color[i], lwd = 0.20, cex.axis = 0.6)
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
