#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyUI(fluidPage(
    
    # Application title
    title = "Vaccine Treatment",
    
    # Application theme
    theme = bs_theme(bootswatch = 'slate'),
    
    # create input for items
    sidebarLayout(
        sidebarPanel(
            selectizeInput('SYMPTOM', label = 'Symptom', choices = NULL),
            selectizeInput('SEX', label = 'Gender', choices = NULL)
        ),
    mainPanel(
        tags$head(tags$style(HTML('
      .modal.in .modal-dialog{
        width:100%;
        height:100%;
        margin:0px;
      }

      .modal-content{
        width:100%;
        height:100%;
      }
    '))),
        tabsetPanel(
            tabPanel("1 Big, 3 Small", fluidRow(
                plotlyOutput("symptoms", height = "720", width = "1080")),
                fluidRow(
                    summaryBox('Box1', 'first test box', width = 3, 
                               style = "primary", border = 'bottom'),
                    summaryBox('Box2', 'second test box', width = 3, 
                               style = "danger", border = 'bottom'),
                    summaryBox('Box3', 'Third test box', width = 3, 
                               style = "warning", border = 'bottom')
                ))
            )
        )
    )
))
