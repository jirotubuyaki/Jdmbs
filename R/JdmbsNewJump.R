library(ggplot2)
#' A Monte Carlo Option Pricing Algorithm for Jump Diffusion Model with Correlational Companies
#' @import utils
#' @import graphics
#' @import stats
#' @import  ggplot2
#' @param  correlation_matrix : a matrix of a correlation coefficient of companies
#' @param  day : an integer of a time duration of simulation.
#' @param  monte_carlo : an integer of an iteration number for monte carlo.
#' @param  start_price : a vector of company's initial stock prices.
#' @param  mu : a vector of drift parameters of geometric Brownian motion.
#' @param  sigma : a vector of volatility parameters of geometric Brownian motion.
#' @param  lambda : an integer of how many times jump in unit time.
#' @param  K : a vector of option strike prices.
#' @param plot : a logical type of whether plot a result or not.
#' @return option prices : a list of (call_price, put_price)
#' @examples
#' price <- jdm_new_bs(matrix(c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9),nrow=3, ncol=3),
#'                     day=100,monte_carlo=20, c(1000,500,500),
#'                     c(0.002, 0.012, 0.005),c(0.05,0.05,0.06), 3,
#'                     c(1500,1000,700),plot=TRUE
#'                    )
#' @export
jdm_new_bs<- function(correlation_matrix, day=180, monte_carlo=1000, start_price=start_price, mu=mu,sigma=sigma, lambda=lambda, K=K,plot=TRUE) {

 if(is.numeric(day) == FALSE){
    #print("Error: Input simulation.time type is not integer.")
    return(FALSE)
  }
  if(day <= 0){
    #print("Error: Input simulation.time is less than or equal to zero.")
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
  if(is.logical(plot) == FALSE){
    print("Error: Input plot type is not logical.")
    return(FALSE)
  }
  
  dt <- 1 / 365 #Now Thinking.

  company_number <- length(start_price)
  t <- seq(0, day * dt, dt)
  price_end <-array(0,c(company_number, monte_carlo));
  price <- array(0,c(company_number, monte_carlo, day + 1))
  dW <- 0
  W <- 0
  lambda <- lambda / (day * dt)
  jump_time <- array(0, c(monte_carlo, monte_carlo * day))
  jump_company_id <- c(0)
  data_jump <- matrix(0, nrow= monte_carlo * day, ncol=3)
  count <- 1
  jump_count <- 1
  jump_flag <- "off"

  for(j in 1 : monte_carlo){
    jump_count <- 1
    jump_time <- array(0, c(monte_carlo, monte_carlo * day))
    jump_company_id <- c(0)
    while(jump_time[j, jump_count] < t[length(t)]){
      # http://preshing.com/20111007/how-to-generate-random-timings-for-a-poisson-process/ from The Art of Computer Programming
      jump_company_id[jump_count] <- as.integer(runif(1,min=1,max=company_number+1))
      jump_time[j, jump_count + 1] <- jump_time[j, jump_count] - log(1 - runif(1,min=0,max=1)) / lambda
      jump_count <- jump_count + 1
    }
    for(i in 1 : company_number){
      W <- 0
      J <- 1
      jump_count <- 2
      price[i, j, 1] <- start_price[i]
      for(k in 1 : day+1){
        # W2 - W1 = N(mean=0, sd = 2 - 1)
        dW <- rnorm(1, mean = 0, sd = 1)
        W <- W + dW
        if(jump_time[j, jump_count] <= t[k]){
          jump_rate <- runif(1, min = -1, max = 1)
          if(jump_rate == 0){
            jump_rate <- 0.0001
          }
          J <- J * (jump_rate * correlation_matrix[jump_company_id[jump_count], i] + 1)
          jump_flag <- "on"
        }
        # about Geometric Brownian Motion from Wikipedia ( https://en.wikipedia.org/wiki/Geometric_Brownian_motion )
        price[i, j, k] <- start_price[i] * exp((mu[i] - ((sigma[i] ^ 2) / 2)) * t[k]  + sigma[i] * W) * J
        if(jump_flag == "on"){
          data_jump[count, 1] <- k - 1
          data_jump[count, 2] <- price[i, j, k]
          data_jump[count, 3] <- i
          count <- count + 1
          jump_count <- jump_count + 1
          jump_flag = "off"
        }
      }
    }
  }
  for(i in 1 : company_number){
    for(j in 1 : monte_carlo){
      price_end[i, j] <- price[i, j, day + 1]
    }
  }
  if(plot == TRUE){
    jump_number <- count
    data_matrix <- matrix(0, nrow=day + 1, ncol = 1)
    count <- 1
    g <- ggplot()
    for(i in 1 : company_number){
      for(j in 1 : monte_carlo){
        for(k in 1 : day + 1){
          data_matrix[k, 1] <- price[i ,j ,k]
        }
        data_f <- data.frame(day= 0:day, price=price[i, j , ] ,Group=rep(i, day + 1))
        g <- g + layer(data=data_f, 
                       mapping=aes(x= day, y=price,colour=factor(Group)), 
                       geom="line", 
                       stat="identity", 
                       position="identity",
                      )
        g$layers[[count]]$aes_params$size <- 0.1
        count <- count + 1
        g <- g + layer(data=data_f, 
                       mapping=aes(x=day , y=price,colour=factor(Group)), 
                       geom="point", 
                       stat="identity", 
                       position="identity",
                      )
        g$layers[[count]]$aes_params$size <- 0.1
        count <- count + 1
      }
    }
    data_jump_f <- data.frame(day=data_jump[1 : jump_number - 1 , 1], price=data_jump[1 : jump_number -1 , 2], Group= factor(data_jump[1 : jump_number - 1 , 3]))
    g <- g + layer(data=data_jump_f, 
                   mapping=aes(x=day, y=price, colour=Group), 
                   geom="point", 
                   stat="identity", 
                   position="identity",
                  )
    g$layers[[count]]$aes_params$size <- 2
    count <- count + 1
    data_K_f <- data.frame(day=rep(day,company_number), K=K, Group= 1:company_number)
    g <- g + layer(data=data_K_f, 
                   mapping=aes(x=day, y=K, colour=factor(Group)), 
                   geom="point", 
                   stat="identity", 
                   position="identity",
    )
    g$layers[[count]]$aes_params$shape <- 15
    g$layers[[count]]$aes_params$size <- 3.5
    plot(g)
  }
  call_price <- array(0,c(company_number));
  put_price <- array(0,c(company_number));
  for(i in 1 : company_number){
    for(j in 1 : monte_carlo){
      if((price_end[i, j] - K[i]) <= 0){
        call_price[i] <- call_price[i] + 0
      }
      else{
        call_price[i] <- call_price[i] + (price_end[i, j] - K[i])
      }
    }
    call_price[i] <- call_price[i] / monte_carlo;
  }
  for(i in 1:company_number){
    for(j in 1 : monte_carlo){
      if((K[i] - price_end[i, j]) <= 0){
        put_price[i] <- put_price[i] + 0;
      }
      else{
        put_price[i] <- put_price[i] + (K[i] - price_end[i ,j])
      }
    }
    put_price[i] <- put_price[i] / monte_carlo;
  }
  name <- NULL
  for(i in 1 : company_number){
    name <- c(name, paste("option_", i))
  }
  names(call_price) <- name
  names(put_price) <- name
  print(call_price)
  print("Put Option Price:")
  print(put_price)
  names(call_price) <- "Call Option Price"
  names(put_price) <- "Put Option Price"
  price <- list(call_price,put_price)
  return (invisible(price))
}
