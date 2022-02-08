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
        temp_sym = temp %>% drop_na()
    })
    
    
    #Find most common symptoms
    output$sym_rank_1 = renderText({
        symptoms = common_sym() %>%
            group_by(SYMPTOM) %>%
            summarise(Count = sum(Count)) %>%
            filter(Count == max(Count))
        if(nrow(symptoms) == 1){
            paste('The most common symptom is ', symptoms$SYMPTOM, sep = '')
        } else {
            if(sum(symptoms$Count) <= 0){
                paste('The most common symptoms are none.')
            }
            paste('The most common symptoms are ', paste(symptoms$SYMPTOM, collapse = ', '))
        }
              
        })
    
    output$top_LT = renderText({
        LT = common_sym() %>%
            group_by(SYMPTOM) %>%
            summarise(LT = sum(LT)) %>%
            filter(LT == max(LT))
        if(nrow(LT) == 1){
            paste('The most common Life Threatening symptom is ', LT$SYMPTOM, sep = '')
        } else {
            if(sum(LT$LT) <= 0){
                paste('The most common Life Threatening symptoms are none.')
            }
            paste('The most common Life Threatening symptoms are ', paste(LT$SYMPTOM, collapse = ', '))
        }
        })
    
    output$top_D = renderText({
        deaths = common_sym() %>%
            group_by(SYMPTOM) %>%
            summarise(Dead = sum(Dead)) %>%
            filter(Dead == max(Dead))
        if(nrow(deaths) == 1){
            paste('The most common fatal symptom is ', deaths$SYMPTOM, sep = '')
        } else {
            if(sum(deaths$Dead) <= 0){
                paste('The most common fatal symptoms are none.')
            }
            paste('The most common fatal symptoms are ', paste(deaths$SYMPTOM, collapse = ', '))
        }
        })
    
    #Common symptom compassion by gender
    output$sym_sex = renderText({
        sex_symptoms = common_sym() %>%
            group_by(SEX) %>%
            summarise(Count = sum(Count)) %>%
            filter(Count == max(Count)) %>%
            select(SEX)
        if(nrow(sex_symptoms) == 1){
            paste('The selected symptom is more common in ', 
                  sex_symptoms, 's than the other genders.', sep = '')
        } else {
            paste('The selected symptom is more common in ', 
                  paste(sex_symptoms, 's than the other genders.', collapse = ', '))
        }
        })
    
    
    output$LT_sex = renderText({
        sex_LT = common_sym() %>%
            group_by(SEX) %>%
            summarise(LT = sum(LT)) %>%
            filter(LT == max(LT)) %>%
            select(SEX)
        if(nrow(sex_LT) == 1){
            paste('Critical conditions caused by the selected symptom is more common in ', 
                  sex_LT, 's than the other genders.', sep = '')
        } else {
            paste('Critical conditions caused by the selected symptom is more common in ', 
                  paste(sex_LT, 's than the other genders.', collapse = ', '))
        }
        })
    
    output$D_sex = renderText({
        sex_deaths = common_sym() %>%
            group_by(SEX) %>%
            summarise(Dead = sum(Dead)) %>%
            filter(Dead == max(Dead)) %>%
            select(SEX)
        if(nrow(sex_deaths) == 1){
            paste('The selected symptom causes more deaths in ', 
                  sex_deaths, 's than the other genders.', sep = '')
        } else {
            paste('The selected symptom causes more deaths in ', 
                  paste(sex_deaths, 's than the other genders.', collapse = ', '))
        }
        })
    
    
    #Age group compare which is more common
    output$age_sym = renderText({
        age_group_sym = common_sym() %>%
            group_by(AGE_YRS) %>%
            summarise(Count = sum(Count)) %>%
            filter(Count == max(Count)) %>%
            select(AGE_YRS)
        if(nrow(age_group_sym) == 1){
            paste('The selected symptom is more common in ages ', 
                  age_group[as.numeric(age_group_sym)], ' than other age groups.', sep = '')
        } else {
            paste('The selected symptom is more common in ages ', 
                  paste(age_group[as.numeric(unlist(age_group_sym))], collapse = ', '), ' than other age groups.')
        }
        })
    
    output$age_LT = renderText({
        age_group_LT = common_sym() %>%
            group_by(AGE_YRS) %>%
            summarise(LT = sum(LT)) %>%
            filter(LT == max(LT)) %>%
            select(AGE_YRS)
        if(nrow(age_group_LT) == 1){
            paste('Critical conditions caused by the selected symptom is more common in ages ', 
                  age_group[as.numeric(age_group_LT)], ' than other age groups.', sep = '')
        } else {
            paste('Critical conditions caused by the selected symptom is more common in ages ', 
                  paste(age_group[as.numeric(unlist(age_group_LT))], collapse = ', '), ' than other age groups.')
        }
        })
    
    output$age_deaths = renderText({
        age_group_deaths = common_sym() %>% 
            group_by(AGE_YRS) %>%
            summarise(Dead = sum(Dead)) %>%
            filter(Dead == max(Dead)) %>%
            select(AGE_YRS)
        if(nrow(age_group_deaths) == 1){
            paste('The selected symptom causes more deaths in ages ', 
                  age_group[as.numeric(age_group_deaths)], ' than other age groups.', sep = '')
        } else {
            paste('The selected symptom causes more deaths in ages ', 
                  paste(age_group[as.numeric(unlist(age_group_deaths))], collapse = ', '), ' than other age groups.')
        }
        })
    
    #Percentage of fully vaxed
    output$percent = renderText({ 
        manu_common = common_sym() %>%
            group_by(VAX_MANU) %>%
            summarise(Count = sum(Count)) %>%
            filter(Count == max(Count)) %>%
            select(VAX_MANU)
        if(nrow(manu_common) == 1){
            paste('This symptom is more common from the ', 
                  manu_common, ' shot than other manufacturers.', sep = '')
        } else {
            paste('This symptom is more common from the ', 
                  paste(manu_common, collapse = ', '), ' shots than other manufacturers.')
        }
        })
    
    #percentage for manufacturer
    output$per_manu = renderText({
        if(input$VAX_MANU == 'All'){
            paste(signif((Vax_total$full_vax/Vax_total$total_vax)*100, digits = 3),
                  '% of the vaccinated took at least two shots or are fully vaccinated')
        }else{
            paste(signif((sum(ifelse(input$VAX_MANU == 'UNKNOWN MANUFACTURER', Vax_total$Vax_UNK,
                                     ifelse(input$VAX_MANU == 'PFIZER\\BIONTECH', Vax_total$Vax_Pfizer,
                                            ifelse(input$VAX_MANU == 'MODERNA', Vax_total$Vax_moderna, Vax_total$Vax_JnJ))))
                          /Vax_total$full_vax)*100, digits = 3),"% of fully vaccinated took the vaccine from ", input$VAX_MANU, sep = '')
        }
        })
    
    #most common deaths reported by manufacturer
    output$manu_deaths = renderText({
        manu_dead = common_sym() %>%
            group_by(VAX_MANU) %>%
            summarise(Dead = sum(Dead)) %>%
            filter(Dead == max(Dead)) %>%
            select(VAX_MANU)
        if(nrow(manu_dead) == 1){
            paste('The selected symptom causes more deaths from the ', 
                  manu_dead, ' shot than other manufacturers.', sep = '')
        } else {
            paste('The selected symptom causes more deaths from the ', 
                  paste(manu_dead, collapse = ', '), ' shot than other manufacturers.')
        }
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
    
    output$Intro = renderText('<h2>Instuctions:</h2>
    <h4>Click through different tabs to see different different graphs and different corralations</h4>
    <h4>Use the drop bar to select a specific factor that may cause the graph to display a different result</h4>')
    
    output$Conclusion = renderText('<h4> Most common symptoms: </h4>
    <p>1. The overall most common symptom from the COVID-19 shot is Headache </p> 
    <p>2. The overall most common life threatening symptom is Dyspnoea </p> 
    <p>3. The overall most common Fatal symptom is COVID-19 </p> 
    <p>4. Pyrexia is the most common symptom for males, and Childeren </p>
    <h4>Gender comparasion: </h4> 
    <p>1. Overall, the symptoms experienced are more common with Females than males </p> 
    <p>2. Life Threatening cases of symptoms are more common with Females than males </p> 
    <p>3. However, death cases are overall more common in Males than Females </p>
    <h4>Age comparasion: </h4> 
    <p>1. Most of the symptom cases occured for ages between 35+ (35 to 50, 50 to 65, and 65+)
    mostly 50 to 65 in particular </p> 
    <p>2. Age groups that have the highest number of life threatening cases is from ages 50 and up
    (50 to 65 and 65+) </p> 
    <p>3. Age group 65+ has the highest number of death cases </p>
    <h4>Manufacturer compasion: </h4> 
    <p>1. Most of the symptoms was a mix between the Moderna shot and the Pfizer shot </p> 
    <p>2. Moderna has the highest number of cases for causing symptoms </p> 
    <p>3. Pfizer has the highest number of death cases </p> 
    <p>4. 84.6% are fully vaccinated, or have at least two shots. The rest took at least one shot </p> 
    <p>5. The Majority of the fully Vaccinated took the Pfizer shot, which may explain
    why Pfizer has more cases including death cases.</p>')
    
    url_linkedin = a('LinkedIn', href = 'https://www.linkedin.com/in/noah-montero-889aba202/')
    
    output$linkedin = renderUI({
        tagList(url_linkedin)
    })
    
})
