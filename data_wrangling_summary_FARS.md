# Data Wrangling summary for FARS data

## About the data
These data were downloaded from the National Highway Traffic Saftey Administration (NHTSA) Fatality Analysis Reporting System (FARS) [FTP site.](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars) 
The data are divided into multiple subfiles and I will be using three.  Data from the [US Census Bureau](https://www2.census.gov/programs-surveys/popest/datasets/) detaling population demographics is also used to adjust state-wide data by population size.

## FARS data and collection
FARS contains data on fatal crashes within the United States.  For a acrash to be included in FARS in must involve both a motor vehicle on a public trafficway and the death of a vehilce occupant within 30 days of the crash.  These data are compiled from a variety of state documents, including police reports, EMS reports, and medical examiner report.  The dataset contains over 100 variables.  

Detailed information about the datasets is avaible in the [FARS User Manual](https://github.com/rlrognstad/springboard_capstone_1/blob/master/1975-2015%20FARS%20Analytical%20User's%20Manual.pdf)

### Subfiles
#### Accident
One record per crash, data about the ecrash location and characteristics, including weather conditions
#### Person
One record per person involved in the crash, including people who were not in the vehicle, like pedestrians.  Contains information about people, sich as age, injury severity, and restraint use.
#### Vehicle
One record per vehicle involved in the crash, contains information like the make and model of the vehicle.

### Data formats

The census data and 2015 FARS datasets are avaible in csv format and can be imported into python with pandas.  The 2011-2014 FARS data are available in SAS and DBF format.  I chose to use the DBF files and used functions within the dbfread package to import the files and convert them to pandas dataframes.


### Wrangling
For each tyoe of file, I imported the data into python and converted it to a data frame.  After adding a new column for year, i merged all of the data into one dataframe.  The location information about the crash is only present in the accident file, so I extracted it and merged it with the vehicle and person dataframes.  I then wrote these files to csv to use in data exploration.  
For the census file, the years were coded as sigle digit numbers, so I recoded them as the actual yearly value.  
There are some missing values that I have left in at this point.  I will remove records with missing values in relavant features on an analysis basis.  
