CVgeneric <- function(classifier, X_train, y_train, k, loss_fn, knn_k = 3){
  folds <- cut(seq(1,nrow(X_train)), breaks=k, labels=FALSE)
  k_losses <- c()
  for (i in 1:k){
    # Training and validation sets for the kth fold
    fold_train = X_train[which(folds != i), c('NDAI', 'SD', 'CORR', 'DF', 'CF','BF','AF','AN')]
    fold_val = X_train[which(folds == i), c('NDAI', 'SD', 'CORR', 'DF', 'CF','BF','AF','AN')]
    # y values for the kth fold
    y_fold_train = y_train[which(folds != i)]
    y_fold_val = y_train[which(folds == i)]
    # Do this if a knn classifier
    if("knn" == as.character(substitute(classifier))){
      # First standardize the explanatory variables, then add the response variable back as a factor
      knn_train = scale(fold_train) %>% as.data.frame() %>% mutate(label = as.factor(y_fold_train))
      knn_val = scale(fold_val) %>% as.data.frame() %>% mutate(label = as.factor(y_fold_val))
      # k value determined using basic elbow method in scree plot above
      model = knn3(label~., data = knn_train, k = knn_k)
      y_fold_predicted = predict(model, knn_val, type = "class")
      k_losses <- c(k_losses, loss_fn(y_fold_predicted, y_fold_val))
    }
    # Otherwise, do this for decision tree
    else if("rpart" == as.character(substitute(classifier))){
      model = rpart(label~., data = fold_train %>% mutate(label = y_fold_train), method = "class")
      y_fold_predicted = predict(model, fold_val, type = "class")
      k_losses <- c(k_losses, loss_fn(y_fold_predicted, y_fold_val))
    }
    # Otherwise this is lda, qda, or logistic regression model
    else{
      # Fit model for the kth fold 
      model = classifier(label ~., data = fold_train %>% mutate(label = y_fold_train))
      # If it's a lda or qda model, need to access the class of model predict output. Note class(glm model) = "glm" "lm" so we can't just do class == "lda"
      if("lda" %in% class(model) | "qda" %in% class(model)){
        y_fold_predicted = predict(model, fold_val)$class 
        k_losses <- c(k_losses, loss_fn(y_fold_predicted, y_fold_val))
      }
      # Otherwise, this is logistic model
      else{
        y_fold_predicted = as.numeric(predict(model, fold_val) > 0)
        y_fold_predicted[y_fold_predicted == 0] = -1
        k_losses <- c(k_losses, loss_fn(y_fold_predicted, y_fold_val))
      }
    }
  }
  return(c(k_fold_cv_loss = mean(k_losses), fold_losses = k_losses))
}
