*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that will generate final analytic file;
%include '.\STAT697-01_s19-team-3_data_preparation.sas';

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1 justify=left
'Research Question: Which country has the highest inequaality-adjusted life expectancy index?'
;

title2 justify=left
'Rationale: This should help identify the which country has the lowest education index and make appropriate action'
;

footnote1 justify=left
'The country has the most life expectancy index does not always has the highest human development index.'
;

*
Note: This compares the column "Country" to 
the column of "Inequality-adjusted life expectancy Index from 2018 
Statistical_Annex_Table_3.

Limitations: The value in this dataset need to be numeric to perform mean and 
median calculation. 

Methodology: To proc sort the data in descending order and find the country 
has the highest lift expectancy index which is Albania

Followup Steps: Clear out any missing value.
;

* output first five row of resulting sorted data to better visualize the results;

proc sort 
	data=country_analytic_file_raw (obs=5)
	out = country_analystic_file_raw_Q1;
    ;
    by 
	descending adjusted_life_index;
run;
	
proc report data=country_analystic_file_raw_Q1;
	columns
	       	Country
		adjusted_life_index
    ;
run;

* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question: What is the correleation between year of school and income per capita?'
;

title2 justify=left
'Rationale: This should help demonstrate whehter school can be a important factor in national income value.'
;

footnote1 justify=left
'Based on the correlation table, there is a positive correlation between these two variable'
;

*
Note: This compares the column "Expected years of 
schooling" to the column "Estimated gross national income per capita" from 
2018 Statistical_Annex_Table_4

Limitations: The value in this dataset need to be numeric to perform mean and 
median calculation

Methodology: To plot a scatterplot to visualize the trend of the reseach question.
According to the graph, the longer of the female education, the higher of the female 
gross national income

Followup Steps: Run a linear regresssio analysis to determine whether there is a 
strong correleation between the two variables.;

* Construct a scatter plot to show the relationship between the two interested 
variable;

proc sgplot 
	data=country_analytic_file_raw;
  	scatter x=Year_School_Female y=Estimated_gross_national_income_;
run;

data new; set country_analytic_file_raw;

   	numeric_var = input(Year_School_Female, best5.);
      
     where

   	numeric_var = input(Year_School_Female, best5.);
      
     where
     
        not(missing(Year_School_Female))
    ;
run;

   
data work; set country_analytic_file_raw;
		Year_School_Female2 = input(Year_School_Female, best7.);
		Estimated_income_fe = input(Estimated_gross_national_income_, best7.);
run;

proc corr
        data=work
        nosimple
    ;
    var
        Year_School_Female2
        Estimated_income_fe
    ;
run;
    where
        not(missing(Year_School_Female2))
        and
        not(Estimated_income_fe))
    ;
run;

* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question: Which country is experiencing the most severe multidimensional poverty?'
;

title2 justify=left
'Rationale: This should help Non-profit organizaion to appropriate allocate resources to the needest country.'
;

footnote1 justify=left
'Looks like majority of afrian country are in severe multidimenstional poverty'
;

*
Note: This compares the column "Country" from 
sat15 to the column "Population in severe multidimensional poverty from 2018 
Statistical_Annex_Table_6.

Limitations: missing value may need to removed to perform general linear model

Methodology: To sort the selected variable and find the highest severe 
multidimensional poverty.

Followup Steps: To make a boxplot of the data to see the distribution of data
;

* To sort the data in descending order to find the max value;

proc sort 
	data=country_analytic_file_raw
   ;
   by 
	descending Population_in_severe_multidimens;
run;

proc print;
run;

* clear titles/footnotes;
title;
footnote;
