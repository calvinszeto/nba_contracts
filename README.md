# Predicting NBA Contracts

This is an individual research project for course CS 363D: Introduction to Data Mining
at The University of Texas at Austin.

## Installation and Running

First, a couple R packages need to be installed.

'''
R -f setup.r
'''

Unfortunately, the version of R on the UTCS Linux machines is very out-of-date, so a
dependency for the graphing libraries cannot be installed on those machines.

I have edited the scripts to instead output summary statistics on each cluster. The
original scripts are contained in the `scripts` directory in case they are run on a
machine with an updated version of R.

To run the scripts:

'''
# K-Means
R -f kmeans.r

# PCA + K-Means
R -f kmeans.pca.r

# Spectral Clustering
R -f sc.r
'''

### Layout

The clustering algorithms and functions are stored in the `cluster` directory. `nba_kmeans.r`
is the self-implemented Lloyd-Forgy algorithm, and the other clustering algorithms are
used in `regular_kmeans.r`.

Scraped and downloaded data are all in the `data` directory.

Scrapers are in the `fa_scraper` and `salary_scraper` directories.

Preprocessing scripts are in the `preprocess` directory.

Plots are in the `plots` directory.
