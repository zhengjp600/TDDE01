# Don't forget to setwd 
set.seed(12345)


## Task 1
# Read in data and factorize target column
data <- read.csv("optdigits.csv")
data[, 65] <- as.factor(data[, 65])

# Rename the target column to Y for easier referencing
library(dplyr)
data <- rename(data, Y=X0.26)

# Divide the data
N <- nrow(data)
ids <- 1:N

# Sample training data
ids.train <- sample(ids, floor(N * .5))
data.train <- data[ids.train, ]
N.train <- length(ids.train)
ids <- setdiff(ids, ids.train) # Remove picked ids

# Sample validation ids
ids.val <- sample(ids, floor(N * .25))
data.val <- data[ids.val, ]
N.val <- length(ids.val)
ids <- setdiff(ids, ids.val) # Remove picked ids

# Use remaining ids for testing
data.test = data[ids,]
N.test <- length(ids)


## Task 2
# Fit a KNN model with K=30 and test it on the training data
library(kknn)
model.train <- kknn(data.train$Y ~ ., data.train, data.train, k = 30, kernel = "rectangular")
cm.train <- table(data.train$Y, model.train$fitted.values)
miss.train <- (N.train - sum(diag(cm.train))) / N.train
quality.train <- sapply(1:10, FUN = function(c) { cm.train[c,c] / sum(cm.train[,c]) })

# Fit another KNN model with K=30 but test it on the test data
model.test <- kknn(data.train$Y ~ ., data.train, data.test, k = 30, kernel = "rectangular")
cm.test <- table(data.test$Y, model.test$fitted.values)
miss.test <- (N.test - sum(diag(cm.test))) / N.test
quality.test <- sapply(1:10, FUN = function(c) { cm.test[c,c] / sum(cm.test[,c]) })


## Task 3
# All instances with true target 8 in the training data
eights <- data.train[which(data.train$Y == 8),]

# Fit another model and test it only on the eights. 
# Save the resulting probabilities in a column p.
model.eights <- kknn(data.train$Y ~ ., data.train, eights, k = 30, kernel = "rectangular")
eights$p <- model.eights$prob[,9]

# Sort the instances based on their probability
eights.sorted <- eights[order(eights$p, decreasing = T),]

# Generate matrices and heatmaps for two highest and the three lowest probabilities
eights.indices <- c(1, 2, nrow(eights), nrow(eights) - 1, nrow(eights) - 2)
for (i in eights.indices) {
  matrix <- matrix(as.numeric(eights.sorted[i, 1:64]), 8, 8, byrow = T)
  print(sprintf("Heatmap for instance %s with probability %f", rownames(eights.sorted)[i], eights.sorted[i, 66]))
  png(file=sprintf("heatmap_%d.png", i))
  heatmap <- heatmap(matrix, Rowv = NA, Colv = NA, lab)
  dev.off()
}

  
## Task 4 and cross-entropy computation of Task 5
err.train <- c()
err.val <- c()
err.entropy <- c()
for (k in 1:30) {
  print(sprintf("Training model for k=%d", k))
  # Train and test on training data
  model.train.k <- kknn(data.train$Y ~ ., data.train, data.train, k = k, kernel = "rectangular")
  cm.train.k <- table(data.train$Y, model.train.k$fitted.values)
  err.train <- c(err.train, (N.train - sum(diag(cm.train.k))) / N.train)
    
  # Train on training data and test on validation data
  model.val.k <- kknn(data.train$Y ~ ., data.train, data.val, k = k, kernel = "rectangular")
  cm.val.k <- table(data.val$Y, model.val.k$fitted.values)
  err.val <- c(err.val, (N.val - sum(diag(cm.val.k))) / N.val)
  
  # Cross-entropy error
  log_p_hats <- c()
  for (i in 1:N.val) {
    y <- as.numeric(as.character(data.val$Y[i]))
    p_hat <- model.val.k$prob[i, y + 1]
    log_p_hats <- c(log_p_hats, log(p_hat + 1e-15))
  }
  err.entropy <- c(err.entropy, -sum(log_p_hats))
}

# Data frame containing all errors
errors <- data.frame(err.train, err.val, err.entropy)

# Plot training and validation missclassification rate
png(file="plot_train_val")
plot(x=1:30, y=err.train, col = "blue")
points(x=1:30, y=err.val, col = "orange")
dev.off()

# Optimal K for missclassification rate 
K.miss <- which.min(err.val)

# Train model on training data and test on test data
model.test.opt <- kknn(data.train$Y ~ ., data.train, data.test, k = K.miss, kernel = "rectangular")
cm.test.opt <- table(data.test$Y, model.test.opt$fitted.values)
err.test.opt <- (N.test - sum(diag(cm.test.opt))) / N.test
print(sprintf("Train error for K = %s is %f", K.miss, err.train[K.miss]))
print(sprintf("Validation error for K = %s is %f", K.miss, err.val[K.miss]))
print(sprintf("Test error for K = %s is %f", K.miss, err.test.opt))


## Task 5
# Plot cross-entropy error
png(file="plot_entropy")
plot(x=1:30, y = err.entropy, col = "red")
dev.off()

# Optimal K for cross-entropy error
K.entropy <- which.min(err.entropy)
print(K.entropy)