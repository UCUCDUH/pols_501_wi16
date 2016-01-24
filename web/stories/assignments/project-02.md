<!--
.. title: Research Project Assignment 2
-->

For any data you have available, but at least one dataset, answer the following.

1. What is the source of the dataset? Be as specific as possible. It is not necessary, but for the paper you will be expected to use cite all data following the conventions that are becoming standard in the field; see the *Political Analysis* guidelines for ["Data Citation"](http://www.oxfordjournals.org/our_journals/polana/for_authors/general.html).
2. Use `str` and the associated documentation of the dataset to describe the types and meanings of the variables in the dataset. You do not need to discuss all variables; only focus on those of most interest to your analysis.
3. What type of data is it: cross-section, time-series, or time-series cross-section?
4. What is the unit of observation of the dataset? What variable(s) uniquely identify observations in the data?
5. How many observations are there in the dataset?
6. Use `summary()` to summarize relevant variables.
7. Which variables have missing values? How prevalant are missing values?
8. Plot the distribution of at least one variable using **ggplot2** with either `geom_histogram` or `geom_density` with `geom_rug`. What is the shape of the distribution?
9. Choose two variables to compare. If they are both continuous, create a scatterplot using `geom_scatter`. If they are both discrete, create a faceted bar plot using `geom_scatter` and `facet_grid`. If one is discrete and one is continuous, create a boxplot using `geom_boxplot`.

Your assignment should be submitted via Canvas as a `zip` file of an R project with the following directory structure and file naming conventions (replace "jrnold" with your netid:):
```
jrnold-project-02
├── data
├── figure
├── jrnold-project-02-code.R
├── jrnold-project-02.Rproj
└── jrnold-project-02.pdf
```

- `jrnold-project-02.pdf` is the writeup of your analysis. Word documents (`docx`, `doc`) are also acceptable. The document should be written in prose and not include code.  However, it should include relevant plots and output that illustrate your points.
Any R output included in the writeup should be formatted with a monospace font (e.g. Courier, Consolas, Menlo, Monaco).
- `jrnold-project-02-code.R` contains the R code used to generate the results of your analysis.
- Datasets should go in the `data` directory.
- Plots (.png, .pdf) go in the `figure` directory.

Zip the directory and submit the zip file to canvas.
When you zip the directory file ensure that the top-level directory is included.
In other words, when you unzip the file, it should produce the directory `jrnold-project-02` and not multiple files.
