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
Question: Can the % of "Education" under "Contribution of deprivation in 
dimension to overall poverty" be used to predict the country's "Multidimensional 
Poverty Index"?

Rationale: A correlation between the percent of education and the MPI will 
determine if education really is a significant agent to combat poverty.

Note: This compares the column "Contribution of deprivation in dimention to 
overall poverty" from 2018 Statistical Annex Table 6 to the column 
"Multidimensional Poverty Index" from 2018 Statistical Annex Table 6.

Limitations: missing values need to be addressed for glm and general data analysis
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there a strong association between "Mean years of schooling" by 
country for both M and F and the "Human Development Index"?

Rationale: A strong assocation would show whether the HDI is appropriately 
measured by the years of schooling and not by national income or life 
expectancy and vice versa.

Note: This compares the column "Mean years of schooling" from 2018 Statistical 
Annex Table 4 to the column "Human Development Index" from 2018 Statistical 
Annex Table 4.

Limitations: missing values need to be addressed for glm and general data analysis
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there a negative correlation between countries with a greater % of 
"Inequality of Education" and "Human Development Index" and does this 
correlation follow a similarly negative correlation with "Inequality in life 
expectancy"

Rationale: This would help to show whether life expectancy can forecast 
"expected" education and if that "expected" education contributes to the HDI.

Note: This compares the column "Inequality of Education" from 2018 Statistical 
Annex Table 3 to the column "Human Development Index" from 2018 Statistical 
Annex Table 3.

Limitations: missing values need to be addressed for glm and general data analysis
;

proc sql;
    create table Annex_Table_6_and_4_ as
        select
             coalesce(A.Country,B.Country) as Country
             ,adjusted_life_index
             ,Inequality_in_education
             ,HDI
             ,Mean_years_of_schooling_female
             ,Mean_years_of_schooling_male
             ,Year_School_Female
             ,HDI_female
             ,HDI_male
             ,Estimated_gross_national_income
        from
            Statistical_2018_Annex_Table_6 as A
            full join
            Statistical_2018_Annex_Table_4 as B
            on A.Country=B.Country
        order by
            Country
    ;
quit;
proc compare
        base=Annex_Table_6_and_4_v1
        compare=Annex_Table_6_and_4_v2
        novalues
    ;
run;
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
@@ -43,6 +74,36 @@ Annex Table 4.
;
proc sql;
    create table Annex_Table_3_and_4_v2 as
        select
             coalesce(A.Country,B.Country) as Country
             ,adjusted_life_index
             ,Inequality_in_education
             ,HDI
             ,Mean_years_of_schooling_female
             ,Mean_years_of_schooling_male
             ,Year_School_Female
             ,HDI_female
             ,HDI_male
             ,Estimated_gross_national_income
        from
            Statistical_2018_Annex_Table_3 as A
            full join
            Statistical_2018_Annex_Table_4 as B
            on A.Country=B.Country
        order by
            Country
    ;
quit;
proc compare
        base=Annex_Table_3_and_4_v1
        compare=Annex_Table_3_and_4_v2
        novalues
    ;
run;
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
@@ -59,3 +120,35 @@ Note: This compares the column "Inequality of Education" from 2018 Statistical
Annex Table 3 to the column "Human Development Index" from 2018 Statistical 
Annex Table 3.
;
proc sql;
    create table Annex_Table_3_and_6_v2 as
        select
             coalesce(A.Country,B.Country) as Country
             ,adjusted_life_index
             ,Inequality_in_education
             ,HDI
             ,Mean_years_of_schooling_female
             ,Mean_years_of_schooling_male
             ,Year_School_Female
             ,HDI_female
             ,HDI_male
             ,Estimated_gross_national_income
        from
            Statistical_2018_Annex_Table_3 as A
            full join
            Statistical_2018_Annex_Table_6 as B
            on A.Country=B.Country
        order by
            Country
    ;
quit;
proc compare
        base=Annex_Table_3_and_6_v1
        compare=Annex_Table_3_and_6_v2
        novalues
    ;
run;
   
101  STAT697-01_s19-team-3_data_preparation.sas
@@ -248,7 +248,106 @@ proc sql;
quit;
title;
*Mariano's Research Question Column
*Mariano's Research Question Column;
title "Inspect Percent education contribution of deprivation";
proc sql;
    select
     min(Percent_education_contribution_o) as min
    ,max(Percent_education_contribution_o) as max
    ,mean(Percent_education_contribution_o) as max
    ,median(Percent_education_contribution_o) as max
    ,nmiss(Percent_education_contribution_o) as missing
    from 
    Statistical_2018_annex_table_6
    ;
quit;
title;
title "Inspect Multidimensional Poverty Index";
proc sql;
    select
     min(Multidimensional_Poverty_Index) as min
    ,max(Multidimensional_Poverty_Index) as max
    ,mean(Multidimensional_Poverty_Index) as max
    ,median(Multidimensional_Poverty_Index) as max
    ,nmiss(Multidimensional_Poverty_Index) as missing
    from 
    Statistical_2018_annex_table_6
    ;
quit;
title;
title "Inspect Mean years of schooling female";
proc sql;
    select
     min(Mean_years_of_schooling_female) as min
    ,max(Mean_years_of_schooling_female) as max
    ,mean(Mean_years_of_schooling_female) as max
    ,median(Mean_years_of_schooling_female) as max
    ,nmiss(Mean_years_of_schooling_female) as missing
    from 
    Statistical_2018_annex_table_4
    ;
quit;
title;
title "Inspect Mean years of schooling male";
proc sql;
    select
     min(Mean_years_of_schooling_male) as min
    ,max(Mean_years_of_schooling_male) as max
    ,mean(Mean_years_of_schooling_male) as max
    ,median(Mean_years_of_schooling_male) as max
    ,nmiss(Mean_years_of_schooling_male) as missing
    from 
    Statistical_2018_annex_table_4
    ;
quit;
title;
title "Inspect Human Development Index female";
proc sql;
    select
     min(HDI_female) as min
    ,max(HDI_female) as max
    ,mean(HDI_female) as max
    ,median(HDI_female) as max
    ,nmiss(HDI_female) as missing
    from 
    Statistical_2018_annex_table_4
    ;
quit;
title;
title "Inspect Human Development Index male";
proc sql;
    select
     min(HDI_male) as min
    ,max(HDI_male) as max
    ,mean(HDI_male) as max
    ,median(HDI_male) as max
    ,nmiss(HDI_male) as missing
    from 
    Statistical_2018_annex_table_4
    ;
quit;
title;
title "Inspect Inequality in education";
proc sql;
    select
     min(Inequality_in_education) as min
    ,max(Inequality_in_education) as max
    ,mean(Inequality_in_education) as max
    ,median(Inequality_in_education) as max
    ,nmiss(Inequality_in_education) as missing
    from 
    Statistical_2018_annex_table_3
    ;
quit;
title;
