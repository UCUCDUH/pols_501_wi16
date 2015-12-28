To manage the python dependencies use conda environments.  See the conda [docs](http://conda.pydata.org/docs/using/envs.html#export-the-environment-file) for more info.

To create the environment using the file `environment.yml`

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

