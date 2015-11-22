# Download the data 
urlfile<- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip?accessType=Download"
download.file(urlfile, destfile="./Data.zip")
unzip('Data.zip')