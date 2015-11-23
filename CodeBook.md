#TITLE: CODE BOOK

#PURPOSE:  
	Describes the variables, the data, and transformations or work performed to clean up

#INTRODUCTION:

	One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
	Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
	The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
	A full description is available at the site where the data was obtained: 

	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

	Here are the data that is used for this Project

	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


	Please refer to UCI HAR Dataset\README.TXT and UCI HAR Dataset\features_info.txt for details about the raw data.
	
	

#PRELIMINARY FINDINGS:  
	The test and train data sets have similar format.  The common information for both of these data sets is:
		F.1) features.txt contains 561 different features or measurements that were taken
		F.2) features_info.txt contains descriptions of the above different measurements
		F.3) activity_labels.txt contains the the numerical id of 6 different activities for which above activities were performed. 1 means walking.  2 means walking upstairs and so on.
		F.4) subjects range from 1 to 30.  These refer to a person1, person2....and so on till person30.
		
		Test Data Set:
		F.5)X_test.txt contains all the measurements - 2947 rows of 561 columns.  This implies that each column corresponds to one of the measurements in features.txt
		F.6)Y_test.txt contains 2947 rows of 1 column.  The values range from 1 to 6.  This implies that each row corresponds to one of 6 activities in activity_labels.txt and goes with the entries in X_test.txt
		F.7) subject_test.txt contains 2947 rows of 1 column.  The values range from 1 to 30.  This implies that each row corresponds to one of the subject(volunteers) and goes with the entries in X_test.txt
		
		Train Data Set: has similar format as Test Data Set but has 7952 records.
		
#STEPS TAKEN TO GENERATE TIDY DATA FROM RAW DATA:

	1) Read the test data set files X_test.txt, y_test.txt, subject_test.txt into data frames
	2) Name the y_test data frame to activity because these correspond to activity (see F.6)
	3) Name the subject_test data frame to person because these correspond to person number(see F.4 and F.7)
	4) Read the features from features.txt  (SEE F.2)
	
	5) Repeat the above for train data set with corresponding descripting train variable.
	
	6) Select only the columns containing mean() and std() within their feature names.  
	***NOTE/ASSUMPTION ignoring variable that contain mean without () at the end as they do not meet the criteria for this project ****
	
	7) Combine the test and train data sets using cbind() function.  The above data sets contain same name and number of columns
	
	8) Activity 1, 2, 3 are not descriptive enough.  Using merge function add a column that applies 'walking'/'walking upstairs etc..' as a new column that matches the activity numbers.
	
	9) Group by and Sort the resulting data frames for easy readability.
	
	10) Convert each of the columns to variables using melt command.  This results in a tall data frame that converts feature into a row.
	
	11) Rename columns to descriptive names.  Melt results in columns with 'variable' .  Change it to measuredVariable.
	
	12) Using ddply and summarise functions calculate means
	
	13) Rename the mean to meanOfObservations
	
	14) Reorder the columns to a friendly format to order by activityDescription and person number
	
	15) Save the file with data separated by tabs.
	
#OUTPUT:
	The tidyData.txt file generated has these columns: "activityDescription"		"personID"		"measuredVariable"		"meanOfObservations"
	"activityDescription"	- refers to the activity - walking, walkingUpstairs etc..	
	"personID"		- refers to the subject or person or volunteer number
	"measuredVariable"	- refers to actual measurement.  See 	F.2 above
	"meanOfObservations"- mean value of the number of observation for each person, activity and measuredVariable(feature) 
	
	tidyData.txt can be read using read.table() command.
	

#NOTES
	tidyData.txt contains data that is more readable and easier to understand than the raw data.  
	SORT ORDER - Data within tidyData.txt can be sorted to desired format - such as by person first, then by activityDescription, then measuredVariable if desired.  Other sort orders may be easier to use depending on how data will be used by the user.
