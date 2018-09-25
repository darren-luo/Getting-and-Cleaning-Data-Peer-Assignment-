# Getting-and-Cleaning-Data-Peer-Assignment-
Repo for Course 3 (Getting and cleaning data - Peer Assignment)

Step by Step Explanation of Code:

1) Read all relevant files into R.
 - 2 files that labels activities and features
 - 6 files (3 from each Test and Training datasets) that contain data pertaning to subjects, activity and raw data
  
2) Once files are read, they are then converted into tbl_df format via the dplyr package. From there we can start to look at the dimensions of the files which would provide an indication of the structure of the data (i.e dimensions, layout, column labels) and which variables need to be extracted (e.g. Mean and Std measures) and assign names to data columns
 - The files containing subject, raw data, labels and labels contain the same number of rows each both Test and Training datasets:
 - The raw data contains the same numner of columns as the features_labels files, indicative that the feature_labels files contains the e column names for the raw data since we have been told of the variables that were measured in the features_info file.
 
3) The next step is to determine which columns are relevant for the assignment. We are told to extract the columns containing mean and Stf info, this can be achieved by using the grep() function to search for specific text for mean and std. Wea also determine at this step if the columns extract are unique.
- A total of 86 columns that contain the relevant info is extracted

4) The activity labels are then matched with the respective numbers from the training labels file to assign more useful and descriptive naems to the activities.

5) Up to this stage, we have not merged any of the test and train datasets together and have interacted with each of the sets of data separately. Both sets are joined using a rbind() command to join them by rows since they have the same number of columns.
- An additional column "Dataset" is included in the bind to label each observation with its origin (i.e. Test or Train). This is important because further down the line, if and when there is a need to filter or extract data by its origin, the 'Dataset' label will come in useful.

6) Once the data has been merged, the next step is to give the variables meaningful name. A visual inspection of the features_txt file will and the column names will show two things:
- R has by default included ellipsis "." into the column names
- The feature names have a 'fixed' structure:
  - There are 3 diff types of measurements: 
    1) acceeleration type (body/gyro) by domain by axis (X,Y,Z) by stat. measure (mean, std) 
    2) two derivatives of #1, Jerk measurements and magnitude by acceleration type by domain by axis by stat. measure 
    3) Average Values of signal type (5 types -  bodyacc, bodyaccjerk, bodygyro, bodygyrojerk, gravity) 

7) Knowing this structure, we can then use the sub() function to start assigning more useful names to these variables, by sticking to the default structure given by the data set - [domain][Acceleration Type][stat measure][Axis of measure]
- removing ellipsis "..."
- Indicating the domain of measurement - Time or Frequency
- Clarifying the acceleration type
- Stating the statistical measure that is recorded
- The axis of measurement (if any), else only the magnnitude is recorded and is indicated as such

8) Once the column names are changed. We can then start to present the data in Tidy format. Since we are asked to prepare a tidy table of the mean of the variables, we have to group the data first by subject and then by activity
- Since we have 30 subjects and 6 activities, this results in a data frame of 180 rows by 89 columns
- the summarise_all() function is then applied to the grouped data to get the final tidy dataframe
