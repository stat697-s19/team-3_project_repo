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
Note: This compares the column "Inequality of Education" from 2018 Statistical 
Annex Table 3 to the column "Multidimensional Poverty Index" from 2018 
Statistical Annex Table 6.
Limitations: Values denoted as ".." for the column "Inequality of Education" 
should be excluded from analysis since it represents missing values.
Methodology: Use proc corr to perform a correlation analysis, and illustrate 
the absence or presence of a correlation using proc sgplot
Followup Steps: Perform a formal linear regression analysis to measure the 
degree of association between the two variables. 
;

title1 justify=left
'Question: Is there sufficient evidence to indicate countries with a greater percent of education inequality also experience a greater percent of poverty?'
;

title2 justify=left
'Rationale: This would indicate if there is an assocation between eduaction inequality and poverty, and if education inequality can be an indicator of poverty in a country or vice versa.'
;

title3 justify=left
'Correlation of "Inequality in Education" and "Multidimensional Poverty Index"'
;

footnote1 justify=left
"Observation: There is a positive correlation between HDI and Population living below national poverty."
;

footnote2 justify=left
"Observation: Considering the correlation has a small R-squared value of 6.27 percent the absent values in our data and in subsequent data must be addressed. However, considering the small p-value (<0.001) the correlation between education inequality and MPI is significant. Thus, countries with a greater percent of education inequality also experience poverty and may be an indicator of it."
;

footnote3 justify=left
'This compares the column "Inequality of Education" from 2018 Statistical Annex Table 3 to the column "Multidimensional Poverty Index" from 2018 Statistical Annex Table 6.'
;

footnote4 justify=left
'Assuming both variables in our experiment follow a normal distribution the data analysis indicates a strong correlation between education inequality and MPI.'
;



data work1;
set country_analytic_file_raw;
    if Inequality_ineducation='..' then delete;
    if Inequality_ineducation='.' then delete;
    if Inequality_ineducation='' then delete;
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
*
Note: This compares "Mean years of schooling" between males and females from 
the 2018 Statistical Annex Table 4.
Limitations: Values denoted as ".." should be excluded from the analysis since
they represent missing values.
Methodology: Use proc ttest to perform a paired comparison of group means
between the two genders for mean years of schooling. Use proc report to create
a table for Mean_years_schooling_female1 and Mean_years_schooling_male1, listing
the min, max, mean and median. 
Followup Steps: Display summary statistic visuals such as a boxplot to further
illustrate the years of schooling difference between genders;

title1 justify=left
'Question: Is there sufficient evidence to indicate a significant difference between the average number of years of schooling by gender across countries?'
;

title2 justify=left
'Rationale: This test has the potential to imply disadvantages between genders across countries.'
;

title3 justify=left
'Correlation of "Inequality in Education" and "Multidimensional Poverty Index"'
;

footnote1 justify=left
'Mean years of schooling for males are 64.86% higher than female years of schooling if we assume the means are normally distributed. This observation can imply biased socioeconomic cultural practices that provides males an educational advantage over females. '
;
footnote2 justify=left
'This compares Female and Male columns under "Mean years of schooling" from 2018 Statistical Annex Table 4.'
;

footnote3 justify=left
'There is sufficent evidence to indicate a difference in the paired means of years of schooling between males and females via a small p-value (<0.001)'
;

data work; 
    set country_analytic_file_raw;
        Mean_years_of_schooling_female1 = input(Mean_years_of_schooling_female, best7.);
        Mean_years_of_schooling_male1 = input(Mean_years_of_schooling_male, best7.);
run;

proc ttest;
    paired Mean_years_of_schooling_male1*Mean_years_of_schooling_female1;
run;

title;
footnote;

title1
'Summary statistics of mean years of schooling between males and females'
;

footnote1
'Observation: The min, max, mean and median values for mean years of schooling per country are each higher for males than for females.'
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
*
Note: This compares the column Population living below national poverty line 
from the 2018 Statistical Annex Table 6 to the column HDI from 2018 Statistical 
Annex Table 3.
Limitations: The 10 missing values for column "Population living below 
national poverty line" should be excluded from the analysis.
Methodology: Use proc corr to perform a correlation analysis and proc
sgplot to output a scatterplot to illustrate a test for correlation. 
Followup Steps: Perform a formal linear regression analysis to measure the 
degree of association and relationship between the two variables.
;
title1 justify=left
"Plot illustrating the negative correlation between % Population living below the income poverty line for 2006-2017 and HDI?"
;

title1 justify=left
"Question: Can the % of population living below the income poverty line for 2006-2017 be used to predict a country's HDI?"
;

title2 justify=left
"Rationale: This has the potential to show us how poverty levels are associated with a country's Human Development Index."
;

title3 
'Correlation analysis for Population living below national poverty line and HDI'
;

footnote1 justify=left
"There is a 68.5% negative correlation between HDI and Population living below national poverty. The correlation is significant with a small p-value (<0.001)."
;

footnote2 justify=left
'This compares the column "Population_living_below_national_poverty_line" from 2018 Statistical Annex Table 6 to the column "HDI" from 2018 Statistical Annex Table 3.'
;

footnote3 justify=left
'Countries with populations below the national poverty line have a lower human development index.'
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
