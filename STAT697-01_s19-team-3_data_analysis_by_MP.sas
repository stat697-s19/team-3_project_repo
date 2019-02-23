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
'Question: Is there evidence that countries with a greater % of "Inequality of Education" also suffer from greater poverty as measured by the "Multidimensional Poverty Index"?'
;
title2 justify=left
'Rationale: This would indicate if there is an assocation between eduaction inequality and poverty, and if the former can be an indicator of poverty in a country.'
;

*
Note: This compares the column "Inequality of Education" from 2018 Statistical 
Annex Table 3 to the column "Multidimensional Poverty Index" from 2018 
Statistical Annex Table 6.

Limitations: Values denoted as ".." for the column "Inequality of Education" 
should be excluded from analysis since they represent missing values.

Methodology: Use proc corr to perform a correlation analysis, and then use proc
sgplot to output a scatterplot to illustrate the correlation.

Followup Steps: Perform a more formal linear regression analysis to measure the 
degre of association between the two variables and the type of relationship.
;


title3 justify=left
'Correlation analysis for Inequality_in_education and Multidimensional_Poverty_Index'
;

proc corr 
	    data=country_analytic_file_raw
    ;
	var 
        Inequality_in_education 
        Multidimensional_Poverty_Index
    ;
run;

proc sgplot data=country_analytic_file_raw;
    scatter
        x=Inequality_in_education
        y=Multidimensional_Poverty_Index
    ;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Is there a significant difference in the average years of schooling by gender among the countries?'
;

title2 justify=left
'Rationale: This would show is their is an association between average years of schooling per country and gender and could possibly indicate gender disadvantages.'
;

*
Note: This compares the columns "Female" and "Male" under "Mean years of schooling" 
from 2018 Statistical Annex Table 4 each to the column "Multudimensional Poverty 
Index" from 2018 Statistical Annex Table 6.

Limitations: Values denoted as ".." for the columns "Mean years of schooling" 
for both "Female" and "Male" should be excluded from analysis since they represent
missing values.

Methodology: Use proc sql to create a table for each gender, Mean_years_schooling_f 
and Mean_years_schooling_m, listing characteristic values of the data including 
the min, max, mean and median.

Followup Steps: Use proc ttest to perform a comparison of group means between the
two genders for mean years of schooling.
;

proc sql;
   	select
	 min(Mean_years_of_schooling_female) as min
	,max(Mean_years_of_schooling_female) as max
	,mean(Mean_years_of_schooling_female) as mean
	,median(Mean_years_of_schooling_female) as median
    from
	country_analytic_file_raw
   	;
quit;

proc sql;
   	select
	 min(Mean_years_of_schooling_male) as min
	,max(Mean_years_of_schooling_male) as max
	,mean(Mean_years_of_schooling_male) as mean
	,median(Mean_years_of_schooling_male) as median
    from
	country_analytic_file_raw
   	;
quit;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
"Question: Can % of Population living below the income poverty line for 2006-2017 be used to predict the country's HDI?"
;

title2 justify=left
"Rationale: This can help to see how poverty levels are associated with a country's Human Development Index value, which assesses a country's development."
;

*
Note: This compares the column "Population_living_below_national_poverty_line" 
from 2018 Statistical Annex Table 6 to the column "HDI" from 2018 Statistical 
Annex Table 3.

Limitations: Missing values for the column "Population living below 
national poverty line" should be excluded from analysis as there are 10 missing
values indicated.

Methodology: Use proc corr to perform a correlation analysis, and then use proc
sgplot to output a scatterplot to illustrate the correlation.

Followup Steps: Perform a more formal linear regression analysis to measure the 
degre of association between the two variables and the type of relationship.
;

title3 jusitfy=left
'Correlation analysis for Population_living_below_national and HDI'
;

proc corr 
	data=country_analytic_file_raw
    ;
	var  
        Population_living_below_national
        HDI
    ;
run;

proc sgplot data=country_analytic_file_raw;
    scatter
        x=Population_living_below_national
        y=HDI
    ;
run;
