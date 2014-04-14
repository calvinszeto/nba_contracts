# Clustering

Here, we try to classify NBA players into meaningful clusters.

## Data Sources

Possible data sources include:
* Box Score data, totals
* Box Score data, per game
* Box Score data, per 36 minutes
* Advanced statistics
* Physical characteristics

## Algorithms

### K-Means

We run the K-Means algorithm with for different numbers of clusters until we find a clustering with a relatively low RMSE.

For now, we use the Euclidean distance metric, e.g. the p-norm for a p-feature dataset.
