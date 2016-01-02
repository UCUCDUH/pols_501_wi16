# POLS 501 (Winter 2016)

Repository containing materials and the website for POLS 501: Advanced Political Research Design and Analysis (University of Washington, Winter 2016).

Course website is at https://UW-POLS501.github.io/pols_501_wi16/

## Build


### Dependencies

The python dependencies are handled with [conda](http://conda.pydata.org/docs/using/envs.html#export-the-environment-file).

The conda environment used is named `pols_501_wi16`.
The the environment using the file `environment.yml`
``` shell
$ conda env create -f environment.yml
```
The environment that is created is named `pols_501_wi16`.

To activate the environment if it already exists.
On Linux/OSX:
``` shell
$ source activate pols_501_wi16
```
On Windows:
``` shell
$ activate pols_501_wi16
```

To deactivate the environment on Linux/OSX
``` shell
$ source deactivate 
```
and Windows
``` shell
deactivate
```

If changes are made to the environment (packages deleted, added, or updated) save the chagnes to `environment.yml`.
``` shell
$ conda env export > environment.yml
```
To reinstall the conda environment from `environment.yml`

``` shell
$ source deactivate
$ conda remove --name pols_501_wi16 --all \
  && conda env create -f environment.yml
```

### 

The files for the site are in the directory `web`.
This site is built using the static site generator [Nikola](http://getnikola.com/) with Python 3. 


```console
> source activate 
> cd web
> nikola build
```



<!--  LocalWords:  nikola cd venv python3 pyvenv txt pandoc citeproc
 -->

