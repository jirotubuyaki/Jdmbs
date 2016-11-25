# Jdmbs: An R package for A Monte Carlo Option Pricing Algorithm for Jump Diffusion Model with Correlation Companies


## Abstract
Black-Scholes model is important to calculate option premium in stock market. And variety of jump diffusion model as
time-series of stock price are studied. In this paper, we propose new jumps diffusion model with correlational companies in
order to calculate option pricing in a stock market. This model express correlational of companies as directed graph structure
have a weight of correlational coefficients among companies. And calculate option premiums together. Then we exhibit monte-
carlo algorithm of proposed model. After simulate this model comparing with standard jump model and change parameters,
we discuss effectiveness of it.

## Introduction
In the early 1970's, Black-Scholes model(Black and Scholes[1973]) is proposed. This model can calculate an option price as market transactions of derivatives. Black-Scholes model express time-series of stock price as geometric brown motion in stochastic differential equation. Option premium is calculated from exercise price and time duration of option and geometric brown motion under risk-neutral probability. Appearance of Black-Scholes model expanded and grew option market at a rapid pace. For the achievement, Scholes and Merton won the novel prize.\newline
But BS model does not represent all aspects of characteristics of a real market. And expansion of BS model is studied and proposed variety of models. Especially time-series of a stock price exhibits phenomenons like a price jump. And in order to modeling it, Jump Diffusion Model(Merton[1975]) using Poison Process to express jump phenomenons is proposed. In this paper, I propose Correlational Jumps Model which have correlation of companies in stock price. A jump phenomenon of one company affect jumps of other correlational companies obeying correlation coefficients among companies. And it can calculate premiums of the companies together. In chapter 3, a directed graph of correlational companies algorithm explain. Then in chapter 4, we simulate a proposed mode and explain its algorithm.

## Background
### Black Scholes model
There are several types of options in the stock market. European call option can not excuse in duration of *T* and its execution price is *K*. Option premium is calculated under a risk-neutral probability. European call option premium is given by

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_1.png "eque")

*E[x]* express expected value of *x*. And European put option premium is given by

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_2.png "eque")

Black-Scholes model is given by

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_3.png "eque")

where *μ* present a draft parameter. it is a trend int the stock price.  And *σ* is volatility. *r* is is the risk-free interest rate.*N* is gauss distribution.
### Poison Process
The Poisson Process present random phenomenons happened as time sequence. It is widely used to model random points in time and space. Poison process is given by

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_4.png "eque")

where *λ* is the arrival intensity. *k* is a number something happen.
### The Mixed-Exponential Jump Diffusion Model
Under the mixed-exponential jump diffusion model (MEM), the dynamics of the asset price St
under a risk-neutral measure1 P to be used for option pricing is given by

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_5.png "eque")

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_6.png "eque")

where *r* is the risk-free interest rate, *σ* the volatility, *{N(t):t =0・・・}* a Poisson process with rate *λ*, *{W(t):t=0・・・}* a standard Brownian motion.

## Correlational Jumps Model
Standard Jump Diffusion model occurs jump in one stock market and it does not affect other companies. In correlational Jumps model one jump among companies affects other stock price of a company obeying correlation coefficacies. Therefore equetions are given by

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_7.png "eque")

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_8.png "eque")

![equa](https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/equation_9.png "eque")

Where *random_i* is a *n_th* company. And *U* is discrete uniform distribution.*Output_ij* is a correlation coefficients from *i* company to *j*. it is from result of algorithm 1.

## Correlation Companies Algorithm
In order to calculate correlation coefficients between all pair companies, all paths must be enumerated in graph structure.　And variety of algorithms to find paths are proposed. We propose algorithm for enumeration correlations in
a given circulation graph. This program code produce a matrix of correlation coefficients between all pair companies.
This package includes a Perl program in order to calculate a correlations of companies.
Please change $connect_companies parameters and use like below. output data is "data.csv"

```
> perl path.pl
```
<div>
  <div style="text-align: center">
  <img src="https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/companies.png" height=350px>
  </div>
</div>
Figure 1. a correlations of companies


Table 1: Result for correlation coefficents of companies

| | 1 | 2 | 3 | 4 | 5 | 6 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
1 | 1 | 0.98 | 0.49 | -0.8 | 0.92 | -0.184|
2 | 0.24 | 1 | 0.5 | -0.192 | 0.52 | -0.104|
3 | 0.144 | 0.6 | 1 | -0.1152 | 0.312 | -0.0624|
4 | -0.8 | -0.784 | -0.392 | 1 | -0.736 | 0.1472|
5 | 0.16 | 0.38 | 0.19 | -0.128 | 1 | -0.2 |
6 | -0.032 | -0.076 | -0.038 | 0.0256 | -0.2 | 1 |


## Installation
If download from Github you can use devtools by the commands:

```
> library(devtools)
> install_github("jirotubuyaki/Jdmbs")
```

Once the packages are installed, it needs to be made accessible to the current R session by the commands:

```
> library(Jdmbs)
```

For online help facilities or the details of a particular command (such as the function hmds) you can type:

```
> help(package="Jdmbs")
```
## Method
This package has three method. And it is excused by:

It is normal model for monte carlo:
```
> premium <- normal_bs(companies,simulation.length=180,monte_carlo=1000,start_price,mu,sigma,K,k,col);
```
Jump Diffusion for monte carlo:
```
> premium <- jdm_bs(companies,simulation.length=180,monte_carlo=1000,start_price,mu,sigma,K,k,col);
```
It is a proposed method for monte carlo. data.csv must be required:
```
> premium <- jdm_new_bs(data,companies,simulation.length=180,monte_carlo=1000,start_price,mu,sigma,K,k,col);
```

## Simulation
<div style="text-align: center;">
<img src="https://github.com/jirotubuyaki/JDM-BS/blob/master/readme_images/simulation.png" height="400px"><br>
</div>
Figure 2. stock prices of companies

## Conclusions
New algorithm for option price is described and explain how to use. This package can produce a option price with related companies. And several improvements are planed. Please send suggestions and report bugs to okadaalgorithm@gmail.com.
## Acknowledgments
This activity would not have been possible without the support of my family and friends. To my family, thank you for lots of encouragement for me and inspiring me to follow my dreams. I am especially grateful to my parents, who supported me all aspects.

## References
Black, Scholes, and Merton. 1973. “The Pricing of Options and Corporate Liabilities” 3 Issue 3: 637–54.  Clift, Simon S, and Peter A Forsyth. 2007. “Numerical Solution of Two Asset Jump Diffusion Models forOption Valuation,” 1–44.
