#Taking Vaxcine report data

#The purpose of this script is to take the VAERS Data
#Access multiple datasets as necessary and cleanup the datasets
#by merging into one, cleaner dataset

#Importing nessecery libraries
import numpy as np
import pandas as pd

#vax_data_2021 will take a while, there is a lot of information in there
#used low_memory = False argument to speed up the process as warned

vax_data_2021 = pd.read_csv('../VAERS_Data/2021VAERSData/2021VAERSDATA.csv', 
                            low_memory=False)
vax_types_2021 = pd.read_csv('../VAERS_Data/2021VAERSData/2021VAERSVAX.csv',
                            low_memory=False)

#In the testing portion, I created a new variable. But after testing it and seeing how it worked,
#I save back the same dataframe after determining what variables/columns I need
vax_data_2021 = vax_data_2021.drop(['RPT_DATE', 'TODAYS_DATE', 'CAGE_YR', 'SPLTTYPE', 'OFC_VISIT', 
                                    'ER_ED_VISIT', 'FORM_VERS', 'DATEDIED', 'ER_VISIT', 'HOSPDAYS', 
                                    'X_STAY', 'ONSET_DATE', 'NUMDAYS', 'LAB_DATA', 'V_FUNDBY', 
                                    'V_ADMINBY', 'PRIOR_VAX', 'CAGE_MO', 'VAX_DATE', 'OTHER_MEDS',
                                    'CUR_ILL', 'HISTORY', 'BIRTH_DEFECT', 'ALLERGIES'], 1)
                                    
vax_types_2021 = vax_types_2021.drop(['VAX_LOT','VAX_DOSE_SERIES','VAX_ROUTE','VAX_SITE',
                                      'VAX_NAME'],1)

#Merging them to fix the data to my likeing
vax_info_2021 = pd.merge(vax_types_2021, vax_data_2021, on = 'VAERS_ID')

#Fix the missing values by the context of the problem
#NaN for Birth_Defects = no birth defects
#NaN for DIED = N
#NaN for PRIOR_VAX = No affirmities
null_col = {'DIED':'N', 'L_THREAT':'N', 'HOSPITAL':'N', 'DISABLE':'N', 'RECOVD':'U', 'STATE':'US'}
vax_info_2021 = vax_info_2021.fillna(value = null_col)

vax_info_2021 = vax_info_2021.dropna()

#Save it back to a csv file to be read by Rstudio
vax_info_2021.to_csv('Statistical_Ploting_R/VaxReports.csv')
