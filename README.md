# United States 2020 Prediction with Multilevel Modeling (MRP) with Post-Stratification 
We use Multilevel Modeling with Post-Stratification to predict the outcome of the 2020 Election. The data that we used in the analysis can be found in the following links.
## Analysis
### Democracy Fund + UCLA Nationscape Data
The dataset can be found at https://www.voterstudygroup.org/publication/nationscape-data-set. After the data is downloaded, follow the following steps to reproduce the analysis.

1. Place the data into the input folder
2. Open up the "01-data_cleaning-survey.R" file located in the script folder
3. Find the line that imports the dataset. (raw_data <- read_dta("inputs/data/ns20200625.dta"))
4. Change the file path to the file name that you have on your computer
5. Run the entire script "01-data_cleaning-survey.R," and your data for the first step of MRP will be ready


### American Community Survey Data
The dataset can be found at https://usa.ipums.org/usa/index.shtml. Before clicking on "Create your custom dataset," you will have to register an account with 
IPMUS. After register, the account, follow the steps below to retrieve the dataset for this analysis. 

1. Change the Sample to 2018 ACS after a click on "Create your custom dataset."
2. Search for the following variables: States (stateicp), Gender(sex), Age(age), Race (race), Birthplace(bpl), Detailed Education Level (educd), Employment Status (empstat), and Income Level (inctot).
3. After finish searching for the variables and add into the Cart, you can start checking out.
4. During the Checkout, select file type fo STATA (.dta)
5. Open up the "01-data_cleaning-survey-post-strat.R" file located in the script folder
6. Find the line tha imports the dataset. (raw_data <- read_dta("inputs/data/usa_00004.dta"))
7. Change the file path to the file name that you have on your computer
8. Run the entire script "01-data_cleaning-survey-post-strat.R," and your data for the first step of MRP will be ready

### Modeling
After getting both datasets, you can open up the "data_analysis_script.Rmd" to start reproducing th analysis. 

## Files Introduction
- data_analysis_script.Rmd: Contains the analysis code in R and the raw file for the report
- data_analysis.pdf: The official report for this analysis
- Input: your data will be in this file and check that you have these two files:
  - ind_level.csv
  - post_level.csv
- Output: this folder contains the models and the prediction of the analysis. "data_analysis_script.Rmd" will directly import these already made model results to save the user time.
- us_election.Rproj: is the R Project file for this analysis
