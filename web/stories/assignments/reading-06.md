# Reading Assignment 6

Complete the following exercises from *OpenIntro Statistics* Chapter 6: 4, 6, 12, 14, 22, 24, 26, 28, 30, 38, 40, 42, 50, 52, 54.

Find an poll. HuffingtonPost [Pollster](http://elections.huffingtonpost.com/pollster) and [RealClearPolitics](http://www.realclearpolitics.com/epolls/latest_polls/) are good places to start.

- Calculate the confidence interval of a proportion
- Calculate the confidence interval for a difference in proportions
- Conduct a hypothesis test that two proportions are different
- Conduct a Chi-squared test of independence (look for a poll with a table multiple demographic groups)

Submit as a Word Document or PDF via Canvas. Answers must be typed.

There are several useful R functions: `pchisq`, `prop.test`, and `chisq.test`.
For solving questions, even though you are calculating these tests manually, 
save yourself some work by doing the calculations in R rather than by hand and calculator.

Here are some R code for solving *OpenIntro Stats* exercises.
These are not full answers to those exercises (since these are odd questions with answers in the back), but only the R code needed to answer them.

# Ex 6.11

The sample size and proportion for this question are,

```r
n <- 1509
p <- 0.55
```
To calculate a confidence interval for a proportion, first
calculate the standard error,

```r
se <- sqrt(p * (1 - p) / n)
```
and critical value,

```r
z <- -qnorm(0.05)
```
Then the confidence interval is,

```r
p + c(-1, 1) * z * se
```

```
## [1] 0.5289346 0.5710654
```
You can confirm this using the R function `prop.test()`,

```r
prop.test(x = p * n, n = n, conf.level = 0.90)
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  p * n out of n, null probability 0.5
## X-squared = 14.891, df = 1, p-value = 0.0001139
## alternative hypothesis: true p is not equal to 0.5
## 90 percent confidence interval:
##  0.5285316 0.5712866
## sample estimates:
##    p 
## 0.55
```
The first argument is the number of successes, the second is the sample size.
By default, `prop.test()` calculates a 95% confidence interval, so the `conf.level` argument is needed to calculate a 90% confidence interval. 
Note that `prop.test()` also performs a hypothesis test.
The confidence interval given by `prop.test()` is slightly different than the one calculated manually because it uses a different method; However, they should be close.

# Ex 6.13

The sample size and proportion for this question are,

```r
n <- 783
p <- 0.52
```
The null and alternative hypotheses are $H_0: p = 0.5$, $H_a: p > 0.5$.
The standard error is calculated using $p_0 = 0.5$,

```r
p0 <- 0.5
se <- sqrt(p0 * (1 - p0) / n)
se
```

```
## [1] 0.01786854
```
The test statistic is,

```r
z <- (p - p0) / se
z
```

```
## [1] 1.119285
```
The p-value for a one-sided hypothesis test is,

```r
pnorm(z, lower.tail = FALSE)
```

```
## [1] 0.1315092
```
We can confirm this `prop.test()`,

```r
prop.test(n * p, n, alternative = "greater")
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  n * p out of n, null probability 0.5
## X-squared = 1.1741, df = 1, p-value = 0.1393
## alternative hypothesis: true p is greater than 0.5
## 95 percent confidence interval:
##  0.4899762 1.0000000
## sample estimates:
##    p 
## 0.52
```
Note that by default, `prop.test` tests the hypothesis that `p = 0.38`, and a two-sided test.
The argument `alternative` is needed to select a one-sided test.

Note: If it were a two-sided test the p-value would be

```r
2 * pnorm(-abs(z))
```

```
## [1] 0.2630184
```

# Ex 6.27

The proportions and sample sizes for this question are,

```r
p_D <- 0.7
n_D <- 819
p_I <- 0.42
n_I <- 783
```
The 95% confidence interval is,

```r
# Standard error
se <- sqrt(p_D * (1 - p_D) / n_D + p_I * (1 - p_I) / n_I)
se
```

```
## [1] 0.02382271
```

```r
# (1 - alpha) * 100% confidence interval
confidence <- 95
alpha <- 1 - confidence / 100
# two-sided critical value
z <- -qnorm(alpha / 2)
# Confidence interval
(p_D - p_I) + c(-1, 1) * z * se
```

```
## [1] 0.2333084 0.3266916
```
Alternatively, you can also use `prop.test` for confidence intervals and hypothesis tests for differences of proportions,

```r
prop.test(c(n_D * p_D, n_I * p_I), c(n_D, n_I))
```

```
## 
## 	2-sample test for equality of proportions with continuity
## 	correction
## 
## data:  c(n_D * p_D, n_I * p_I) out of c(n_D, n_I)
## X-squared = 126.43, df = 1, p-value < 2.2e-16
## alternative hypothesis: two.sided
## 95 percent confidence interval:
##  0.2320593 0.3279407
## sample estimates:
## prop 1 prop 2 
##   0.70   0.42
```
The first argument is the number of successes (which is why it is $p_D * n_D$ and $p_I * n_I$).
The confidence interval will be slightly different than the one just calculated because `prop.test()` uses a slightly different method.

# Ex 6.29

The sample sizes and proportions for this question are,

```r
tbl <- matrix(c(154, 180, 104, 132, 126, 131),
         nrow = 3, ncol = 2,
         dimnames =
           list(c("Support", "Oppose", "Do not know"),
                "College grad" = c("Yes", "No")))
tbl
```

```
##              College grad
##               Yes  No
##   Support     154 132
##   Oppose      180 126
##   Do not know 104 131
```
Total sample size,

```r
n <- sum(tbl)
n
```

```
## [1] 827
```
Column and row totals,

```r
col_totals <- margin.table(tbl, 2)
col_totals
```

```
## College grad
## Yes  No 
## 438 389
```

```r
row_totals <- margin.table(tbl, 1)
row_totals
```

```
## 
##     Support      Oppose Do not know 
##         286         306         235
```
College grad sample size and proportions are

```r
n_C <- col_totals["Yes"]
p_C <- tbl["Do not know", "Yes"] / n_C
p_C
```

```
##       Yes 
## 0.2374429
```
Non-college grad sample size and proportions

```r
n_N <- col_totals["No"]
p_N <- tbl["Do not know", "No"] / n_N
p_N
```

```
##        No 
## 0.3367609
```
The pooled proportion is

```r
p_pool <- row_totals["Do not know"] / n
p_pool
```

```
## Do not know 
##   0.2841596
```
The standard error using the pooled proportion is

```r
se <- sqrt(p_pool * (1 - p_pool) * (1 / n_C + 1 / n_N))
se
```

```
## Do not know 
##  0.03142174
```
since 
$$
se = \sqrt{\frac{p_pool * (1 - p_pool)}{n_1} + \frac{p_pool * (1 - p_pool)}{n_2}} =
\sqrt{p_pool * (1 - p_pool) \left(\frac{1}{n_1} + \frac{1}{n_2} \right)} .
$$
The test statistic is,

```r
z <- (p_C - p_N) / se
z
```

```
##       Yes 
## -3.160806
```
The p-value for a two-sided test is,

```r
2 * pnorm(-abs(z))
```

```
##         Yes 
## 0.001573334
```

Hypothesis tests for differences in proportions can also be conducted with `prop.test()`,

```r
prop.test(tbl["Do not know", ], col_totals) 
```

```
## 
## 	2-sample test for equality of proportions with continuity
## 	correction
## 
## data:  tbl["Do not know", ] out of col_totals
## X-squared = 9.5084, df = 1, p-value = 0.002045
## alternative hypothesis: two.sided
## 95 percent confidence interval:
##  -0.16333768 -0.03529832
## sample estimates:
##    prop 1    prop 2 
## 0.2374429 0.3367609
```
or,

```r
prop.test(c(p_C * n_C, p_N * n_N), c(n_C, n_N))
```

```
## 
## 	2-sample test for equality of proportions with continuity
## 	correction
## 
## data:  c(p_C * n_C, p_N * n_N) out of c(n_C, n_N)
## X-squared = 9.5084, df = 1, p-value = 0.002045
## alternative hypothesis: two.sided
## 95 percent confidence interval:
##  -0.16333768 -0.03529832
## sample estimates:
##    prop 1    prop 2 
## 0.2374429 0.3367609
```
The first argument is the number of success in each sample, and the second argument is size of each sample.
By default, `prop.test` tests that proportions are equal.
Note that the test-statistic for the `prop.test` is different than what we used with the normal approximation since `prop.test` uses a Chi-squared test. 
But, the p-values will be close.

# Ex 6.43

The table of the data

```r
observed <- c("Rock" = 43, "Paper" = 21, "Scissors" = 35)
observed
```

```
##     Rock    Paper Scissors 
##       43       21       35
```
The total sample size is,

```r
n <- sum(observed)
n
```

```
## [1] 99
```
If players chose equally, the expected counts are,

```r
expected <- 1 / 3 * rep(n, 3)
expected
```

```
## [1] 33 33 33
```
The test-statistic is,

```r
chisq <- sum((observed - expected) ^ 2 / expected)
chisq
```

```
## [1] 7.515152
```
The degrees of freedom are,

```r
df <- length(observed) - 1
df
```

```
## [1] 2
```
The p-value is,

```r
1 - pchisq(chisq, df = df)
```

```
## [1] 0.02334025
```

This could also be done using `chisq.test()`,

```r
chisq.test(tbl, p = rep(1 / 3, 3))
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  tbl
## X-squared = 11.461, df = 2, p-value = 0.003246
```


# Ex 6.47

The observed data are,

```r
observed <- matrix(c(154, 180, 104, 132, 126, 131),
         nrow = 3, ncol = 2,
         dimnames =
           list(c("Support", "Oppose", "Do not know"),
                "College grad" = c("Yes", "No")))
observed
```

```
##              College grad
##               Yes  No
##   Support     154 132
##   Oppose      180 126
##   Do not know 104 131
```
The total sample size is

```r
n <- sum(observed)
```
The row and column totals are

```r
row_totals <- margin.table(observed, 1)
row_totals
```

```
## 
##     Support      Oppose Do not know 
##         286         306         235
```

```r
col_totals <- margin.table(observed, 2)
col_totals
```

```
## College grad
## Yes  No 
## 438 389
```
To calculate the expected values under independence, first calculate the marginal proportions,

```r
observed_prop <- prop.table(observed)
observed_prop
```

```
##              College grad
##                     Yes        No
##   Support     0.1862152 0.1596131
##   Oppose      0.2176542 0.1523579
##   Do not know 0.1257557 0.1584039
```

```r
row_prop <- margin.table(observed_prop, 1)
row_prop
```

```
## 
##     Support      Oppose Do not know 
##   0.3458283   0.3700121   0.2841596
```

```r
col_prop <- margin.table(observed_prop, 2)
col_prop
```

```
## College grad
##       Yes        No 
## 0.5296252 0.4703748
```
The expected counts under independence are

```r
expected <- row_prop %o% col_prop * n
```
The operator `%o%` is the outer produce which calculates the product of each of the vectors for each entry in the matrix.
We multiply this by `n` in order to turn the proportions to counts.

The test-statistic is

```r
chisq <- sum((observed - expected) ^ 2 / expected)
chisq
```

```
## [1] 11.46082
```
The degrees of freedom is the number of rows minus one times the number of columns minus one,

```r
df <- (nrow(observed) - 1) * (ncol(observed) - 1)
df
```

```
## [1] 2
```
The p-value is,

```r
1 - pchisq(chisq, df = df)
```

```
## [1] 0.003245752
```

This could also be calculated using `chisq.prop()`,

```r
prop.test(observed)
```

```
## 
## 	3-sample test for equality of proportions without continuity
## 	correction
## 
## data:  observed
## X-squared = 11.461, df = 2, p-value = 0.003246
## alternative hypothesis: two.sided
## sample estimates:
##    prop 1    prop 2    prop 3 
## 0.5384615 0.5882353 0.4425532
```
