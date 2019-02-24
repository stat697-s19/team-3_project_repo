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
Question: Is there evidence to indicate countries with a greater % of 
"Inequality in Education" also experience greater poverty as measured by 
the "Multidimensional Poverty Index"?

Rationale: This test would indicate an association between education and 
poverty and if poverty can be an indicator of education. 

Note: This compares the column "Inequality of Education" from 2018 
Statistical Annex Table 3 to the column "Multidimensional Poverty Index" from 
2018 Statistical Annex Table 6.

Limitations: Values denoted as ".." for the column "Inequality of Life 
Expectancy" should be excluded from analysis since it represents missing values.
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
*
Question: Is there a strong association between "Mean years of schooling" and
the "Multidimensional Poverty Index" by gender?

Rationale: This would show if there is an association between poverty levels 
within a country and schooling between genders.

Note: This compares the column "Mean years of schooling" from 2018 Statistical 
Annex Table 4 to the column "Multudimensional Poverty Index" from 2018 
Statistical Annex Table 6.

Limitations: missing values need to be addressed for glm and general data analysis
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
*
Question: Can % of "Population living below the income poverty line" for 
2006-2017 be used to predict the country's "Coefficient of human inequality"?

Rationale: This can help to see how poverty levels are associated with a 
country's inequality. 

Note: This compares the column "Population_living_below_national_poverty_line" 
from 2018 Statistical Annex Table 6 to the column "Coefficient of human 
inequality" from 2018 Statistical Annex Table 3.

Limitations: missing values need to be addressed for glm and general data analysis
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
