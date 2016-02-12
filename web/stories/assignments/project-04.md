<!--
.. title: Research Project Assignment 4
-->

For this assignment, apply the methods learned so far in the course (through Week 7) to your project. Your assignment should address at least the following points. You should write this in the format of a paper. There is no page or word limit on this. Consider this a draft what will eventually be your final paper. The more work you do now, the less later. More importantly, it is an opportunity to get initial feedback from the instructors.

1. Clearly state your question. It should be clear what your outcome variable and explanatory variables are. You should keep this concise and focus on the theory and mechanisms. You can cite relevant papers to your theory, but do not spend time or space on a literature review.

2. Describe your data. What is the sample? How was the sample collected (random, non-random, is it the population of interest)? What are its sources? Cite

3. Describe your variables of interest. For the variables of interest (response, explanatory) provide a table of summary statistics and perhaps histograms or density plots if needed.

4. Analyze your question using your data and any of the methods that we have learned thus far (through Week 7). These methods include:

    - graphical methods: scatterplots, box plots, mosaic plots, etc.
    - difference in means tests or confidence intervals
    - permutation tests
    - bootstrapped confidence intervals
    - ANOVA
    - difference in proportions tests or confidence intervals
    - Chi-squared test of independence or goodness of fit

    Use any or all of these methods that are appropriate.

    If your response and explanatory variables are both continuous, generally you would use regression methods. Since the course has not covered regression yet, create a categorical variable from explanatory variable. For example. you can create a dichotomous variable by splitting the explanatory variable at its mean or median.

5. Are your results robust to confounding variables? We have not covered multivariate regression yet. Instead, divide your sample into groups of the confounding variable and see whether your results hold across subgroups.

6. All code and data necessary to reproduce your results should be included (see instructions below).

Research projects do not progress linearly, and your data may turn out to be messier and more difficult to deal with than you expected. That is one of the primary differences between data analysis in practice and data analysis in textbooks. An objective of these assignments is to uncover those issues early, in order to give us time to work through them. If there are parts of the assignment that you cannot complete due to data issues, talk to the instructors ASAP.


# Organization

Your assignment should be in an RStudio project directory, with the following directory structure.
Create the R project directory using `File > New Project > New Directory > Empty Project` in RStudio.
Replace `jrnold` with your `netid`; your netid is the same as your UW email address: `netid@uw.edu`.

```
jrnold-project-04
├── data
├── figure
├── jrnold-project-04-code.R
├── jrnold-project-04.Rproj
└── jrnold-project-04.pdf
```

- `jrnold-project-04.pdf` is the writeup of your analysis. Word documents (`docx`, `doc`) are also acceptable. The document should be written in prose and not include code.  However, it should include relevant plots and output that illustrate your points.
Any R output included in the writeup should be formatted with a monospace font (e.g. Courier, Consolas, Menlo, Monaco).
- `jrnold-project-04-code.R` contains the R code used to generate the results of your analysis.
- Datasets should go in the `data` directory.
- Plots (.png, .pdf) go in the `figure` directory.
- **Important** So that others can run your code,

   - Do not include absolute paths
   - Load packages that you use in your code with `library()`.
   - Do **not** include `install.packages()` in your script.

Zip the directory and submit the zip file to canvas.
When you zip the directory file ensure that the top-level directory is included.
In other words, when you unzip the file, it should produce the directory `jrnold-project-04` and not multiple files.
To do this you can use the function `zip_assignment` in the **uwpols501** package, which you install using
```r
library("devtools")
install_github("UW-POLS501/r-uwpols501")
```
