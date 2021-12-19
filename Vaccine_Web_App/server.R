#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output, session) {
    updateSelectInput(session, 'VAX_TYPE', choices = unique(Vax_load$VAX_TYPE))
    
    updateSelectInput(session, 'SYMPTOM_TEXT', choices = unique(Vax_load$SYMPTOM_TEXT))
    
    common_sym <- reactive({
        Vax_load %>%
            filter(VAX_TYPE == input$VAX_TYPE,
                   SYMPTOM_TEXT == input$SYMPTOM_TEXT)
    })
    
    
    output$symptoms <- renderPlotly({
        plot_ly(common_sym(), x = ~SEX, y = ~Count, color = ~AGE_YRS,
                text = ~paste("Age Group: ", AGE_YRS)) %>%
            layout(title = 'Symptom Report by Gender',
                   xaxis = list(title = 'Gender'),
                   yaxis = list(title = 'Symptom Reports'))
    })
    
    output$Critical <- renderPlotly({
        plot_ly(common_sym(), x = ~SEX, y = ~sum(L_THREAT == 'Y'), 
                color = ~AGE_YRS, text = ~paste("Age Group: ", AGE_YRS)) %>%
            layout(title = 'Reports of Life Threatening conditions by Gender',
                   xaxis = list(title = 'Gender'),
                   yaxis = list(title = 'Life Threatening Reports'))
    })
    
    output$Dead <- renderPlotly({
        plot_ly(common_sym(), x = ~SEX, y = ~sum(DIED == 'Y'), 
                color = ~AGE_YRS, text = ~paste("Age Group: ", AGE_YRS)) %>%
            layout(title = 'Death reports by Gender',
                   xaxis = list(title = 'Gender'),
                   yaxis = list(title = 'Deaths'))
    })
    
    output$Symptom_man <- renderPlotly({
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~Count, 
                color = ~AGE_YRS, text = ~paste("Age Group: ", AGE_YRS)) %>%
            layout(title = 'Symptom Reports by Manufacturer',
                   xaxis = list(title = 'Vaccine Manufacturer'),
                   yaxis = list(title = 'Symptom Reports'))
        
    })
    
    output$Critical_man <- renderPlotly({
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~sum(L_THREAT == 'Y'), 
                color = ~AGE_YRS, text = ~paste("Age Group: ", AGE_YRS)) %>%
            layout(title = 'Reports of Life Threatening conditions by manufacturer',
                   xaxis = list(title = 'Vaccine Manufacturer'),
                   yaxis = list(title = 'Life Threatening Reports'))
    })
    
    output$Dead_man <- renderPlotly({
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~sum(DIED == 'Y'), 
                color = ~AGE_YRS, text = ~paste("Age Group: ", AGE_YRS)) %>%
            layout(title = 'Death Reports by manufacturer',
                   xaxis = list(title = 'Vaccine Manufacturer'),
                   yaxis = list(title = 'Deaths'))
    })
    
    
})
