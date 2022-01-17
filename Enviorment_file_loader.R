#since python did the heavy workload,
#all we need to do is run this to be a once and done thing
#this is intended to make the shiny app run faster
Vax_reports = read.csv('COVID_Reports.csv')
Vax_total = read.csv('Vax_count.csv')

library(tidyverse)

Vax_total = Vax_total %>% 
  select(-X) %>% 
  summarise(total_vax = sum(Administered_Dose1_Recip),
            full_vax = sum(Series_Complete_Yes),
            third_vaxed = sum(Additional_Doses),
            Vax_JnJ = sum(Series_Complete_Janssen), 
            Vax_moderna = sum(Series_Complete_Moderna), 
            Vax_Pfizer = sum(Series_Complete_Pfizer),
            Vax_UNK = sum(Series_Complete_Unk_Manuf))

Vax_reports$AGE_YRS = cut(as.numeric(Vax_reports$AGE_YRS), breaks = c(0,5,12,18,35,50,65,120),
                  labels = c('under 5', '5 to 11', '12 to 17', '18 to 35', 
                             '35 to 50','50 to 65','65+'))

#Need to replace "" with NA so that the NA may be removed
Vax_reports[Vax_reports == ''] <- NA


Vax_load = Vax_reports %>%
  pivot_longer(12:16, names_to = 'SYM_NUMBER', values_to = 'SYMPTOM',
               values_drop_na = TRUE) %>%
  group_by(VAX_TYPE, VAX_MANU, AGE_YRS, SEX, VAX_DOSE_SERIES, SYMPTOM) %>%
  summarise(Count = n(), LT = sum(L_THREAT), Dead = sum(DIED)) %>%
  arrange(desc(Count)) %>%
  ungroup()



save.image('Vaccine_Web_App/Vax_data.RData')