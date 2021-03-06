library(class)
library(gmodels)

# read the csv file
wdbc <- read.csv("wdbc.data", stringsAsFactors = FALSE)

# remove the id column
wdbc <- wdbc[-1]

# transform the diagnosis feature into a column
wdbc$diagnosis <- factor(wdbc$diagnosis, levels = c('B', 'M'),
                         labels = c('Benign', 'Malignant'))

# randomly permute examples in the data frame
wdbc <- wdbc[sample(nrow(wdbc)), ]

# print out the range for each mean feature
cat("\nRanges of the 10 first features in the dataset:\n")
print(lapply(wdbc[2:11], function(x) { max(x) - min(x) }))

# normalize our numeric features removing the diagnosis feature since it's a
# factor
wdbcNormalized <- as.data.frame(scale(wdbc[-1]))

# print out the mean of a few features
cat("\n\nMeans for 3 features after scaling:\n")
print(summary(wdbcNormalized[c('radius_mean', 'area_worst', 'symmetry_se')]))

# take the first 427 examples as our training set without the diagnosis feature
wdbcTraining <- wdbcNormalized[1:427, ]

# take the last 142 examples as our test set without the diagnosis feature
wdbcTest <- wdbcNormalized[428:569, ]

# store the diagnosis factor into a separate variable
wdbcTrainingLabels <- wdbc[1:427, 1]
wdbcTestLabels <- wdbc[428:569, 1]

# use the knn function of the class package
k <- 21
wdbcPredictedLabels <- knn(train = wdbcTraining,
                           test = wdbcTest,
                           cl = wdbcTrainingLabels,
                           k)

# compute the percentage of right predictions
actualVsPredicted <- cbind(wdbcTestLabels, wdbcPredictedLabels)
colnames(actualVsPredicted) <- c('actual', 'predicted')
percentage <- sum(apply(actualVsPredicted, 1,
                        function(row) { ifelse(row[1] == row[2], 1, 0) }
                        )) / dim(actualVsPredicted)[1]
cat("\n\nPercentage of examples correctly classified:\n")
print(percentage)

# display a crossTable
cat("\n\nCrosstable of the actual classes of the examples in the test set",
    "versus the predicted classes:\n")
CrossTable(x = wdbcTestLabels, y = wdbcPredictedLabels,
           prop.chisq = F, dnn = c('actual', 'predicted'))
