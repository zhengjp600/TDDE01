- [Parameter estimation & Optimization](#parameter-estimation--optimization)
  - [Parametric functions](#parametric-functions)
  - [Loss minimization](#loss-minimization)
    - [Loss minimization: comments](#loss-minimization-comments)
  - [Loss functions](#loss-functions)
    - [Loss functions: classification](#loss-functions-classification)
      - [Ad-hoc loss functions binary classification](#ad-hoc-loss-functions-binary-classification)
      - [Binary to multiclass](#binary-to-multiclass)
  - [Regularization](#regularization)
    - [Explicit regularization](#explicit-regularization)
      - [Explicit regularization: ridge regression](#explicit-regularization-ridge-regression)
    - [Ridge regression](#ridge-regression)
    - [LASSO](#lasso)
    - [LASSO vs Ridge](#lasso-vs-ridge)
    - [LASSO properies](#lasso-properies)
      - [Optimization methods](#optimization-methods)
      - [Gradient descent](#gradient-descent)
      - [Newtonβs method](#newtons-method)
    - [Optimization methods in R](#optimization-methods-in-r)
    - [Implicit regularization](#implicit-regularization)
    - [Optimization for large data](#optimization-for-large-data)
    - [Hyperparameter optimization](#hyperparameter-optimization)
# Parameter estimation & Optimization
## Parametric functions
* General ML model π~π·ππ π‘ππππ’π‘πππ($f_\theta (π),β¦$)
  * Some of them: π~$π_\theta$ (π)+π, π~π·ππ π‘ππππ’π‘πππ(β¦)
  * Generalization of simple models can be done
* `Example`: logistic π~π΅ππππππππ$({1\over1+e^{-\theta^Tx}})$
  * Generalization 1: (basis function expansion): 
  $$
  Y\sim Bernoilli({1\over 1+e^{-\theta^T \phi (x)}})
  $$
  * Generalization 2:
  $$
  Y\sim Bernoilli({1\over 1+e^{-f_\theta(x)}})\\
  f_\theta(x)=||x-\theta||^2
  $$
## Loss minimization
* Given training set π, we want to minimize  
$E_{new}=\int_{(x_*,y_*)E(y_*,\hat{y}(x_*,T,\theta))p(x_*,y_*)dx_*dy_*}$
* We can minimize cost function  
$$
J(\theta)={1\over n}\sum^n_{i=1}L(y_i,\hat{y}(x_i,\theta))
$$
> $E_{new}\approx J(\theta)?$ X
* Optimizing π½(π½) does not lead to optimizing $πΈ_{πππ€}$
  * Overfitting 
### Loss minimization: comments
* Training a model with perfect accuracy unreasonable
  * Statistical noise for finite π
* Loss function can be different from error function
* Some loss functions are not good for training, for ex. misclassification rate
## Loss functions
* Assuming a distribution, `derive as minus log-likelihood:`
* $y\sim Normal(f_\theta(x),\sigma^2)\rightarrow L(y,f_\theta(x))=(y-f_\theta(x))^2$
* Heavy outliers : $y\sim Laplace(f_\theta(x),r)\rightarrow L(y,f_\theta(x))=|y-f_\theta(x)|$
* Count data $y\sim ππππ π ππ(f_\theta (π₯))$  
`Example: `Daily Stock prices NASDAQ
* Open
* High (within day)

1. Try to fit usual linear regression, study histogram of residuals
* If the distribution is difficult to assume / only some properties known$\rightarrow$ ad-hoc loss functions
* **Huber loss**: similar to quadratic but robust to outliers
$$
L(y,\hat{y})\begin{cases}
    {1\over2}(y,\hat{y})^2\quad if\ |y,\hat{y}|<1\\
    |y,\hat{y}|-{1\over2}\quad otherwise
\end{cases}
$$
* **E-intensive loss**
$$
L(y,\hat{y})\begin{cases}
    0\quad if\ |y,\hat{y}|<\epsilon\\
    |y,\hat{y}|-\epsilon\quad otherwise
\end{cases}
$$
### Loss functions: classification
* **Cross-entropy** corresponds to minus log-likelihood:
$$
J(y,\hat{p}(y))=-\sum^n_{i=1}\sum^M_{m=1}I(y_i=C_m)log\hat{p}(y_i=C_m)
$$
* Ad-hoc loss functions binary classification πΆ={β1,1}
  * Assume model returns $π(π): \hat{y}=π πππ(π(π))$
  * `Example`: $logistic\quad f(x)={1\over{1+e^{-\theta^Tx}}}-0.5$
    * Probability of Classify to '1'
* **`Note`**: mistake when $yf(x)=-1$
#### Ad-hoc loss functions binary classification
* **Exponential loss**
$$
L(y\cdot f(x))=exp(-y\cdot f(x))
$$
* **Hinge loss**
$$
L(y\cdot f(x))=\begin{cases}
    1-y\cdot f(x)\quad for\ y\cdot f(x)β€1\\
    0\qquad \qquad  otherwise
\end{cases}
$$
#### Binary to multiclass
* One versus one: class $πΆ_π$ vs class $πΆ_π+$ majority voting from all classifiers
* One versus rest: class $πΆ_π$ vs not $πΆ_π+$ highest probability class
* Comparison: OVO needs less data to train one model but more models.


## Regularization
* $E_{new}\approx J(\theta)?$ β no
* Similar for (moderately) simple models, not similar for too complex model (overfitting).
* [**Explicit regularization**](#explicit-regularization): penalize complexity by changing cost function
* [**Implicit regularization**](#implicit-regularization): **early stopping**
  * If cost function optimized iteratively, donβt let it decrease too much
### Explicit regularization
* Penalize cost function
$$
\min_\theta J(\theta)+\lambda R(\theta)\\
\lambda > 0
$$
* **L1 regularization**:$R(\theta)=\lambda ||\theta||_1$
* **L2 regularization**:$R(\theta)=\lambda ||\theta||_2$
* **`Example`: Ridge regression**
$$
\min_\theta {1\over n}\sum^n_{i=1}(y_i-\theta^Tx_i)^2+\lambda \sum^p_{j=1}\theta_j^2,\quad \lambda>0
$$
#### Explicit regularization: ridge regression
* Equivalent form
$$
\hat{\theta}^{ridge}=\argmin \sum_{i=1}^N(y_i-\theta_0-\theta_1x_{1j}-\dots-\theta_px_{pj})^2\\
subject\quad to \quad\sum_{j=1}^p\theta^2_jβ€s
$$
* Solution
$$
\theta^{ridge}=(X^TX+\lambda I)^{-1}X^Ty
$$
### Ridge regression
Properties
* Extreme cases: 
  * π=0 usual linear regression (no shrinkage(ηΌ©ζ°΄))
  * π=+β fitting a constant (π½=0 except of $\theta_0$)
* Degrees of freedom decrease when π  increases
  * $\lambda=0\rightarrow d.f.=p$
* $p>n$ is doable
  * Compare with linear regression
* How to estimate π?
  * cross-validation 
* R code: use package glmnet with alpha=0 (Ridge regression)
* Seeing how Ridge converges
```R
data=read.csv("machine.csv", header=F)

library(caret)
library(glmnet)
scaler=preProcess(data)
data1=predict(scaler, data)
covariates=data1[,3:8]
response=data1[, 9]

model0=glmnet(as.matrix(covariates), response, alpha=0,family="gaussian")
plot(model0, xvar="lambda", label=TRUE)
```
* Choosing the best model by cross-validation:
```R
model=cv.glmnet(as.matrix(covariates), response, alpha=0,family="gaussian")
model$lambda.min
plot(model)
coef(model, s="lambda.min")
```
* How good is this model in prediction?
```R
covariates=train[,1:6]
response=train[, 7]
model=cv.glmnet(as.matrix(covariates), response, alpha=1,family="gaussian", lambda=seq(0,1,0.001))
y=test[,7]
ynew=predict(model, newx=as.matrix(test[, 1:6]), type="response")

#Coefficient of determination
sum((ynew-mean(y))^2)/sum((y-mean(y))^2)

sum((ynew-y)^2)
```
> Note that data are so small so numbers change much for other train/test
### LASSO
* Add $l_1$ regularization term
$$
\hat{\theta}^{lassp}=\argmin {{1\over n}\sum_{i=1}^N(y_i-\theta_0-\theta_1x_{1j}-\dots-\theta_px_{pj})^2+\lambda\sum_{j=1}^p|\theta_j|}\\

$$
* $\lambda>0$ is **penalty(ζ©η½) factor**
* Equivalent formulation
$$
\hat{\theta}^{lassp}=\argmin \sum_{i=1}^N(y_i-\theta_0-\theta_1x_{1j}-\dots-\theta_px_{pj})^2\\
subject\quad to \quad\sum_{j=1}^p|\theta_j|β€s
$$
### LASSO vs Ridge
* LASSO yields sparse solutions!
* In R, use glmnet with **alpha=1**
* Only 5 variables selected by LASSO
* Why Lasso leads to sparse solutions?
  * Feasible area for Ridge is a circle (2D)
  * Feasible area for LASSO is a polygon (2D)
### LASSO properies
* Lasso is widely used when πβ«π 
  * Linear regression breaks down when π>π
  * Application: DNA sequence analysis, Text Prediction
* No explicit formula for $\hat{\theta}^{πππππ}$
  * Optimization algorithms used
#### Optimization methods
* Numerical optimization often needed
$$
\min_\theta J(\theta)\\
\min_\lambda E_{hold-out}(\lambda)
$$
* If not convex objective, more than one local optimum
* **Gradient descent method**
$$\hat{\theta}=\argmin_\theta J(\theta)$$
* Basic idea:
  * Start from some point $\theta_0$
  * Move to the next point along descent direction -$\nabla_\theta J(\theta)$
#### Gradient descent
* Example: logistic regression
#### Newtonβs method
* Assume π½(π½) is βlocallyβ quadratic
* Newtonβs method: move along the best direction
$$
\theta^{t+1}=\theta^{(t)}-\eta[\nabla^2_\theta J(\theta^{(t)})]^{-1}[\nabla_\theta J(\theta^{(t)})]
$$
* Properties
  * No convergence guarantees
  * Advantage: if π½(π½) is quadratic and π=1 $\rightarrow$ convergence in one iteration
  * `Disadvantage 1`: Hessian must be invertable
  * `Disadvantage 2`: Hessian is computationally heavy
* Solution: quasi-Newton methods (ex. BFGS)
  * Choose some $π»^{(0)}$
  * Approximate the inverse Hessian

### Optimization methods in R
* In R, use optim(par, fn, gr, method,β¦)
  * par: initial parameter vector
  * fn: function to optimize
  * gr: gradient function
method 
> `Example`: trace plot for $π¦=(π₯_1β2)^4+(π₯_2β4)^4$
```R
#Workaround: optim does not return iterations

Fs=list()
Params=list()
k=0

myf<- function(x){ 
  f=(x[1]-2)^4+(x[2]-4)^4
  .GlobalEnv$k= .GlobalEnv$k+1
  .GlobalEnv$Fs[[k]]=f
  .GlobalEnv$Params[[k]]=x
  return(f)
}
myGrad <-function(x) c(4*(x[1]-2)^3, 4*(x[2]-4)^3)

res<-optim(c(0,0), fn=myf, gr=myGrad, method="BFGS")

plot(log(as.numeric(Fs)), type="l", main="Function iterations")
```
### Implicit regularization
* Early stopping
  * For complex models, accurate model optimization may lead to overfitting

  * Start from some parameter set (probably not optimal, large $πΈ_{π‘ππππ}$ and $πΈ_{πππ€}$)
  * Trace the validation error (and training error? ) for each π‘
  * Choose model with the smallest validation error
### Optimization for large data
* Stochastic gradient descent

* Idea: use gradient descent + approximation to expected value
  * For random sample of size π_π from sample of size π
$$
\bar{x}={1\over π} \sum_{π=1}^π{π₯_πβ{1\over π_b}\sum_{π=1}^{π_π}π₯_π}\\
\nabla_\theta π½(\theta)β{1\over π_b}\sum_{(π_π,π¦_π)\in π πππππ}{\nabla_\theta πΏ(π_π, π¦_π, \theta)}
$$
1. One epoch:
   1. Permute data and divide into batches of size $π_π$
   2. In each optimization iteration, use one batch
2. Repeat step 1
### Hyperparameter optimization
* $E_{hold-out}$costly to compute$\rightarrow$usual optimization very hard
  * Note: for each π first we need to optimize πβ¦+ gradients of $E_{hold-out}$
* Grid search (can also be costly)
  * Alternative: Bayesian optimization
