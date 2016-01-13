<!--
.. title: Getting Help with R
.. description: How to get help with R?
-->

# Functions 

The first place to look is to use the search box in the *Help* tab of RStudio.

If you start typing in either the console or editor in RStudio and hit `[TAB]`, the RStudio will show a list of completions as well as a short help for each.

There are several R functions to get help using either `?` or `help`.
For example to find help for a function `quantile`, you can use either
``` r
?quantile
```
or 
``` r
help("quantile")
```

To find the help pages available for a package, use `help` with the `package` argument.
For example,
``` r
help(package = "tidyr")
```

Want to find out what datasets are included in the R packages that you have installed? 
```r
data()
```
To find datasets included in a specific package, use `data` with the `package` argument,
For example,
``` r
data(package = "ggplot2")
```

The help for R functions is only useful if you know what function you need want to know either what it is doing, or what the arguments are.
The help files in R are not useful for understanding what a package does or how to use it. 
However, *vignettes* for R packages are often overviews of the functionality of packages that serve as tutorials or introdicutions to using the package.
To get a list of all vignettes of the packages your have installed, run
``` r
browseVignettes()
```
To get the list of vignettes for a specific package, run
``` r
browseVignettes("dplyr")
```
You can also find vignettes for packages you have not installed on the packages' CRAN page [https://cran.r-project.org/web/packages/tidyr/index.html]https://github.com/hadley/dplyr)". 
There is also a `vignette` function, but you need the exact name of the vignette, which you generally do not know.

Note that `search()` **does not** do what you expect it to do, unless you expect it to return the search path in which R looks for packages.

# Internet

[Rdocumentation.org](http://www.rdocumentation.org/) searches the documentation of all R packages on CRAN and more

Google has gotten better with R searches, but `R` is a particularly unfriendly search term.
However, if you are searching for "R" with other words in context, you are likely to have some success.
An alternative is to use [rseek.org](http://rseek.org) instead.
It is a Google search restricted to a curated set of sites related to R.

Many R packages have an article in either the [Journal of Statistical Software](http://www.jstatsoft.org/index) or [The R Journal](https://journal.r-project.org/)
These articles are similar to package does. 

[Stack Overflow](https://stackoverflow.com) is a question and answer website for computer programming questions.
Search for questions about R using the "r" tag. You can do this by adding `[r]` to your search query. Other tags that may be useful are `[ggplot2]`, `[plyr]`.
However, generally you should not  need to *ask* questions for this course.
Someone has likely already asked your question before.

If you have a question about "statistics" or "data analysis" rather than "R", then [Cross Validated](https://stats.stackexchange.com/) is a Q-and-A site like Stack Overflow, but for statistics and machine learning.

# Cheatsheets

RStudio has several very good [cheatsheets](https://www.rstudio.com/resources/cheatsheets/)

- [RStudio IDE](http://www.rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf)
- [Data Visualization](http://www.rstudio.com/wp-content/uploads/2015/12/ggplot2-cheatsheet-2.0.pdf) (ggplot2)
- [Data Wrangling](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) (dplyr, tidyr, lubridate, tidyr)
- [R Markdown](http://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)
- [R Markdown Reference Guide](http://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)

The [Short R Reference Card](https://cran.r-project.org/doc/contrib/Short-refcard.pdf) is the classic cheatsheet.
However, some of the data manipulation and plotting functions are not those we use in this course, but it does cover much of the statistical functions.

# Books

Two references organized by task are [The Cookbook for R](http://www.cookbook-r.com) and [Quick-R](http://www.statmethods.net/).

<!--
[R-bloggers](http://www.r-bloggers.com/) aggregates R-related blogging. 

On twitter, the R hashtag is `#rstats`. Some prominent R-related people and accounts on twitter are:
[@R-bloggers](https://twitter.com/Rbloggers)
[@RevolutionR](https://twitter.com/RevolutionR),
[@isDotR](https://twitter.com/isDotR),
[@swirlstats](https://twitter.com/swirlstats),
[@rOpenGov](https://twitter.com/rOpenGov),
[@JennyBryan](https://twitter.com/JennyBryan),
[@rOpenSci](https://twitter.com/rOpenSci),
[@rstudio](https://twitter.com/rstudio),
[@inside_R](https://twitter.com/inside_R),
[@cboettig](https://twitter.com/cboettig),
[@ramnath_vaidya](https://twitter.com/ramnath_vaidya),
[@eddelbuettel](https://twitter.com/eddelbuettel),
[@benmarwick](https://twitter.com/benmarwick),
[@thosjleeper](https://twitter.com/thosjleeper),
[@STAT545](https://twitter.com/STAT545).


Do you want to know what packages exist for a given topic? [CRAN Task Views](https://cran.r-project.org/web/views/) provide subject matter groupings of R packages. Some potentially useful task-views to social scientists are:

	- [Econometrics](https://cran.r-project.org/web/views/Econometrics.html)
	- [Natural Language Processing](https://cran.r-project.org/web/views/NaturalLanguageProcessing.html)
	- [Official Statistics & Survey Methodology](https://cran.r-project.org/web/views/OfficialStatistics.html)
	- [Reproducible Research](https://cran.r-project.org/web/views/ReproducibleResearch.html)
	- [Spatial](https://cran.r-project.org/web/views/Spatial.html)
	- [Survival Analysis](https://cran.r-project.org/web/views/Survival.html)
	- [Time Series](https://cran.r-project.org/web/views/TimeSeries.html)
	- [Web Technologies and Services](https://cran.r-project.org/web/views/WebTechnologies.html)
    - [Social Sciences](https://cran.r-project.org/web/views/SocialSciences.html)
-->


# How to ask for help

TODO: fill in an example

<!--
How to write a minimal reproducible example <https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example>

If you are going to ask for help, it is important to know how to ask for help

- Coding Killed the Cat "How to ask programming question" <https://codingkilledthecat.wordpress.com/2012/06/26/how-to-ask-for-programming-help/>
- Matt Gemmell, "What Have You Tried?" <http://mattgemmell.com/what-have-you-tried/>
-->
