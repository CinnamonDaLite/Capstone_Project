#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output, session) {
    
    common_sym <- reactive({
        if(input$SYMPTOM == 'All'){
            temp = Vax_load
            
        } else {
            temp = Vax_load %>% filter(SYMPTOM == input$SYMPTOM)
        }
        
        if (input$SEX == "All") {
            temp = temp
        } else {
            temp = temp %>% filter(SEX == input$SEX)
        }
        
        if (input$AGE_YRS == "All") {
            temp = temp
        } else {
            temp = temp %>% filter(AGE_YRS == input$AGE_YRS)
        }
        
        if (input$VAX_MANU == "All") {
            temp = temp
        } else {
            temp = temp %>% filter(VAX_MANU == input$VAX_MANU)
        }
    })
    
    #Find most common symptoms
    output$sym_rank_1 = renderText({
        paste('The overall most common symptom by this selection is ', 
              common_sym() %>% 
                  group_by(SYMPTOM) %>% 
                  summarise(count = sum(Count)) %>% 
                  ungroup() %>% 
                  filter(count == max(count)) %>%
                  select(SYMPTOM), sep = '')
        })
    
    output$top_LT = renderText({
        paste('The most common Life Threatening symptom is ', 
              common_sym() %>% 
                  group_by(SYMPTOM) %>% 
                  summarise(lt = sum(LT)) %>% 
                  ungroup() %>% 
                  filter(lt == max(lt)) %>%
                  select(SYMPTOM), sep = '')
        })
    
    output$top_D = renderText({
        paste('The most common fatal symptom is ', 
              common_sym() %>% 
                  group_by(SYMPTOM) %>% 
                  summarise(deaths = sum(Dead)) %>% 
                  ungroup() %>% 
                  filter(deaths == max(deaths)) %>%
                  select(SYMPTOM), sep = '')
        })
    
    #Common symptom compassion by gender
    output$sym_sex = renderText({
        paste('The selected symptom is more common in ', 
              common_sym() %>% 
                  group_by(SEX) %>% 
                  summarise(count = sum(Count)) %>% 
                  ungroup() %>% 
                  filter(count == max(count)) %>%
                  select(SEX), 's than the other genders.', sep = '')
        })
    
    
    output$LT_sex = renderText({
        paste('Critical conditions caused by the selected symptom is more common in ', 
              common_sym() %>% 
                  group_by(SEX) %>%
                  summarise(lt = sum(LT)) %>%
                  ungroup() %>% 
                  filter(lt == max(lt)) %>%
                  select(SEX), 's than the other genders.', sep = '')
        })
    
    output$D_sex = renderText({
        paste('The selected symptom causes more deaths in ', 
              common_sym() %>% 
                  group_by(SEX) %>%
                  summarise(deaths = sum(Dead)) %>%
                  ungroup() %>% 
                  filter(deaths == max(deaths)) %>%
                  select(SEX), 's than the other genders.', sep = '')
        })
    
    
    #Age group compare which is more common
    output$age_sym = renderText({
        paste('The selected symptom is more common in ages ', 
              age_group[as.numeric(common_sym() %>% 
                                       group_by(AGE_YRS) %>% 
                                       summarise(count = sum(Count)) %>% 
                                       ungroup() %>% 
                                       filter(count == max(count)) %>%
                                       select(AGE_YRS))], ' than other age groups.',
                                       sep = '')})
    
    output$age_LT = renderText({
        paste('Critical conditions caused by the selected symptom is more common in ages ', 
              age_group[as.numeric(common_sym() %>% 
                                       group_by(AGE_YRS) %>% 
                                       summarise(lt = sum(LT)) %>% 
                                       ungroup() %>% 
                                       filter(lt == max(lt)) %>%
                                       select(AGE_YRS))], ' than other age groups.',
                                       sep = '')})
    
    output$age_deaths = renderText({
        paste('The selected symptom causes more deaths in ages ', 
              age_group[as.numeric(common_sym() %>% 
                                       group_by(AGE_YRS) %>% 
                                       summarise(deaths = sum(Dead)) %>% 
                                       ungroup() %>% 
                                       filter(deaths == max(deaths)) %>%
                                       select(AGE_YRS))], ' than other age groups.',
                                       sep = '')})
    
    #Percentage of fully vaxed
    output$percent = renderText({
        paste(signif((Vax_total$full_vax/Vax_total$total_vax)*100, digits = 3),
              '% of the vaccinated took at least two shots or are fully vaccinated')})
    
    #percentage for manufacturer
    output$per_manu = renderText({
        paste(signif((sum(ifelse(input$VAX_MANU == 'UNKNOWN MANUFACTURER', Vax_total$Vax_UNK,
                                 ifelse(input$VAX_MANU == 'PFIZER\\BIONTECH', Vax_total$Vax_Pfizer,
                                        ifelse(input$VAX_MANU == 'MODERNA', Vax_total$Vax_moderna,
                                               ifelse(input$VAX_MANU == 'JANSSEN', Vax_total$Vax_JnJ, Vax_total$full_vax)))))
                      /Vax_total$full_vax)*100, digits = 3),"% of fully vaccinated took the vaccine from ", input$VAX_MANU, sep = '')})
    
    #most common deaths reported by manufacturer
    output$manu_deaths = renderText({
        paste('The selected symptom causes more deaths from the ', 
              common_sym() %>% 
                  group_by(VAX_MANU) %>%
                  summarise(deaths = sum(Dead)) %>%
                  ungroup() %>% 
                  filter(deaths == max(deaths)) %>%
                  select(VAX_MANU), ' shot than other manufacturers.', sep = '')
        })
    
    output$symptoms <- renderPlotly({ #Symptoms in x-axis
        plot_ly(common_sym(), x = ~SYMPTOM, y = ~Count, 
                type = 'bar', name = 'overall Count') %>%
            add_trace(y = ~LT, name = 'Life Threatening') %>%
            add_trace(y = ~Dead, name = 'Deaths') %>%
            layout(title = 'Symptom Report by Symptom',
                   xaxis = list(title = 'Symptom'),
                   yaxis = list(title = 'Count'), barmode = 'stack')
    })
    
    output$sex <- renderPlotly({ #Gender in x-axis
        plot_ly(common_sym(), x = ~SEX, y = ~Count, 
                type = 'bar', name = 'overall Count') %>%
            add_trace(y = ~LT, name = 'Life Threatening') %>%
            add_trace(y = ~Dead, name = 'Deaths') %>%
            layout(title = 'Symptom Report by Gender',
                   xaxis = list(title = 'Gender'),
                   yaxis = list(title = 'Count'), barmode = 'stack')
    })
    
    output$age_group <- renderPlotly({ #age group in x-axis
        plot_ly(common_sym(), x = ~AGE_YRS, y = ~Count, 
                type = 'bar', name = 'overall Count') %>%
            add_trace(y = ~LT, name = 'Life Threatening') %>%
            add_trace(y = ~Dead, name = 'Deaths') %>%
            layout(title = 'Symptom Report by Age Group',
                   xaxis = list(title = 'Age Group'),
                   yaxis = list(title = 'Count'), barmode = 'stack')
    })
    
    output$manu <- renderPlotly({ #Manufacturer in x-axis
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~Count, 
                type = 'bar', name = 'overall Count') %>%
            add_trace(y = ~LT, name = 'Life Threatening') %>%
            add_trace(y = ~Dead, name = 'Deaths') %>%
            layout(title = 'Symptom Report by Manufacturer',
                   xaxis = list(title = 'Manufacturer'),
                   yaxis = list(title = 'Count'), barmode = 'stack')
    })
    
    output$Intro = renderText({paste('Intro:',
    'If the vaccine is safe, why are there people not taking it?',
    'could it be because they are not reciving the treatment they need to bear through their symptoms for this vaccine?',
    'Or could it be that the vaccine is not as safe as we thought?',
    'How can we fix it so everyone can safely take the vaccine?','Goals:',
    'What kind of medication would help our patiants after taking the vaccine?',
    'Finding top 20 most common symptoms for the COVID-19 vaccine 4 Bar graphs:',
    'Per Symptom', 'Per Gender', 'Per age group', 'Per Manufacturer',
    'Data sources', 'https://vaers.hhs.gov/data/datasets.html?',
    'https://covid.cdc.gov/covid-data-tracker/#vaccinations_vacc-total-admin-rate-total',
    sep = '\n \n')
        })
    
    output$About = renderText('Noah Montero is a free lancing data scientist')
    
})
