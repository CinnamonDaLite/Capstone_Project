#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output, session) {
    
    updateSelectInput(session, 'SYMPTOM_TEXT', choices = unique(Vax_load$SYMPTOM_TEXT))
    
    common_sym <- reactive({
        Vax_load %>%
            filter(SYMPTOM_TEXT == input$SYMPTOM_TEXT)
    })
    
    output$overall <- renderPlotly({
        plot_ly(Vax_total, x = ~shot, y = ~Percentage, 
                type = 'bar', color = ~Condition) %>%
            layout(title = 'Overall chances of vaccine symptoms',
                   barmode = 'stack')
    })
    
    output$symptoms <- renderPlotly({
        plot_ly(common_sym(), x = ~SEX, y = ~Count, 
                type = 'bar', color = ~SEX) %>%
            layout(title = 'Symptom Report by Gender',
                   xaxis = list(title = 'Gender'),
                   yaxis = list(title = 'Symptom Reports'))
    })
    
    output$Critical <- renderPlotly({
        plot_ly(common_sym(), x = ~SEX, y = ~sum(L_THREAT == 'Y'), 
                type = 'bar', color = ~SEX) %>%
            layout(title = 'Reports of Life Threatening conditions by Gender',
                   xaxis = list(title = 'Gender'),
                   yaxis = list(title = 'Life Threatening Reports'))
    })
    
    output$Dead <- renderPlotly({
        plot_ly(common_sym(), x = ~SEX, y = ~sum(DIED == 'Y'), 
                type = 'bar', color = ~SEX) %>%
            layout(title = 'Death reports by Gender',
                   xaxis = list(title = 'Gender'),
                   yaxis = list(title = 'Deaths'))
    })
    
    output$Symptom_man <- renderPlotly({
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~Count, 
                type = 'bar', color = ~VAX_MANU) %>%
            layout(title = 'Symptom Reports by Manufacturer',
                   xaxis = list(title = 'Vaccine Manufacturer'),
                   yaxis = list(title = 'Symptom Reports'))
        
    })
    
    output$Critical_man <- renderPlotly({
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~sum(L_THREAT == 'Y'), 
                type = 'bar', color = ~VAX_MANU) %>%
            layout(title = 'Reports of Life Threatening conditions by manufacturer',
                   xaxis = list(title = 'Vaccine Manufacturer'),
                   yaxis = list(title = 'Life Threatening Reports'))
    })
    
    output$Dead_man <- renderPlotly({
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~sum(DIED == 'Y'), 
                type = 'bar', color = ~VAX_MANU) %>%
            layout(title = 'Death Reports by manufacturer',
                   xaxis = list(title = 'Vaccine Manufacturer'),
                   yaxis = list(title = 'Deaths'))
    })
    
    output$Symptom_age <- renderPlotly({
        plot_ly(common_sym(), x = ~AGE_YRS, y = ~Count, 
                type = 'bar', color = ~AGE_YRS) %>%
            layout(title = 'Symptom Reports by Age',
                   xaxis = list(title = 'Age'),
                   yaxis = list(title = 'Symptom Reports'))
        
    })
    
    output$Critical_age <- renderPlotly({
        plot_ly(common_sym(), x = ~AGE_YRS, y = ~sum(L_THREAT == 'Y'), 
                type = 'bar', color = ~AGE_YRS) %>%
            layout(title = 'Reports of Life Threatening conditions by Age',
                   xaxis = list(title = 'Age'),
                   yaxis = list(title = 'Life Threatening Reports'))
    })
    
    output$Dead_age <- renderPlotly({
        plot_ly(common_sym(), x = ~AGE_YRS, y = ~sum(DIED == 'Y'), 
                type = 'bar', color = ~AGE_YRS) %>%
            layout(title = 'Death Reports by Age',
                   xaxis = list(title = 'Age'),
                   yaxis = list(title = 'Deaths'))
    })
    
})
