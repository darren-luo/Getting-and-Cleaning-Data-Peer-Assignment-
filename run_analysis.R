## First step is to read the relevant files into R and assign them to variable names

## Read feature_txt. file to get the correspodning feature variable names which we will need to assign to the columns in the test and train data
    features_labels <- tbl_df(read.table("./features.txt", header = FALSE, sep = "", stringsAsFactors = FALSE, check.names = FALSE))

## read activity_labels.txt to get dataframe of activity labels
    activity_labels <- tbl_df(read.table("./activity_labels.txt", header = FALSE, sep = "", stringsAsFactors = FALSE, col.names= c("Activity", "Activity Description")))

    
## Read Test and training files in the right format and convert each to tbl_df format in dplyr.
    test_subjects <- tbl_df(read.table("./test/subject_test.txt", header = FALSE, col.names = "Subject")) 
    test_labels <- tbl_df(read.table("./test/y_test.txt", header = FALSE, col.names = "Activity"))
    test_data <- tbl_df(read.table("./test/x_test.txt", header = FALSE, sep = "", col.names = as.list(features_labels$V2)))
    
    training_subjects <- tbl_df(read.table("./train/subject_train.txt", header = FALSE, col.names = "Subject"))
    training_labels <- tbl_df(read.table("./train/y_train.txt", header = FALSE, col.names = "Activity"))
    training_data <- tbl_df(read.table("./train/x_train.txt", header = FALSE, sep = "", col.names = as.list(features_labels$V2)))

## Determine the columns that need to be extracted - mean and std measures, and checks if these columns are unique and are not duplicated  within the respective subset
    means_col <- grep("[Mm]ean", features_labels$V2, value = T) ## columns which contain mean values
    std_col <- grep("std()", features_labels$V2, value = T) ## columns that contain std values
    
    if(length(unique(means_col) < length(means_col))){
        means_col <- unique(grep("[Mm]ean", features_labels$V2))
    }
    means_col <- grep("[Mm]ean", features_labels$V2)
    
    if(length(unique(std_col) < length(std_col))){
        std_col <- unique(grep("std()", features_labels$V2))
    }
    std_col <- grep("std()", features_labels$V2)

## Extract the data(columns) that are required - Qns 2)
    test_data <- select(test_data, means_col, std_col)
    training_data <- select(training_data, means_col, std_col)

## Add activity description to activity numbers - Qns 3) by matching them against activity_labels.txt fil
    training_labels <- left_join(training_labels, activity_labels)
    test_labels <- left_join(test_labels, activity_labels)
        
      
## Merge individual datasets separately and mutate merged set to include another column ("Dataset") that labels the data by their origin i.e. Test, or Training)
    test_dataset <- bind_cols(bind_cols(test_subjects, test_labels[,2]) %>% mutate(Dataset = "test"), test_data)
    training_dataset <- bind_cols(bind_cols(training_subjects, training_labels[,2]) %>% mutate(Dataset = "training"), training_data)

## Merge both test and training datasets into one dataframe - Qns 1)
    merged_dataset <- bind_rows(test_dataset, training_dataset) 


## To give the variables meanigngful names - we can first identify the 'structure' of the names - there are 3 diff types of measurements: 1) acceeleration type (body/gyro) by domain by axis by stat. measure 2) two derivatives of #1, Jerk measurements and magnitude by acceleration type by domain by axis by stat. measure 3) Average Values of signal type (5 types -  bodyacc, bodyaccjerk, bodygyro, bodygyrojerk, gravity) 
## First step is to sub out ellipsis - there are 3 categories or ellipsis each of different lengths  "...", "..", "." - each of these need to be replaced by spaces
    names(merged_dataset) <- sub("\\.\\.\\.", " ", names(merged_dataset))
    names(merged_dataset) <- sub("\\.\\.", " ", names(merged_dataset))
    names(merged_dataset) <- sub("\\.", " ", names(merged_dataset))
    names(merged_dataset) <- sub("\\.$", "", names(merged_dataset))
    
    names(merged_dataset) <- sub("X", "X Axis", names(merged_dataset))
    names(merged_dataset) <- sub("Y", "Y Axis", names(merged_dataset))
    names(merged_dataset) <- sub("Z", "Z Axis", names(merged_dataset))
    names(merged_dataset) <- sub("Freq", "(Weighted Average)", names(merged_dataset))
    names(merged_dataset) <- sub("BodyBody", "Body", names(merged_dataset))
    names(merged_dataset) <- sub("^fBody", "Frequency: Body-", names(merged_dataset))
    names(merged_dataset) <- sub("^tBody|tBody", "Time: Body-", names(merged_dataset))
    names(merged_dataset) <- sub("^tGravity", "Time: Gravity-", names(merged_dataset))
    names(merged_dataset) <- sub("gravityMean|\\.gravity", "", names(merged_dataset))
    
    names(merged_dataset) <- sub("Mean", " mean", names(merged_dataset))
    names(merged_dataset) <- sub("Mean", "", names(merged_dataset))
    names(merged_dataset) <- sub("angle", "Angle\\(\\)", names(merged_dataset))
    names(merged_dataset) <- sub("Mag", " Magnitude", names(merged_dataset))
    names(merged_dataset) <- sub("Jerk", " Jerk", names(merged_dataset))
    names(merged_dataset) <- sub(" $", "", names(merged_dataset))
    names(merged_dataset) <- sub("\\.$", "", names(merged_dataset))
    
## Summarize Tidy data set by grouping by subject and activity  
    
    merged_dataset_tidy <- group_by(merged_dataset, Subject, `Activity Description`, Dataset) %>% summarise_all(funs(mean))
    print(merged_dataset_tidy)

