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
'Question: Is there evidence that countries with a greater % of Inequality of Education also suffer from greater poverty as measured by the Multidimensional Poverty Index?'
;

title2 justify=left
'Rationale: This would indicate if there is an assocation between eduaction inequality and poverty, and if the former can be an indicator of poverty in a country.'
;


*
Note: This compares the column Inequality of Education from 2018 Statistical 
Annex Table 3 to the column Multidimensional Poverty Index from 2018 
Statistical Annex Table 6.

Limitations: Values denoted as ".." for the column Inequality of Education 
should be excluded from analysis since they represent missing values.

Methodology: Use proc corr to perform a correlation analysis, and then use proc
sgplot to output a scatterplot to illustrate the correlation.

Followup Steps: Perform a more formal linear regression analysis to measure the 
degre of association between the two variables and the type of relationship.
;


title3 justify=left
'Correlation analysis for Inequality_in_education and Multidimensional_Poverty_Index'
;

footnote1 justify=left
'Assuming the variables Inequality in Education and Multidimensional Poverty Index are normally distributed, the data analysis shows that there is a strong positive correlation between percent of inequality in education and the Multidimensional Poverty Index by country.'
;

footnote2 justify=left
'There is a statistically significant correlation with high confidence level since the p-value is less than 0.001.'
;

footnote3 justify=left
'Countries with a greater percent of inequality in education generally have a high Multidimensional Poverty Index which could possibly suggest that a high percent of inqeuality in education could be in indicator of high levels of poverty in a country.'
;


data work1; set country_analytic_file_raw;
Inequality_in_education1 = input(Inequality_in_education, best7.);
Multidimensional_Poverty_Index1 = input(Multidimensional_Poverty_Index, best7.);
run;

proc corr 
	    data=work1
    ;
	var 
        Inequality_in_education1
        Multidimensional_Poverty_Index1
	;
	where
        not(missing(Inequality_in_education1))
        and
        not(missing(Multidimensional_Poverty_Index1))
	;
run;

proc sgplot data=work1;
    scatter
        x=Inequality_in_education1
        y=Multidimensional_Poverty_Index1
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Is there a significant difference in the average years of schooling by gender among the countries?'
;

title2 justify=left
'Rationale: This would show if their is an association between average years of schooling per country and gender and could possibly indicate gender disadvantages.'
;

footnote1 justify=left
'Assuming the mean years of schoolong for female and male are normally distributed, there is a difference of 0.6486 in the gender means, with males have the higher mean.'
;

footnote2 justify=left
'Data analysis with a paired t-test shows strong evidence of a difference in the paired mean years of schooling between females and males with p-value of less than 0.001.'
;

footnote3 justify=left
'The significant difference in means of years of schooling between males and females could indicate gender discrimination or possibly cultural norms that encourage more male years of schooling compared to females.'
;

*
Note: This compares the columns Female and Male under Mean years of schooling 
from 2018 Statistical Annex Table 4 to each other.

Limitations: Values denoted as ".." for the columns Mean years of schooling 
for both Female and Male should be excluded from analysis since they represent
missing values.

Methodology: Use proc sql to create a table for each gender, Mean_years_schooling_f 
and Mean_years_schooling_m, listing characteristic values of the data including 
the min, max, mean and median.

Followup Steps: Use proc ttest to perform a comparison of group means between the
two genders for mean years of schooling.
;

data work; set country_analytic_file_raw;
Mean_years_of_schooling_female1 = input(Mean_years_of_schooling_female, best7.);
Mean_years_of_schooling_male1 = input(Mean_years_of_schooling_male, best7.);
run;


proc sql;
   	select
		 min(Mean_years_of_schooling_female1) as min
		,max(Mean_years_of_schooling_female1) as max
		,mean(Mean_years_of_schooling_female1) as mean
		,median(Mean_years_of_schooling_female1) as median
    from
		work
   	;
quit;

proc sql;
   	select
	 min(Mean_years_of_schooling_male1) as min
	,max(Mean_years_of_schooling_male1) as max
	,mean(Mean_years_of_schooling_male1) as mean
	,median(Mean_years_of_schooling_male1) as median
    from
	work
   	;
quit;

proc ttest;
    paired Mean_years_of_schooling_male1*Mean_years_of_schooling_female1;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Can percent of Population living below the income poverty line for 2006-2017 be used to predict country HDI?'
;

title2 justify=left
'Rationale: This can help to see how poverty levels are associated with Human Development Index value, which assesses country development.'
;

*
Note: This compares the column Population living below national poverty line 
from 2018 Statistical Annex Table 6 to the column HDI from 2018 Statistical 
Annex Table 3.

Limitations: Missing values for the column Population living below 
national poverty line should be excluded from analysis as there are 10 missing
values indicated.

Methodology: Use proc corr to perform a correlation analysis, and then use proc
sgplot to output a scatterplot to illustrate the correlation.

Followup Steps: Perform a more formal linear regression analysis to measure the 
degre of association between the two variables and the type of relationship.
;

title3 jusitfy=left
'Correlation analysis for Population_living_below_national and HDI'
;

footnote1 justify=left
'Assuming the variables Population living below national poverty line and HDI are normally distributed, the data analysis shows that there is a strong negative correlation between percent of the population living below the income poverty line and the Human Development Index by country.'
;

footnote2 justify=left
'There is a statistically significant correlation with high confidence level since the p-value is less than 0.001.'
;

footnote3 justify=left
'Countries with a greater percent of the population living below the national poverty line generally have a lower Human Development Index which could possibly be explained by lower standards of living in countries with greater poverty.'
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

title;
footnote;
