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
'Question: Is there evidence that countries with a greater percent of Inequality of Education also suffer from greater poverty as measured by the Multidimensional Poverty Index?'
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


title3
'Correlation analysis for Inequality in education and Multidimensional Poverty Index'
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


data work1; 
    set country_analytic_file_raw;
        if Inequality_in_education='..' then delete;
        if Inequality_in_education='.' then delete;
        if Inequality_in_education=' ' then delete;
        Inequality_in_education1 = input(Inequality_in_education, 7.);
run;

proc corr 
        data=work1
    ;
	var 
        Inequality_in_education1
        Multidimensional_Poverty_Index
    ;
run;

title;
footnote;


title1
'Plot illustrating the positive correlation between Inequality in education and Multidimensional Poverty Index'
;

footnote1
'In the above plot, we can see how values for percent of Inequality of education tend to increase as the values for the Multidimensional Poverty Index increase.'
;
proc sgplot data=work1;
    scatter
        x=Inequality_in_education1
        y=Multidimensional_Poverty_Index
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

Methodology: Use proc ttest to perform a paired comparison of group means between
the two genders for mean years of schooling. Use proc report to create a table 
for Mean_years_schooling_f and Mean_years_schooling_m, listing characteristic 
values of the data including the min, max, mean and median. 

Followup Steps: Display a visual of the summary statistics such as a boxplot to 
further illustrate the difference between genders.
;

data work; 
    set country_analytic_file_raw;
	if Mean_years_of_schooling_female ne '..' then
        Mean_years_of_schooling_female1 = input(Mean_years_of_schooling_female, best7.)
    ;
    if Mean_years_of_schooling_male ne '..' then
        Mean_years_of_schooling_male1 = input(Mean_years_of_schooling_male, best7.);
run;

proc ttest data=work;
    paired Mean_years_of_schooling_male1*Mean_years_of_schooling_female1;
run;

title;
footnote;

title1
'Comparing the summary statistics for females and males regarding Mean years of Schooling.'
;

footnote1
'We can observe that the min, max, mean and median values for mean years of schooling per country are each higher for males than for females.'
;

proc report data=work;
    column Mean_years_of_schooling_female1=minf 
           Mean_years_of_schooling_female1=maxf
           Mean_years_of_schooling_female1=avgf 
           Mean_years_of_schooling_female1=medf
           Mean_years_of_schooling_male1=minm 
           Mean_years_of_schooling_male1=maxm
           Mean_years_of_schooling_male1=avgm 
           Mean_years_of_schooling_male1=medm;
    define minf/min 'Female Min';
    define maxf/max 'Female Max';
    define avgf/mean 'Female Mean';
    define medf/median 'Female Median';
    define minm/min 'Male Min';
    define maxm/max 'Male Max';
    define avgm/mean 'Male Mean';
    define medm/median 'Male Median';
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

title3 
'Correlation analysis for Population living below national and HDI'
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

title;
footnote;

title1
'Plot illustrating the negative correlation between Population living below the national poverty line and the Human Development Index'
;

footnote1
'In the above plot, we can see how values of percent of Population living below the national poverty line tend to decrease as values for the Human Development Index increase.'
;

proc sgplot data=country_analytic_file_raw;
    scatter
        x=Population_living_below_national
        y=HDI
    ;
run;

title;
footnote;
