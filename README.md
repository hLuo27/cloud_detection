# cloud_detection

- [Final Report](.pdf)
- [Raw Word Document](.doc)
- [R Code](.Rmd)
- [CV Generic Function](.R)
- [Data](/image_data)

To reproduce the report, first download the Rmd file as well as the images, located in the [image_data folder](/image_data). Put the folder and the Rmd file in the same directory, and then open the Rmd file. If working with the same data, simply knit the file to a pdf to replicate the results in this report.

If working with new data, a few modifications will have to be made to the code. First of all, in the third chunk called read, the number of files will have to be changed depending on the number of new images. If there are now fewer images, obviously some of the read.table function calls will have to be removed and vice versa if there are now older images. In dealing with the specific case where a researcher in the future wishes to check whether the results hold with new image files that correct errors in the previous image files, there are still 3 images so no changes need to be made in the number of function calls. However, the names of the files will have to be changed to match the new file names, of course keeping in mind which directory they are located in. If the format of the data is different as well, it may be more convenient to use a different function to read.table or to add more arguments to the function call of read.table, if the data is stored as a CSV for example. 

In addition, changes may need to be made to the following code chunk called bind if the names of the features are different from the names of the features in the original image files, with specific changes needing to be made to the definition of the vector "name_of_features", replacing the names of the features from the original image files with the names of the features from the new image files.

Furthermore, splitting the data may be different if the specific scenario where there are 3 updated images no longer holds. If there still are 3 images, however, no changes would be required in the code as Method A is based on the dimensions of the picture being processed without hard-coding and Method B would still involve setting one of the images for each dataset. 

The CVgeneric function performs k-fold cross validation for a general classification model. It takes in 6 arguments, the classifier (a function that represents the classifier that is to be used), the training set (X_train), the training set labels (y_train), the number of folds for the cross-validation (k), the loss function (a function that returns a metric assessing the performance of a classifier), and an optional argument with the number of neighbours to use in k-nearest-neighbours classifier (knn_k). An example of a function call is  CVgeneric(lda, combined_a %>% select(-label), combined_a$label, 5, accuracy_metric) to perform 5-fold cross validation for a LDA classifier. The output is a vector of length k+1, with the first element being the average k-fold CV loss, and the remaining k elements being the loss for each fold. 