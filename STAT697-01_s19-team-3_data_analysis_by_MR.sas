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
'Correlation analysis for Inequality_in_education and Multidimensional_Poverty_Index'
;

title2 justify=left
'Rationale: This would indicate if there is an assocation between eduaction inequality and poverty, and if the former can be an indicator of poverty in a country.'
;

footnote1 justify=left
"Observation: There is a positive correlation between HDI and Population living below national poverty."
;

footnote2 justify=left
"Observation: Considering the correlation has a small R-squared value of 6.27 percent the absent values in our data and in subsequent data must be addressed."
;

footnote3 justify=left
'This compares the column "Inequality of Education" from 2018 Statistical Annex Table 3 to the column "Multidimensional Poverty Index" from 2018 Statistical Annex Table 6.'
;

footnote4 justify=left
'Limitations: Values denoted as ".." for the column "Inequality of Life Expectancy" should be excluded from analysis since it represents missing values.'
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

title1 justify=left
'Question: Is there a strong association between "Mean years of schooling" and the "Multidimensional Poverty Index" by gender?'
;

title2 justify=left
'Rationale: This would show is their is an association between average years of schooling per country between genders and can potentially indicate gender disadvantages.'
;

title3 justify=left
'Rationale: This would show if their is an association between average years of schooling per country between genders and can potentially indicate gender disadvantages.'
;

footnote1 justify=left
'Assuming a normal distribution there is a difference of 0.6486 in the gender means, where males have the higher mean.'
;
footnote2 justify=left
'This compares the column "Mean years of schooling" from 2018 Statistical Annex Table 4 to the column "Multudimensional Poverty Index" from 2018 Statistical Annex Table 6.'
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
"Plot illustrating the negative correlation between % Population living below the income poverty line for 2006-2017 and HDI?"
;

title2 justify=left
"Rationale: This has the potential to show us how poverty levels are associated with a country's Human Development Index."
;

footnote1 justify=left
" There is a 68.5% negative correlation between HDI and Population living below national poverty."
;

footnote2 justify=left
'This compares the column "Population_living_below_national_poverty_line" from 2018 Statistical Annex Table 6 to the column "HDI" from 2018 Statistical Annex Table 3.'
;

footnote3 justify=left
'There are 10 missing values in the column "Population living below national poverty line" that must be excluded from the analysis.'
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
