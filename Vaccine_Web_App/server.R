#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output, session) {
    
    updateSelectInput(session, 'SYMPTOM', choices = unique(Vax_load$SYMPTOM))
    updateSelectInput(session, 'SEX', choices = unique(Vax_load$SEX))
    
    common_sym <- reactive({
        Vax_load %>%
            filter(SYMPTOM == input$SYMPTOM & SEX == input$SEX)
    })
    
    showModal(modalDialog(
        title = "Total number of people vaccinated", 
        h1('At least one shot'),
        h2(Vax_total$total_vax),
        h1('Fully Vaccinated'),
        h2(Vax_total$full_vax)
    ))
    
    output$symptoms <- renderPlotly({
        plot_ly(common_sym(), x = ~VAX_MANU, y = ~Count, 
                type = 'bar', name = 'overall Count') %>%
            add_trace(y = ~LT, name = 'Life Threatening') %>%
            add_trace(y = ~Dead, name = 'Deaths') %>%
            layout(title = 'Symptom Report by Gender',
                   xaxis = list(title = 'Manufacturer'),
                   yaxis = list(title = 'Count'), barmode = 'stack')
    })
    
    
})
