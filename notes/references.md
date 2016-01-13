# Books

- Gailmard *Statistical Modeling and Inference for Social Science*
- Freedman, Pisani and Purves *Statistics*
- *OpenIntro Statistics* https://www.openintro.org/stat/textbook.php?stat_book=os
- John Hopkins

   - Peng *Report Writing for Data Science in R* https://leanpub.com/reportwriting
   - Caffo *Statistical Inference for Data Science* https://leanpub.com/LittleInferenceBook
   - Caffo *Regression Models for Data Science in R* https://leanpub.com/regmods
   - Peng *Exploratory Data Analysis with R* https://leanpub.com/exdata
   - Peng *R Programming for Data Science*
   - Leek *The Elements of Data Analytic Style* https://leanpub.com/datastyle
   - Peng and Matsui *The Art of Data Science* https://leanpub.com/artofdatascience

- Allen Downey, *Think Stats*, http://greenteapress.com/thinkstats/
- Shasha and Wilson *Statistics is Easy*
- Reinhardt, *Statistics Done WRong*
- Gelman and Hill *Data Analysis Using Regression and Multilevel/Hierarchical Models*
- Grolemund and Wickham, *R for Data Science [page](http://r4ds.had.co.nz/), [github] , [page](http://garrettgman.github.io/).

Other

- Gandrud *Reproducible Research in R and RStudio* http://www.amazon.com/exec/obidos/ASIN/1498715370/7210-20
- Xie *Dynamic Documents with R and knitr*
- Nolan and Lang *Data Science in R: A Case Studies Approach*
- Zumel *Practical Data Science in R*
- Kabakoff *R in Action*
- Grus *Data Science from Scratch*
- Chang *R Graphics Cookbook*


# Classes to Compare

- Harvard Gov 1000/2000/2000e/Stat E-190:
Quantitative Research Methodology. Matthew Blackwell. http://www.mattblackwell.org/files/teaching/gov2000-syllabus.pdf
- UC Berekeley, PS 231A: Quantitative Analysis in Political Research, Sean Gailmard. PhD course using *SMISS*.  https: //www.ocf.berkeley.edu/~gailmard/syl.ps231a.pdf
- SOC 504 Spring 2015: Advanced Data Analysis for the Social Sciences. [site](http://www.princeton.edu/~mjs3/soc504_s2015/). It would be equivalent to 503 or 510, but it uses github and is influenced by online courses.
- JHU Data Science specialization on [Coursera](https://www.coursera.org/specializations/jhu-data-science/1). Source for the courses is on [github](https://github.com/DataScienceSpecialization/courses). It has 9 courses and a capstone project.

    - Data Scientists' Toolbox
	- R Programming
	- Getting and Cleaning Data
	- Exploratory Data Analysis
	- Reproducible Research
	- Statistical Inference
	- Regression Models
	- Practical Machine Learning (not relevant)
	- Developing Data Products (not relevant)

- Sta 101: Duke (undergrad) but innovative in pedagogy. Mine Cetinkaya-Rundel: Fall 2015 [site](httpspa://stat.duke.edu/courses/Fall15/sta101.002/), [github](https://github.com/mine-cetinkaya-rundel/sta101_f15). Sta 104 Data Analysis and Statistical Inference [site](https://stat.duke.edu/courses/Summer15/sta104.01-1/).
- UBC Stat 545: Data Wrangling, exploration and analysis with R. by Jenny Bryan [site](https://stat545-ubc.github.io/), [github](https://github.com/STAT545-UBC/STAT545-UBC.github.io).
- Software Carpentry courses

    - [Programming with R](http://swcarpentry.github.io/r-novice-inflammation/)
	- [R for reproducible scientific analysis](http://swcarpentry.github.io/r-novice-gapminder/)

	- [Instructor Training](https://github.com/swcarpentry/instructor-training) (for pedagogy).
- John Hopkins, [Winter R Booktcamp](http://seankross.com/rbootcamp/), Sean Cross. R programming. Also uses Swirl examples.

Also look at the classes listed in Aronow's intro stats book proposal: http://aronow.research.yale.edu/aronowmillerproposal.pdf

# R packages of use

- Data viz
  - ggplot2
  - ggExtra
  - https://bchartoff.shinyapps.io/ggShinyApp/
- Data wrangling
  - dplyr
  - tidyr
  - broom
- Stats: ????
- Data IO
  - foreign
  - readr
  - readxl
  - haven
  - rio
- Clients
  - WDI
  - countrycode
  - Quandl
  - dvn
- Presentation
  - rmarkdown
  - stargazer
  - xtable
  - pander



- Shpariro Social Science Code and Data https://people.stanford.edu/gentzkow/sites/default/files/codeanddata.pdf
- Code Review For and By Scientists: http://arxiv.org/abs/1407.5648
- Nine Simple Ways to Make it Easier for Others to Reuse Your Data: https://peerj.com/preprints/7/
- Best Practices for Scientific Computing http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745. [Slides](http://swcarpentry.github.io/slideshows/best-practices/index.html#slide-0)
- Software Carpentry Lessons Learned http://f1000research.com/articles/3-62/v1 [Slides](http://swcarpentry.github.io/slideshows/lessons-learned/index.html)
- Good Enough Practices for Scientific Computing [github](https://github.com/swcarpentry/good-enough-practices-in-scientific-computing), [web](http://swcarpentry.github.io/good-enough-practices-in-scientific-computing/)

- Workflows and project organization

	- What do DataCarpentry, SoftwareCarpentry and Stat 545 suggest?
	- Noble Quick Guide to Organizing Computational Biology Projects. http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424
	- Project Template https://cran.r-project.org/web/packages/ProjectTemplate/index.html
	- http://nicercode.github.io/blog/2013-05-17-organising-my-project/
	- http://stats.stackexchange.com/questions/10987/what-are-efficient-ways-to-organize-r-code-and-output
	- http://www.r-statistics.com/2010/09/managing-a-statistical-analysis-project-guidelines-and-best-practices/
	- http://www.r-statistics.com/2010/09/managing-a-statistical-analysis-project-guidelines-and-best-practices/
	- http://www.stat.ubc.ca/~jenny/STAT545A/block01_basicsWorkspaceWorkingDirProject.html
	- http://blog.revolutionanalytics.com/2010/10/a-workflow-for-r.html
	- https://www.reddit.com/r/bioinformatics/comments/3rdlhf/help_how_do_you_organize_your_projectsfiles/
	- http://stackoverflow.com/questions/3759723/best-way-to-organize-bioinformatics-projects
	- http://christianlemp.com/blog/2014/02/05/How-I-Manage-Data-Projects-with-RStudio-and-Git.html

# Interactive Courses for R

## Data Camp

See course list [here](https://www.datacamp.com/courses)

* [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r): Cover as first
* [Intermediate R](https://www.datacamp.com/courses/intermediate-r) Probably not needed in this course. Loops, functions, apply family, utilities (dates, regex). Some of these useful, but may be better for 503.
* [Data Manipulation with dplyr](https://www.datacamp.com/courses/dplyr-data-manipulation-r-tutorial) Definitely cover in 501
* [Data Analysis in R, the data.table way](https://www.datacamp.com/courses/data-table-data-manipulation-r-tutorial) We're going to use dplyr in 501/503.
* [Reporting with R Markdown](https://www.datacamp.com/courses/reporting-with-r-markdown) Useful tutorial to R markdown
* [Introduction to Statistics](https://www.datacamp.com/introduction-to-statistics) Some of the tutorials may be useful. Intro, Student's t test, Analysis of Variance, Repeated measure Anova, Correlation and Regression, Multiple regression
* [How to work with Quandl in R](https://www.datacamp.com/courses/quandl-r-tutorial)
* [Data visualization in R with ggvis](https://www.datacamp.com/courses/ggvis-data-visualization-r-tutorial) Ignore. Going to use ggplot2 for 501/503. Will move to ggvis relatively soon as it matures.
* [Data Analysis and Statistical Inference](https://www.datacamp.com/courses/statistical-inference-and-data-analysis) Cetinkaya-Rundel's course. Possibly some interest.
* EdX Texas Foundations of Data Analysis, [Part 1: Statistics Using R](https://www.edx.org/course/foundations-data-analysis-part-1-utaustinx-ut-7-10x) and [Part 2: Inferential Statistics](https://www.edx.org/course/foundations-data-analysis-part-2-utaustinx-ut-7-20x)

## TryR

The O'Reilly Codeschool very simple intro to R: http://tryr.codeschool.com/

## Swirl

- Data Analysis
- Exploratory Data Analysis
- Getting and Cleaning Data
- Statistical Inference
- Regression Models
- OpenIntro Stats

# Papers for Data Replication or Assignments

- Devil in the Details http://www.nyu.edu/projects/beber/files/Beber_Scacco_The_Devil_Is_in_the_Digits.pdf. Beber and Scacco on Iran election (Hattip: Dartmouth GOV10)
- Gledisch and Ruggeri (2010) "Political opportunity structures, democracy, and civil war" *JPR* http://jpr.sagepub.com/content/47/3/299.full.pdf (Hattip: Dartmouth GOV10)
- Loewen, Koop, Settle, and Fowler (2014) "A Natural Experiment in Proposal Power and Electoral Success" *AJPS* http://onlinelibrary.wiley.com/doi/10.1111/ajps.12042/abstract (Hattip: Dartmouth GOV10)
- Panagopoulos (2013) "Extrensic Rewards, Intrinsic Motivation, and Voting" *JOP* http://journals.cambridge.org/action/displayAbstract?fromPage=online&aid=8820778&fileId=S0022381612001016 (Hattip: Dartmouth GOV10)
- Gerber, Green, and Larimer (2008, APSR) (Hattip: Harvard GOV 2000)
- Acemoglu, Johnson, and Robinson (2001, AER)  (Hattip: Harvard GOV 2000)
- Nunn and Wantchekon (2011, AER) (Hattip: Harvard GOV 2000)
- Fisman and Miguel "Corrupation, Normals and Legal Enforcement: Evidence from Diplomatic Parking Tickets" http://emiguel.econ.berkeley.edu/research/corruption-norms-and-legal-enforcement-evidence-from-diplomatic-parking-tickets
- Chen "The Effect of Language on Economic Behavior" *AER* https://www.aeaweb.org/articles.php?doi=10.1257/aer.103.2.690
- Titanic Dataset
- Challenger Dataset
- Gapminder Data
- ANES
- OpenEvent Data; ACLED
- Polity - look at index
- Hainmueller and Hiscox, 2010. "Attitudes toward Highly Skilled and Low-skilled Immigration: Evidence from a    Survey Experiment" *APSR* http://dx.doi.org/10.1017/S0003055409990372 In *SMISS*
- Beissiger 2002 *Nationalist Mobilization and the Collapse of the Soviet State*. Data is [here](http://www.princeton.edu/~mbeissin/research1.htm#Data). Used in *SMISS*
- Reinhardt and Rogoff, 2010. "Growth in a Time of Debt" *AER* 10.1257/aer.100.2.573 In *SMISS*
- Herndon, Ash, and Pollin, 2014. "Does High Public Debt Consistently Stifle Economic Growth? A Critique of Reinhardt and Rogoff" *Cambridge Journal of Economics* Data [here](http://www.peri.umass.edu/236/hash/31e2ff374b6377b2ddec04deaa6388b1/publication/566/) In *SMISS*
