library(class)
library(gmodels)

# read the csv file
wdbc <- read.csv("wdbc.data", stringAsFactors = FALSE)

# remove the id column
wdbc <- wdbc[-1]

# transform the diagnosis feature into a column
wdbc$diagnosis <- factor(wdbc$diagnosis, levels = c('B', 'M'),
                         labels = c('Benign', 'Malignant'))

# randomly permute examples in the data frame
wdbc <- wdbc[sample(nrow(wdbc)), ]

# print out the range for each mean feature
print(lapply(wdbc[2:11], function(x) { max(x) - min(x) }))

# normalize our numeric features removing the diagnosis feature since it's a
# factor
wdbcNormalized <- as.data.frame(scale(wdbc[-1]))

# print out the mean of a few features
print(summary(wdbcNormalized[c('radius_mean', 'area_worst', 'symmetry_se')]))

# take the first 427 examples as our training set without the diagnosis feature
wdbcTraining <- wdbcNormalized[1:427, ]

# take the last 142 examples as our test set without the diagnosis feature
wdbcTest <- wdbcNormalized[428:569, ]

# store the diagnosis factor into a separate variable
wdbcTrainingLabels <- wdbc[1:427, 1]
wdbcTestLabels <- wdbc[428:569, 1]
