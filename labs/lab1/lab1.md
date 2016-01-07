# Lab 1: Reading Data in R

#### Jeff Arnold (Primary Instructor) & Andreu Casas (TA)

***

### Learning Objectives

1. Reading data in R's native format
2. Read and write CSVs
3. Read and write other type of data formats: STATA, SPSS, XLS...
4. Replication, Dataverse, and getting data from an external source



***

### 0. R Projects and R Markdown

Keeping all the files associated with a project organized together – input data, R scripts, analytical results, figures – is such a wise and common practice that RStudio has built-in support for this via its projects.  Read [this](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects) for more information about RStudio projects.

You will use RStudio projects for your labs and homework. Create a RStudio project that you will use for all your labs.

1. *File -> New Project*
2. Select "New Directory"
3. Select "Empty Project"
4. Select a name for your project as Directory Name.
   "POLS_501_Labs" is as good as any, and better than most.
   Then choose where to put this directory with "Create project as sub-directory of".
   Don't worry about the other options.
5. Create a new directory within "POLS_501_Labs" called "lab1"
6. Create a new directory within "lab1" called "data"
7. Open this new project and open a new R script where you will be writing (and copy-pasting) and running code.

For this course, you will also be we using R Markdown documents for labs and homeworks.
Create your first R Markdown document for this lab.

1. *File -> New File -> R Markdown*
2. This will open a template for your Markdown file.
4. Save this file with `Ctrl-S` and name it e.g. 'lab1'
5. Click on the "Knit HTML" button. This will create a HTML document from this document.

Cheatsheets and additional resources about R Markdown are available at <http://rmarkdown.rstudio.com/>.

### 1. Reading data in R's native format  

In this section we will see 2 different types of data. First, we will work with datasets that are part of R packages. Second, we will learn how to save and load data in the R's native format (.Rdata & .rda)    

Some R packages have datasets that you can load if you have those packages installed and loaded. For example, let's install the **gapminder** package. You need R version ≥ 3.1.0. If you have an older version, this is a good moment to go the [R Project website] (https://cran.fhcrc.org/) and update it.


```r
install.packages('gapminder')
library(gapminder)
```

We can take a look at what's in the package by using the help function: `help(<name-of-the-package>)` or `?<name-of-the-package>`


```r
?gapminder
```

The package documentation indicates that the package comes with a dataset named `gapminder`. To load the dataset in the R environment, we use the following function: `data(<name-of-the-dataset>)`. When loading datasets from packages we don't need to assign them to any object, they will be automatically loaded into the R enviornment and given the original dataset name


```r
data(gapminder)
```

We can now explore the **gapminder** dataset using the following functions:

- `dim` shows the dimensions of the data frame as the number of rows, columns
- `str` shows the internal structure of an R object
- `names` shows the column names of the data frame.
- `head` shows the first few observations
- `tail` shows the last few observations
- `summary` calculates summary statistics for all variables in the data frame.


```r
dim(gapminder)
str(gapminder)
names(gapminder)
head(gapminder)
tail(gapminder)
summary(gapminder)
```

We can save any R object in our environment using R's native format: `.Rdata` & `.Rda`. In this case we use the `save(<name-of-the-object>)` function


```r
save(gapminder, file='data/gapminder.Rdata')
```

We can later load these R data files using the `load(<name-of-the-file>)` function. Let's delete the `gapminder` dataset that we curently have in the R environment and load it again using the `save()` function


```r
rm(gapminder)
load('data/gapminder.Rdata')
dim(gapminder)
```

***

### 2. Read and write CSVs

One of the most common data formats is the CSV (Comma Separated Values). CSV datasets are easy to share and read using multiple statistical softwares. 

Download the dataset **wdi_sample.csv** from the following [link] (https://github.com/UW-POLS501/pols_501_wi16/blob/master/labs/lab1/data/wdi_subset.csv) and save it in `lab1/data`. To read in the CSV file, use the `read.csv()` function, which has the main following parameters:

- `file` name of the file (e.g. 'data/wdi_sample.csv')
- `header` (TRUE/FALSE) whether the first row contains variable names (TRUE default value)
- `sep` character that separates variables (',' default value)


```r
wdi <- read.csv(file='data/wdi_sample.csv')
```

Briefly explore the dataset


```r
dim(wdi)
head(wdi)
names(wdi)
unique(wdi$Country.Name)
unique(wdi$Indicator.Name)
wdi[50,]
```

Add an extra variable to the dataset


```r
wdi$test_var <- 1
```

Save the new version of the dataset in CSV format


```r
write.csv(wdi, file='data/wdi_sample2.csv')
```

***

### 3. Read and write other type of data formats: STATA, SPSS, XLS, XLSX...

Not all datasets we want to use are in CSV format. They are often in other formats such as `.txt`, `.sav` (SPSS's native format), `.dta` (STATA), `.xls` or `.xlsx` (Excel formats), etc. There are some R packages that make it easy to read those data formats into R. One of them is the ``rio`` package. Download the following datasets, install the ``rio`` package, and load them into R using ``rio``

- [phd.txt] (https://github.com/UW-POLS501/pols_501_wi16/blob/master/labs/lab1/data/phd.txt) Time to PhD dataset from Espenshade and Rodriguez (1997) SSQ, avialable [here] (http://data.princeton.edu/wws509/datasets/#phd).

- [edu_expend_1975.sav] (https://github.com/UW-POLS501/pols_501_wi16/blob/master/labs/lab1/data/edu_expend_1975.sav) Education Expenditure 1960, from Chatterjee, Hadi and Price (1977), available [here] (http://www.ats.ucla.edu/stat/spss/examples/chp/chpspss_dl.htm)

- [salary.dta] (https://github.com/UW-POLS501/pols_501_wi16/blob/master/labs/lab1/data/salary.dta) Discrimination in Salaries, from Weisber (1985), available [here] (http://data.princeton.edu/wws509/datasets/#salary)

- [divorce.xlsx] (https://github.com/UW-POLS501/pols_501_wi16/blob/master/labs/lab1/data/divorce.xlsx) Marriage Dissolution in the U.S., from Lillard and Panis (2000), available [here] (http://data.princeton.edu/wws509/datasets/#divorce)


```r
install.packages('rio')
library(rio)
phd <- import('data/phd.txt')
edu <- import('data/edu_expend_1975.sav')
salary <- import('data/salary.dta')
divorce <- import('data/divorce.xlsx')
```

Explore the datasets that we just loaded using some of the functions that we have already seen. Check if they all have been correctly loaded.

We observe 2 issues when reading in the `phd` dataset: it has no variable names in the first row, and R believes the datset has only 1 variable. Let's read the dataset in using the `read.table()` function of the `utils` package


```r
phd <- read.table('data/phd.txt')
```

The `rio` package is very useful but not perfect. The following are other functions and packages you may consider when importing datasets into R:

- `read.xls` from the `gdata` package: To import `.xls` files
- `foreign` package has multiple functions to import numeorus data formats such as `.sav`, `.dta`, etc.

For further information you can take a look at this [post] (http://www.r-tutor.com/r-introduction/data-frame/data-import)

***

### 4. Replication, Dataverse, and getting data from an external source

Replication and transparency are key components of all scientific research. However, in the past social scientists have often not been very transparent. For this reason, there are currently numerous initatives aiming to increase transparency in social science research. See [www.dartstatement.org] (http://www.dartstatement.org/) for an example. One of the main objectives of this course is to learn how to produce clear guidelines when developing our research so others can easily replicate it in the future. 

As part of these replication efforts, authors and journals often share replication datasets and code in their websites or online repositories. One of the most used repositories is [`Dataverse` ] (https://dataverse.harvard.edu/). For example, the American Journal of Political Science (AJPS) posts replication files in [dataverse] (https://dataverse.harvard.edu/dataverse/ajps) for all the articles published in the journal. 

For example, AJPS recently posted the replication files of an article by Broockman and Bulter (2015) 'The Causal Effects of Elite Position-Taking on Voter Attitudes: Field Experiments with Elite Communication'. In this article the authors perform two experiments to show how opinions stated by public representatives have the potential to change the opinions of their constituents. You can access the replication files [here] (https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/YZQTAH) and the paper [here] (http://onlinelibrary.wiley.com/doi/10.1111/ajps.12243/abstract). 

Go to the replication site of the paper and download the replication dataset `Study1_data.tab`. You can choose the format of the dataset, choose to download it in `RData` format. Save it in the working the directory you are using for this lab. 

Now load it and play with it! 


```r
load('data/Study1_data.Rdata')
```



```r
names(x)
table(x$policy_letter_treat)
table(x$policy_letter_treat,x$movable_total)
```















