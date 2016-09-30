## JDM-BS: An R package for A Monte Carlo Option Pricingm Algorithm for Jump Diffusion Modelnwith Correlation Companies

### Abstract  
Black-Scholes model is important to calcurate option premium in stock market. And variety of jump diffusion model as
time-series of stock price are studied. In this paper, we propose new jumps diffusion model with corelational companies in
order to culculate option pricing in a stock market. This model express corelation of companies as directed graph structure
have a weight of corelation coeffect among companies. And calcurate option premiums together. Then we exhibit monte-
carlo algorithm of proposed model. After simulate this model comparing with standard jump model and chang parameters,
we discuss effectiveness of it.  

### Introduction
In the early 1970's, Black-Scholes model(Black and Scholes[1973]) is proposed. this model can calculate an option price as market transactions of derivatives. Black-Scholes model express time-series of stock price as geometric brown motion in stochastic differential equation. option premium is culcurated from exercise price and time duration of option and geometric brown motion under risk-neutral probability. Appearance of Black-Scholes model expanded and grew option market at a rapid pace. For the achievement, Scholes and Marton won the novel prize.\newline
But BS model does not represent all aspects of characterristics of a real market. And expansion of BS model is studied and proposed variety of models. Especially time-series of a stock price exhibits phenomenons like a price jump. And in order to modeling it, Jump Diffusion Model(Merton[1975]) using Poison Process to express jump phenomenons is proposed. \newline
In this paper, I propose Corelational Jumps Model which have corelation of companies in stock price. A jump phenomeno of one company affect jumps of other corelational companies obeying correlation coefficients among companies. And it can culculate premiums of the companies together. In chapter 3, a dircted graph of corelational companies algorithm expain. then in chapter 4, we simulate a proposed mode and expain its algorithm.  

### Background
#### Black Scholes model
There are several types of options in the stock market. Eropean call option can not excuse in duration of *T* and its excusion price is *K*. Optin premium is calcurated under a risk-neutral probability. Eropean call option preminum is given by  

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_1.png "eque")

$E[x]$ express expected value of *x*. And Eropean put option premium is given by  

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_2.png "eque")

Black-Schole model is given by  

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_3.png "eque")

where *μ* present a draft parameter. it is a trend int the stock price.  And *σ* is volatility. *r* is is the risk-free interest rate.*N* is gauss distribution.  
#### Poison Process
The Poisson Process present random phenomenons happend as time sequence. It is widely used to model random points in time and space. Poison process is given by    
  
![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_4.png "eque")

where *λ* is the arrival intensity. *k* is a number something happen.
#### The Mixed-Exponential Jump Diffusion Model  
Under the mixed-exponential jump diffusion model (MEM), the dynamics of the asset price St
under a risk-neutral measure1 P to be used for option pricing is given by

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_5.png "eque")

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_6.png "eque")

where *r* is the risk-free interest rate, $\sigma$ the volatility, *{N(t):t =0・・・}* a Poisson process with rate *λ*, *{W(t):t=0・・・}* a standard Brownian motion.  
