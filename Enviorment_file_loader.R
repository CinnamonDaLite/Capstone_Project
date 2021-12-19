#since python did the heavy workload,
#all we need to do is run this to be a once and done thing
#this is intended to make the shiny app run faster
Vax = read.csv('VaxReports.csv')

#the rest of this portion is testing

library(tidyverse)

#1. Find the deadliest vaccine and the most reported

Vax = Vax %>% select(-'X', -'VAERS_ID')

Vax$AGE_YRS = cut(Vax$AGE_YRS, breaks = c(0,18,35,50,120),
                  labels = c('under 18', '18 to 35', '35 to 50', 'over 50'))

Vax_load = Vax %>% 
  select(VAX_TYPE, VAX_MANU, AGE_YRS, SEX, SYMPTOM_TEXT, 
         L_THREAT, DIED) %>%
  separate_rows(SYMPTOM_TEXT, sep = '[^[:alpha:]]+') %>%
  group_by(VAX_TYPE, VAX_MANU, AGE_YRS, SEX, L_THREAT, DIED, 
           SYMPTOM_TEXT = tolower(SYMPTOM_TEXT)) %>%
  summarise(Count = n()) %>%
  filter(VAX_TYPE != 'UNK' & SEX != 'U' &
           (SYMPTOM_TEXT == 'headache' | SYMPTOM_TEXT == 'stomache' |
              SYMPTOM_TEXT == 'hyperthyroidism' | SYMPTOM_TEXT == 'aches' |
              SYMPTOM_TEXT == 'itching' | SYMPTOM_TEXT == 'nausea' |
              SYMPTOM_TEXT == 'redness' | SYMPTOM_TEXT == 'soreness' |
              SYMPTOM_TEXT == 'stuffy' | SYMPTOM_TEXT == 'tightness' | 
              SYMPTOM_TEXT == 'weakness' | SYMPTOM_TEXT == 'bleeding' |
              SYMPTOM_TEXT == 'allergic' | SYMPTOM_TEXT == 'appendicitis' |
              SYMPTOM_TEXT == 'chills' | SYMPTOM_TEXT == 'hypersensitivity' |
              SYMPTOM_TEXT == 'diarrhea' | SYMPTOM_TEXT == 'numbness' |
              SYMPTOM_TEXT == 'tingling' | SYMPTOM_TEXT == 'swelling' |
              SYMPTOM_TEXT == 'sweating'| SYMPTOM_TEXT == 'suicidal' |
              SYMPTOM_TEXT == 'stiff' | SYMPTOM_TEXT == 'colostomy' |
              SYMPTOM_TEXT == 'dizziness' | SYMPTOM_TEXT == 'dizzy' |
              SYMPTOM_TEXT == 'fever' | SYMPTOM_TEXT == 'swollen' |
              SYMPTOM_TEXT == 'fatigue' | SYMPTOM_TEXT == 'sore' |
              SYMPTOM_TEXT == 'rash' | SYMPTOM_TEXT == 'itchy' |
              SYMPTOM_TEXT == 'painful' | SYMPTOM_TEXT == 'hives' |
              SYMPTOM_TEXT == 'lymph' | SYMPTOM_TEXT == 'vomiting' |
              SYMPTOM_TEXT == 'cold' | SYMPTOM_TEXT == 'urinary' |
              SYMPTOM_TEXT == 'cough' | SYMPTOM_TEXT == 'hotness' |
              SYMPTOM_TEXT == 'lithotripsy' | SYMPTOM_TEXT == 'cirrhotic' |
              SYMPTOM_TEXT == 'heart attack' | SYMPTOM_TEXT == 'shortness' |
              SYMPTOM_TEXT == 'allergies' | SYMPTOM_TEXT == 'erythema' |
              SYMPTOM_TEXT == 'discomfort' | SYMPTOM_TEXT == 'myalgia' |
              SYMPTOM_TEXT == 'hyponatremia' | SYMPTOM_TEXT == 'ache' |
              SYMPTOM_TEXT == 'tiredness' | SYMPTOM_TEXT == 'migraine' |
              SYMPTOM_TEXT == 'vertigo' | SYMPTOM_TEXT == 'numb' |
              SYMPTOM_TEXT == 'anxiety' | SYMPTOM_TEXT == 'lump' |
              SYMPTOM_TEXT == 'nauseous' | SYMPTOM_TEXT == 'hypertension' |
              SYMPTOM_TEXT == 'asthma' | SYMPTOM_TEXT == 'itchiness' |
              SYMPTOM_TEXT == 'lightheaded' | SYMPTOM_TEXT == 'bumps' |
              SYMPTOM_TEXT == 'fatigued' | SYMPTOM_TEXT == 'coughing' |
              SYMPTOM_TEXT == 'seizure' | SYMPTOM_TEXT == 'tachycardia' |
              SYMPTOM_TEXT == 'stiffness' | SYMPTOM_TEXT == 'cancer' |
              SYMPTOM_TEXT == 'asthenia' | SYMPTOM_TEXT == 'diarrhoea' |
              SYMPTOM_TEXT == 'consciousness' | SYMPTOM_TEXT == 'urticaria' |
              SYMPTOM_TEXT == 'aching' | SYMPTOM_TEXT == 'cardiac' |
              SYMPTOM_TEXT == 'dyspnoea' | SYMPTOM_TEXT == 'fainted' |
              SYMPTOM_TEXT == 'lymphadenopathy' | SYMPTOM_TEXT == 'insomnia' |
              SYMPTOM_TEXT == 'exhausted' | SYMPTOM_TEXT == 'cellulitis' |
              SYMPTOM_TEXT == 'sweat' | SYMPTOM_TEXT == 'feverish' |
              SYMPTOM_TEXT == 'migraines' | SYMPTOM_TEXT == 'hepatitis' |
              SYMPTOM_TEXT == 'hypoaesthesia' | SYMPTOM_TEXT == 'nauseated' |
              SYMPTOM_TEXT == 'inflamed' | SYMPTOM_TEXT == 'confusion' |
              SYMPTOM_TEXT == 'lethargic' | SYMPTOM_TEXT == 'depression' |
              SYMPTOM_TEXT == 'rashes' | SYMPTOM_TEXT == 'bruise' |
              SYMPTOM_TEXT == 'paraesthesia' | SYMPTOM_TEXT == 'urine' |
              SYMPTOM_TEXT == 'fainting' | SYMPTOM_TEXT == 'faint' |
              SYMPTOM_TEXT == 'rheumatoid' | SYMPTOM_TEXT == 'wheezing' |
              SYMPTOM_TEXT == 'exhaustion' | SYMPTOM_TEXT == 'tight' |
              SYMPTOM_TEXT == 'blisters' | SYMPTOM_TEXT == 'syncope' |
              SYMPTOM_TEXT == 'lightheadedness' | SYMPTOM_TEXT == 'lethargy' |
              SYMPTOM_TEXT == 'bump' | SYMPTOM_TEXT == 'heat')) %>%
  arrange(desc(Count)) %>%
  ungroup()

save.image('Vaccine_Web_App/Vax_data.RData')

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
