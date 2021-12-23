#Taking Vaxcine report data
#The purpose of this script is to take the VAERS Data
#Access multiple datasets as necessary and cleanup the datasets
#by merging into one, cleaner dataset

#Importing nessecery libraries
import numpy as np
import pandas as pd

#vax_data_2021 will take a while, there is a lot of information in there
#used low_memory = False argument to speed up the process as warned
#needed to chage the engoding to fix the encoding problem

vax_data_2021 = pd.read_csv('2021VAERSDATA.csv', low_memory = False , encoding="iso-8859-1")
vax_types_2021 = pd.read_csv('2021VAERSVAX.csv', low_memory = False , encoding="iso-8859-1")
vax_data_2020 = pd.read_csv('2020VAERSDATA.csv', low_memory = False , encoding="iso-8859-1")
vax_types_2020 = pd.read_csv('2020VAERSVAX.csv', low_memory = False , encoding="iso-8859-1")
vax_total = pd.read_csv('COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv', 
                        low_memory = False, encoding="iso-8859-1")

#cleaning up total vax against COVID-19
vax_total = vax_total[vax_total['Date'] == '12/10/2021']
vax_total = vax_total[(vax_total['Location'] == 'AL') | (vax_total['Location'] == 'AK') | (vax_total['Location'] == 'AZ') |
                 (vax_total['Location'] == 'AR') | (vax_total['Location'] == 'CA') | (vax_total['Location'] == 'CO') |
                 (vax_total['Location'] == 'CT') | (vax_total['Location'] == 'DE') | (vax_total['Location'] == 'FL') |
                 (vax_total['Location'] == 'GA') | (vax_total['Location'] == 'HI') | (vax_total['Location'] == 'ID') |
                 (vax_total['Location'] == 'IL') | (vax_total['Location'] == 'IN') | (vax_total['Location'] == 'IA') |
                 (vax_total['Location'] == 'KS') | (vax_total['Location'] == 'KY') | (vax_total['Location'] == 'LA') |
                 (vax_total['Location'] == 'ME') | (vax_total['Location'] == 'MD') | (vax_total['Location'] == 'MA') |
                 (vax_total['Location'] == 'MI') | (vax_total['Location'] == 'MN') | (vax_total['Location'] == 'MS') |
                 (vax_total['Location'] == 'MO') | (vax_total['Location'] == 'MT') | (vax_total['Location'] == 'NE') |
                 (vax_total['Location'] == 'NV') | (vax_total['Location'] == 'NH') | (vax_total['Location'] == 'NJ') |
                 (vax_total['Location'] == 'NM') | (vax_total['Location'] == 'NY') | (vax_total['Location'] == 'NC') |
                 (vax_total['Location'] == 'ND') | (vax_total['Location'] == 'OH') | (vax_total['Location'] == 'OK') |
                 (vax_total['Location'] == 'OR') | (vax_total['Location'] == 'PA') | (vax_total['Location'] == 'RI') |
                 (vax_total['Location'] == 'SC') | (vax_total['Location'] == 'SD') | (vax_total['Location'] == 'TN') |
                 (vax_total['Location'] == 'TX') | (vax_total['Location'] == 'UT') | (vax_total['Location'] == 'VT') |
                 (vax_total['Location'] == 'VA') | (vax_total['Location'] == 'WA') | (vax_total['Location'] == 'WV') |
                 (vax_total['Location'] == 'WI') | (vax_total['Location'] == 'WY')] #getting each of the states

#merging 2020 and 2021 data
vax_data = pd.concat([vax_data_2021, vax_data_2020], axis = 0).reset_index()
vax_type = pd.concat([vax_types_2021, vax_types_2020], axis = 0).reset_index()

#In the testing portion, I created a new variable. But after testing it and seeing how it worked,
#I save back the same dataframe after determining what variables/columns I need
vax_data = vax_data.drop(['RPT_DATE', 'TODAYS_DATE', 'CAGE_YR', 'SPLTTYPE', 'OFC_VISIT', 
                          'ER_ED_VISIT', 'FORM_VERS', 'DATEDIED', 'ER_VISIT', 'HOSPDAYS', 
                          'X_STAY', 'ONSET_DATE', 'NUMDAYS', 'LAB_DATA', 'V_FUNDBY', 
                          'V_ADMINBY', 'PRIOR_VAX', 'CAGE_MO', 'VAX_DATE', 'OTHER_MEDS',
                          'CUR_ILL', 'HISTORY', 'BIRTH_DEFECT', 'ALLERGIES'], 1)
                                    
vax_type = vax_type.drop(['VAX_LOT', 'VAX_ROUTE', 'VAX_SITE', 'VAX_NAME'],1)

#Merging them to fix the data to my likeing
vax_info = pd.merge(vax_data, vax_type, on = 'VAERS_ID')

#Now to get only COVID-19 cases
Covid_reports = vax_info[vax_info['VAX_TYPE'] == 'COVID19'].reset_index()

#Fix the missing values by the context of the problem
#NaN for DIED = N
null_col = {'DIED':'N', 'L_THREAT':'N', 'HOSPITAL':'N', 'DISABLE':'N', 'RECOVD':'U', 'STATE':'US', 'AGE_YRS': 'unknown'}
Covid_reports = Covid_reports.fillna(value = null_col)

#unknown values for Vax_series will be replaced with 1 because it is at least 1 dose
Covid_reports['VAX_DOSE_SERIES'] = Covid_reports['VAX_DOSE_SERIES'].replace(to_replace='UNK', value=1)

#Save it back to a csv file to be read by Rstudio
Covid_reports.to_csv('COVID_Reports.csv')
vax_total.to_csv('Vax_count.csv')
