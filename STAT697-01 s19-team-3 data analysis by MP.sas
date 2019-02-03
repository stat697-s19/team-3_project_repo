* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that will generate final analytic file;
%include '.\STAT697-01_s19-team-3_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there evidence that countries with a greater % of "Inequality of 
Education" also suffer from greater poverty as measured by the "Multidimensional
Poverty Index"?
Rationale: This would indicate if there is an assocation between eduaction 
inequality and poverty, and if the former can be an indicator of poverty in a 
country.
Note: This compares the column "Inequality of Education" from 2018 Statistical 
Annex Table 3 to the column "Multidimensional Poverty Index" from 2018 
Statistical Annex Table 6.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there a strong association between "Mean years of schooling" and 
the "Multidimensional Poverty Index" by gender?
Rationale: This would show is their is an association between average years of 
schooling and poverty levels per country, and would also indicate if their is a
significant difference in the strength of assocation by gender.
Note: This compares the columns "Female" and "Male" under "Mean years of schooling" 
from 2018 Statistical Annex Table 4 each to the column "Multudimensional Poverty 
Index" from 2018 Statistical Annex Table 6.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Can % of "Population living below the income poverty line", specifically, 
the "national poverty line" for 2006-2017 be used to predict the country's "Human
Development Index (HDI)"?
Rationale: This can help to see how poverty levels are associated with a country's 
Human Development Index value, which assesses a country's development.
Note: This compares the column "National poverty line" from 2018 Statistical 
Annex Table 6 to the column "Human Devlopment Index (HDI)" from 2018 Statistical
Annex Table 3.
;

