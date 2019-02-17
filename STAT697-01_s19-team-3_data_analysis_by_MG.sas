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
*
Question: Which country has the highest inequaality-adjusted education index?

Rationale: This should help identify the which country has the lowest education 
index and make appropriate action 

Note: This compares the column "Country" to 
the column of "Inequality-adjusted life expectancy Index from 2018 
Statistical_Annex_Table_3.

Limitations: The value in this dataset need to be numeric to perform mean and 
median calculation. 
;

Proc sort data=Annex_Table_3_and_4_v2;
By Country;
proc print;
Run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the correleation between year of school and income per capita?

Rationale: This should help demonstrate whehter school can be a important factor 
in national income value. 

Note: This compares the column "Expected years of 
schooling" to the column "Estimated gross national income per capita" from 
2018 Statistical_Annex_Table_4

Limitations: The value in this dataset need to be numeric to perform mean and 
median calculation
;

proc sgplot data=Annex_Table_3_and_4_v2;
  scatter x=Year_School_Female y=Estimated_gross_national_income_;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question:Which country is experiencing the most severe multidimensional poverty?

Rationale: This should help Non-profit organizaion to appropriate allocate 
resources to the needest country. 

Note: This compares the column "Country" from 
sat15 to the column "Population in severe multidimensional poverty from 2018 
Statistical_Annex_Table_6.

Limitations: missing value may need to removed to perform general linear model
;

Proc sort data=Annex_Table_3_and_4_v2;
By Country;
proc print;
Run;
