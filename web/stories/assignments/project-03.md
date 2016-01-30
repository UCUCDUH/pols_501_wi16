<!--
.. title: Research Project Assignment 3
-->

Last week we covered **dplyr**, joining, and tidy data. This assignment asks you to apply those concepts to your project data.

1. What unique datasets will you be using for your analysis? What are their sources?
2. Are your datasets tidy datasets, as defined in [Wickham (2014)(http://www.jstatsoft.org/article/view/v059i10? Why or why not? How would you need to reshape them for your analysis? Are you able to do this with **tidyr**? If so, do it. If not, why not?
2. For each dataset, what is (are) the unique column(s) that uniquely identify observations? These are called keys. 
3. Do you need to merge datasets? If so, for each pair of datasets, what are the columns you merge on? If there are no columns in common, what data do you need in order to merge the datasets? What type of join do you need to do?
4. If you joined datasets, check that it worked as expected. In particular, check that the observations that did not match are accounted for.
5. If you have the data to do so, use `group_by()` to calculate summary statistics of one of your outcome variables by a categorical explanatory variable of interest. If your explanatory variable is continuous, use the function `cut` to split it into 3 or 4 categories, and group on those. Do you see any substantive differences between the categories? 
6. Of variables of interest, are there missing values? Check the codebook for cases in which missing values are indicated by numeric values or categories. What fraction of each variable of interest is missing?

Research projects do not progress linearly, and your data may turn out to be messier and more difficult to deal with than you expected. That is one of the primary differences between data analysis in practice and data analysis in textbooks. An objective of these assignments is to uncover those issues early, in order to give us time to work through them. If there are parts of the assignment that you cannot complete due to data issues, (1) talk to us ASAP, and (2) on the assignment, explain what the issues are and what you will need to do to overcome them.

# Organization

Your assignment should be in an RStudio project directory, with the followind directory structure. 
Create the Rproject directory using `File > New Project > New Directory > Empty Project` in RStudio.
Replace `jrnold` with your `netid`; your netid is the same as your UW email address: `netid@uw.edu`.

```
jrnold-project-03
├── data
├── figure
├── jrnold-project-03-code.R
├── jrnold-project-03.Rproj
└── jrnold-project-03.pdf
```

- `jrnold-project-03.pdf` is the writeup of your analysis. Word documents (`docx`, `doc`) are also acceptable. The document should be written in prose and not include code.  However, it should include relevant plots and output that illustrate your points.
Any R output included in the writeup should be formatted with a monospace font (e.g. Courier, Consolas, Menlo, Monaco).
- `jrnold-project-03-code.R` contains the R code used to generate the results of your analysis.
- Datasets should go in the `data` directory.
- Plots (.png, .pdf) go in the `figure` directory.
- **Important** So that others can run your code,

   - Do not include absolute paths
   - Load packages that you use in your code with `library()`.
   - Do **not** include `install.packages()` in your script.

Zip the directory and submit the zip file to canvas. 
When you zip the directory file ensure that the top-level directory is included.
In other words, when you unzip the file, it should produce the directory `jrnold-project-03` and not multiple files.
To do this you can use the funtion `zip_assignment` in the **uwpols501** package.
