#since python did the heavy workload,
#all we need to do is run this to be a once and done thing
#this is intended to make the shiny app run faster
Vax_reports = read.csv('COVID_Reports.csv')
Vax_total = read.csv('Vax_count.csv')

library(tidyverse)

reports = nrow(Vax_reports)
full_vax = Vax_reports %>% filter(VAX_DOSE_SERIES >= 2)
full_reports = nrow(full_vax)
Vax_total = Vax_total %>% 
  select('Administered_Dose1_Recip', 'Series_Complete_Yes') %>%
  summarise(One_shot = sum(Administered_Dose1_Recip), 
            full = sum(Series_Complete_Yes))

One = Vax_total %>%
  summarise(no_symptom = ((One_shot - reports)/One_shot * 100),
            symptoms = (reports/One_shot * 100),
            critical = (sum(Vax_reports$L_THREAT == 'Y')/One_shot * 100),
            deadliness = (sum(Vax_reports$DIED == 'Y')/One_shot * 100)) %>%
  gather(key = 'Condition', 'one_shot')

full_count = Vax_total %>%
  summarise(no_symptom = (full - full_reports)/full * 100,
            symptoms = (full_reports/full) * 100,
            critical = (sum(full_vax$L_THREAT == 'Y')/full) * 100,
            deadliness = (sum(full_vax$DIED == 'Y')/full) * 100) %>%
  gather(key = 'Condition', 'full')

Vax_total = inner_join(One, full_count)

Vax_total = Vax_total %>% 
  gather(key = 'shot', value = 'Percentage', 2:3)

Vax_reports = Vax_reports %>% select(-'X', -'VAERS_ID', -'index', -'index_x', -'index_y')

Vax_reports$AGE_YRS = cut(as.numeric(Vax_reports$AGE_YRS), breaks = c(0,5,12,18,35,50,65,120),
                  labels = c('under 5', '5 to 11', '12 to 17', '18 to 35', 
                             '35 to 50','50 to 65','65+'))

Vax_load = Vax_reports %>% 
  select(VAX_TYPE, VAX_MANU, AGE_YRS, SEX, SYMPTOM_TEXT, L_THREAT, DIED, VAX_DOSE_SERIES) %>%
  separate_rows(SYMPTOM_TEXT, sep = '[^[:alpha:]]+') %>%
  group_by(VAX_TYPE, VAX_MANU, AGE_YRS, SEX, L_THREAT, DIED, VAX_DOSE_SERIES,
           SYMPTOM_TEXT = tolower(SYMPTOM_TEXT)) %>%
  summarise(Count = n()) %>%
  filter(VAX_TYPE != 'UNK' & SEX != 'U' &
           (SYMPTOM_TEXT == 'pain' | SYMPTOM_TEXT == 'headache' |
              SYMPTOM_TEXT == 'fever' | SYMPTOM_TEXT == 'chills' |
              SYMPTOM_TEXT == 'rash' | SYMPTOM_TEXT == 'fatigue' |
              SYMPTOM_TEXT == 'swelling' | SYMPTOM_TEXT == 'sore' |
              SYMPTOM_TEXT == 'nausea' | SYMPTOM_TEXT == 'aches')) %>%
  arrange(desc(Count)) %>%
  ungroup()



save.image('Vaccine_Web_App/Vax_data.RData')


#Vax_load_alt = Vax_reports %>% 
#  select(VAX_TYPE, SYMPTOM_TEXT) %>%
#  separate_rows(SYMPTOM_TEXT, sep = '[^[:alpha:]]+') %>%
#  group_by(VAX_TYPE, SYMPTOM_TEXT = tolower(SYMPTOM_TEXT)) %>%
#  summarise(Count = n()) %>%
#  arrange(desc(Count)) %>%
#  ungroup() #Diging through top ten symptoms

# write.csv(Vax_load, '../Info_Load.csv')
#Story: You are presenting this to a medical company that wants to make money
#by percribing meds that will help people's symptoms after getting vaccinated
#so that the medicine is ready for the customer in case they start experiencing 
#that symptom

#notes:
#get the dataset on how many people got the vaccine
#What are the adverse effects
#severity of the side (L_THREAT tag, and symptom tag)
#Get symptoms and find the most common for each age group and gender and vax_type)
#kind of symptoms for each group(age groups) (Male vs Female)
#answer with some diversity
#Need help finding vaccine database for all 66 vaxtypes (can only find COVID19)
