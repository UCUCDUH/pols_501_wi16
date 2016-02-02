library("dplyr")
library("ggplot2")
mu <- 0
sigma <- 1
n <- 32
confidence <- 95
iter <- 1000

# Investigate
results <- list()
for (i in 1:iter) {
  x <- rnorm(n, mean = mu, sd = sigma)
  stat <- mean(x)
  results[[i]] <- data_frame(i = i,
                             stat = mean(x))
}
results <- bind_rows(results) 
# try n = 2, 8, 16, 32, 512, 1024


iter <- 4096
sample_sizes <- 2^(0:10)
results <- list()
for (k in seq_along(sample_sizes))  {
  cat("sample size:", sample_sizes[k], "\n")
  sampling_dist <- list()
  n <- sample_sizes[k]
  for (i in 1:iter) {
    # Normal distribution. mean = 0, sd = 1. mean = 0
    x <- rnorm(n)
    # Uniform distribution: min = 0, max = 1. mean = 0.5
    # x <- runif(n)
    # Geometric distribution: prob = 0.25. mean = 4
    # x <- rgeom(n, prob = 0.25)
    # Beta distribution. Bimodal. mean = 0.5.
    # x <- rbeta(n, shape1 = 0.25, shape2 = 0.25)
    
    # Statistics
    stat <- mean(x)
    #     stat <- median(x)
    #     stat <- max(x)
    #     stat <- var(x)
    sampling_dist[[i]] <- data_frame(size = n,
                                     stat = stat)
  }
  results[[k]] <- bind_rows(sampling_dist)
}
results <- bind_rows(results) %>% mutate(size = factor(size))

ggplot(results, aes(x = stat, colour = size)) + geom_density()

ggplot(results, aes(sample = stat)) +
  facet_wrap(~ size, ncol = 2, scales = "free_y") +
  stat_qq()

## Comparing mean and sample distributions of multiple samples
iter <- 4096
sample_sizes <- 2^(0:12)
results <- list()
for (k in seq_along(sample_sizes))  {
  cat("sample size:", 2^k, "\n")
  stat <- rep(NA, iter)
  for (i in 1:iter) {
    x <- rnorm(sample_sizes[k], mean = mu, sd = sigma)
    # Edit this
    stat[i] <- mean(x)
  }
  results[[k]] <- data_frame(size = sample_sizes[k],
                             x_mean = mean(stat),
                             s = sd(stat),
                             x_mean_se = s / sqrt(iter),
                             s_se = s / sqrt(2 * (iter - 1)))
}
results <- bind_rows(results)


## Confidence Intervals

# calculate z critical value
alpha <- 1 - (confidence / 100)
z <- -qnorm(alpha / 2)
results <- list()
for (i in 1:iter) {
  x <- rnorm(n, mu, sigma)
  x_mean <- mean(x)
  s <- sd(x)
  se <- sd(x) / sqrt(n)
  lb <- x_mean - z * se
  ub <- x_mean + z * se
  contains <- (mu > lb) & (mu < ub)
  results[[i]] <- data_frame(x_mean = x_mean,
                             s = s,
                             se = se,
                             lb = lb,
                             ub = ub,
                             contains = contains)
}
results <- bind_rows(results)

# calculate z critical value
alpha <- 1 - (confidence / 100)
z <- -qnorm(alpha / 2)
results <- list()
for (i in 1:iter) {
  x <- rnorm(n, mu, sigma)
  x_mean <- mean(x)
  s <- sd(x)
  se <- sd(x) / sqrt(n)
  lb <- x_mean - z * se
  ub <- x_mean + z * se
  contains <- (mu > lb) & (mu < ub)
  results[[i]] <- data_frame(x_mean = x_mean,
                             s = s,
                             se = se,
                             lb = lb,
                             ub = ub,
                             x_mean_se = s / sqrt(iter),
                             s_se = s / sqrt(2 * (iter - 1)),
                             contains = contains)
}
results <- bind_rows(results)

mean_ci <- function(n, mu = 0, sigma = 1, iter = 2^10) {
  # calculate z critical value
  alpha <- 1 - (confidence / 100)
  z <- -qnorm(alpha / 2)
  results <- list()
  for (i in 1:iter) {
    x <- rnorm(n, mu, sigma)
    x_mean <- mean(x)
    s <- sd(x)
    se <- sd(x) / sqrt(n)
    lb <- x_mean - z * se
    ub <- x_mean + z * se
    contains <- (mu > lb) & (mu < ub)
    results[[i]] <- data_frame(x_mean = x_mean,
                               s = s,
                               se = se,
                               lb = lb,
                               ub = ub,
                               x_mean_se = s / sqrt(iter),
                               s_se = s / sqrt(2 * (iter - 1)),
                               contains = contains)
  }
  results <- bind_rows(results)
}
