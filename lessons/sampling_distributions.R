## ----results='hide',echo=FALSE-------------------------------------------
knitr::opts_chunk$set(cache = TRUE, autodep = TRUE)

## ----message=FALSE-------------------------------------------------------
library("dplyr")
library("ggplot2")
library("tidyr")

## ------------------------------------------------------------------------
n <- 8
mean(rnorm(n))

## ------------------------------------------------------------------------
n <- 8
iter <- 2048
# Investigate
results <- list()
for (i in 1:iter) {
  x <- rnorm(n)
  stat <- mean(x)
  results[[i]] <- data_frame(i = i, stat = mean(x))
}
results <- bind_rows(results)

## ------------------------------------------------------------------------
ggplot(results, aes(x = stat)) +
  geom_density() +
  geom_rug()

## ------------------------------------------------------------------------
sample_sizes <- 2 ^ (0:10)

## ------------------------------------------------------------------------
iter <- 4096

## ------------------------------------------------------------------------
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
    # # Mean
    stat <- mean(x)
    # # Median
    # stat <- median(x)
    # # Maximum
    # stat <- max(x)
    # # Standard deviation
    # stat <-sd(x)
    # # Geometric mean of
    # stat <- exp(mean(log(abs(x))))
    sampling_dist[[i]] <- data_frame(size = n, stat = stat)
  }
  results[[k]] <- bind_rows(sampling_dist)
}
results <- bind_rows(results) %>%
  mutate(size = factor(size))

## ------------------------------------------------------------------------
ggplot(results, aes(x = stat, colour = size)) +
  geom_density()

## ----message=FALSE-------------------------------------------------------
## Comparing mean and sample distributions of multiple samples
iter <- 8192
sample_sizes <- 2 ^ (0:12)
results <- list()
for (k in seq_along(sample_sizes))  {
  n <- sample_sizes[k]
  message("sample size: ", n)
  stat <- rep(NA, iter)
  for (i in 1:iter) {
    # # Normal distribution.
    # # mean = 0, sd = 1
    x <- rnorm(n)
    
    # # Uniform distribution:
    # # min = 0, max = 1, mean = 0.5, sd = 0.2887
    # x <- runif(n)
    
    # # Geometric distribution: prob = 0.25.
    # # mean = (1 - p) / p = 3
    # # var = (1 - p) / p ^ 2 = 12
    # # sd = sqrt(12)
    # x <- rgeom(n, prob = 0.25)
    
    # # Beta distribution. Bimodal.
    # # mean = 0.5. sd = 0.4082
    # x <- rbeta(n, shape1 = 0.5, shape2 = 0.5)

    # # Bernoulli distribution.
    # # mean = 0.2. sd = sqrt(0.2 * 0.8)
    # x <- rbinom(n, size = 1, prob = 0.2)
    
    stat[i] <- mean(x)
  }
  results[[k]] <- data_frame(stat = stat, size = n)

}
results <- bind_rows(results)

results_summary <- results %>%
  group_by(size) %>%
  summarize(x_mean = mean(stat),
            s = sd(stat),
            x_mean_se = s / sqrt(iter),
            s_se = s / sqrt(2 * (iter - 1)))

## ------------------------------------------------------------------------
mu <- 0
sigma <- 1

## ------------------------------------------------------------------------
ggplot(results_summary, aes(x = size, y = x_mean, 
                    ymin = x_mean - 2 * x_mean_se,
                    ymax = x_mean + 2 * x_mean_se)) +
  geom_pointrange() +
  geom_hline(yintercept = mu) +
  scale_x_log10()

## ------------------------------------------------------------------------
ggplot(results_summary, aes(x = size,
                    y = s, 
                    ymin = s - 2 * s_se,
                    ymax = s + 2 * s_se)) +
  geom_pointrange() +
  stat_function(fun = function(n) sigma / sqrt(n)) +
  scale_x_log10()

## ----fig.height = 8------------------------------------------------------
ggplot(mutate(results,
              normal = dnorm(stat, mean = mu, sd = sigma / sqrt(size))),
       aes(x = stat)) +
  geom_density() +
  geom_rug() +
  geom_line(mapping = aes(y = normal), col = "red") +
  facet_wrap(~size, ncol = 2, scales = "free")

## ------------------------------------------------------------------------
prob <- 0.2
sizes <- c(1, 2, 8, 32, 64, 256, 512, 1024)

binomial <- list()
for (i in seq_along(sizes)) {
  n <- sizes[i]
  binomial[[i]] <- data_frame(x = 0:n,
                              size = n,
                              p = dbinom(x, size = n, prob = prob))
}
binomial <- bind_rows(binomial)

normal <- list()
for (i in seq_along(sizes)) {
  n <- sizes[i]
  normal_mean <- n * prob
  normal_sd <- sqrt(n * prob * (1 - prob))
  normal[[i]] <- data_frame(x = seq(normal_mean - 3 * normal_sd,
                                    normal_mean + 3 * normal_sd, 
                                    length.out = 101),
                            y = dnorm(x, mean = normal_mean, sd = normal_sd),
                            size = n)
}
normal <- bind_rows(normal)

ggplot() +
  geom_bar(data = binomial, aes(x = x, y = p), stat = "identity",
           alpha = 0.5) +
  geom_line(data = normal, aes(x = x, y = y), color = "black", size = 1) +
  facet_wrap(~size, ncol = 2, scales = "free")

## ------------------------------------------------------------------------
confidence <- 95
mu <- 0
sigma <- 1

## ------------------------------------------------------------------------
iter = 500
# calculate z critical value
alpha <- 1 - (confidence / 100)
z <- -qnorm(alpha / 2)
results <- list()
for (i in 1:iter) {
  x <- rnorm(n, mean = mu, sd = sigma)
  x_mean <- mean(x)
  se <- sigma / sqrt(n)
  lb <- x_mean - z * se
  ub <- x_mean + z * se
  contains_mu <- (mu > lb) & (mu < ub)
  results[[i]] <- data_frame(x_mean = x_mean,
                             se = se,
                             lb = lb,
                             ub = ub,
                             contains_mu = contains_mu,
                             i = i)
}
results <- bind_rows(results)

## ------------------------------------------------------------------------
summarize(results, prop_contain_mu = sum(contains_mu) / n())

## ----fig.height = 7------------------------------------------------------
ggplot(results, aes(y = x_mean, ymin = lb, ymax = ub, x = i, color = contains_mu)) +
  geom_hline(yintercept = 0) + 
  geom_pointrange(size = rel(0.25)) +
  coord_flip() +
  scale_color_manual(values = c("TRUE" = alpha("black", 0.67), "FALSE" = "red")) +
  theme_bw() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank())


## ------------------------------------------------------------------------
contains_x_mean <- rep(NA, nrow(results))
for (i in 1:nrow(results)) {
  x_mean_i <- results[i, ][["x_mean"]]
  contains_x_mean[i] <- 
    (sum(results$lb < x_mean_i & results$ub > x_mean_i) - 1) / (nrow(results) - 1)
}
summary(contains_x_mean)

## ------------------------------------------------------------------------
confidence <- 95
n <- 30
mu <- 0
sigma <- 1
iter = 500

## ------------------------------------------------------------------------
# calculate z critical value
alpha <- 1 - (confidence / 100)
# crit_val <- -qnorm(alpha / 2)
crit_val <- -qt(alpha / 2, df = n - 1)
results <- list()
for (i in 1:iter) {
  x <- rnorm(n, mean = mu, sd = sigma)
  x_mean <- mean(x)
  s <- sd(x)
  se <- s / sqrt(n)
  lb <- x_mean - z * se
  ub <- x_mean + z * se
  contains_mu <- (mu > lb) & (mu < ub)
  results[[i]] <- data_frame(x_mean = x_mean,
                             s = s,
                             se = se,
                             lb = lb,
                             ub = ub,
                             contains_mu = contains_mu,
                             i = i)
}
results <- bind_rows(results)

## ------------------------------------------------------------------------
summarize(results, prop_contain_mu = sum(contains_mu) / n())

## ----fig.height = 8------------------------------------------------------
ggplot(results, aes(y = x_mean, ymin = lb, ymax = ub, x = i, color = contains_mu)) +
  geom_hline(yintercept = 0) + 
  geom_pointrange(size = rel(0.25)) +
  coord_flip() +
  scale_color_manual(values = c("TRUE" = alpha("black", 0.67), "FALSE" = "red")) +
  theme_bw() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank())


## ------------------------------------------------------------------------
ggplot(results, aes(x = s)) +
  geom_density() +
  geom_rug()

## ------------------------------------------------------------------------
confidence <- 95
mu <- 0
sigma <- 1
iter = 2048
sample_sizes <- 3:100
# calculate z critical value
alpha <- 1 - (confidence / 100)

results <- list()
for (i in seq_along(sample_sizes)) {
  n <- sample_sizes[i]
  norm_critical_value <- -qnorm(alpha / 2)
  t_critical_value <- -qt(alpha / 2, df = n - 1)
  norm_contains_mu <- rep(NA, iter)
  t_contains_mu <- rep(NA, iter)
  for (j in 1:iter) {
    
    # Sample from the normal distribution 
    x <- rnorm(n, mean = mu, sd = sigma)
    x_mean <- mean(x)
    s <- sd(x)
    se <- s / sqrt(n)
    z <- (x_mean - mu) / se
    norm_contains_mu[j] <- abs(z) < norm_critical_value
    t_contains_mu[j] <- abs(z) < t_critical_value
  }
  results[[i]] <-
    data_frame(n = n, 
               `Normal` = sum(norm_contains_mu) / iter,
               `Student's t` = sum(t_contains_mu) / iter)
}
results <- bind_rows(results) %>%
  gather(se_type, contains_mu, -n)


## ------------------------------------------------------------------------
ggplot(results, aes(x = n, y = contains_mu, color = se_type)) +
  geom_point() +
  geom_line() + 
  geom_hline(yintercept = 1 - alpha) +
  xlab("Sample size") +
  ylab(expression(paste("Prop intervals containing ", mu))) +
  scale_color_discrete("")

## ------------------------------------------------------------------------
confidence <- 95
prob <- 0.1
iter = 2048
sample_sizes <- 3:100

# mean of geom is (1 - p) / p
mu <- (1 - prob) / prob
alpha <- 1 - (confidence / 100)
results <- list()
for (i in seq_along(sample_sizes)) {
  n <- sample_sizes[i]
  norm_critical_value <- -qnorm(alpha / 2)
  t_critical_value <- -qt(alpha / 2, df = n - 1)
  norm_contains_mu <- rep(NA, iter)
  t_contains_mu <- rep(NA, iter)
  for (j in 1:iter) {
    x <- rgeom(n, prob = prob)
    x_mean <- mean(x)
    s <- sd(x)
    se <- s / sqrt(n)
    z <- (x_mean - mu) / se
    norm_contains_mu[j] <- abs(z) < norm_critical_value
    t_contains_mu[j] <- abs(z) < t_critical_value
  }
  results[[i]] <-
    data_frame(n = n, 
               `Normal` = sum(norm_contains_mu) / iter,
               `Student's t` = sum(t_contains_mu) / iter)
}
results <- bind_rows(results) %>%
  gather(se_type, contains_mu, -n)


## ------------------------------------------------------------------------
ggplot(results, aes(x = n, y = contains_mu, color = se_type)) +
  geom_point() +
  geom_line() + 
  geom_hline(yintercept = 1 - alpha) +
  xlab("Sample size") +
  ylab(expression(paste("Prop intervals containing ", mu))) +
  scale_color_discrete("")

