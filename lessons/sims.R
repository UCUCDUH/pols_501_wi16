n <- c(100, 100)
mu <- c(0, 0)
sigma <- c(1, 1)

sim_difference <- function(iter, n, mu = c(0, 0), sigma = c(1, 1), mu_0 = 0) {
  
  iter <- 1000
  results <- list()
  for (i in seq_len(iter)) {
    x1 <- rnorm(n, mean = mu[1], sd = sigma[1])
    x1_mean <- mean(x1)
    x1_s <- sd(x1)
    x1_se <- x1_s / sqrt(n1)
    
    x2 <- rnorm(n, mean = mu[2], sd = sigma[2])
    x2_mean <- mean(x2)
    x2_s <- sd(x2)
    x2_se <- x2_s / sqrt(n2)
    
    xdiff <- x1_mean - x2_mean
    se <- sqrt(x1_s ^ 2 + x2_s ^ 2)
    
    df <- min(n[1], n[2]) - 1
    test_stat <- (xdiff - mu0) / se
    p_value <- pt(test_stat, df = df)
    results[[i]] <-
      data_frame(p_value = p_value,
                 test_stat = test_stat,
                 n1 = n[1],
                 mu1 = mu[1],
                 sigma1 = sigma[1],
                 x1_mean = x1_mean,
                 s1_sd = s1_sd,
                 n2 = n[2],
                 mu2 = mu[2],
                 sigma2 = sigma[2],
                 x2_mean = x2_mean,
                 x2_sd = x2_sd,
                 df = df)    
  }
  bind_rows(results)
}





# simulate ANOVA
n_groups <- 3
n <- 100
mu <- rep(0, 3)
sd <- rep(1, 3)

simulate_anova <- function(n_groups, n)