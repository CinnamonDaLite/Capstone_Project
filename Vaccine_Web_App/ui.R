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
            selectizeInput('SYMPTOM', label = 'Symptom', choices = c('All', symptoms)),
            selectizeInput('SEX', label = 'Gender', choices = c('All', gender)),
            selectizeInput('VAX_MANU', label = 'Manufacturer', choices = c('All', manufacturer)),
            selectizeInput('AGE_YRS', labe = 'Age group', choices = c('All', age_group))
        ),
    mainPanel(
        tabsetPanel(
          tabPanel("Splash page", fluidRow(
            textOutput('Intro')
            )),
            tabPanel("Symptom graph", fluidRow( #Symptom
              plotlyOutput("symptoms", height = "840", width = "1280")),
              fluidRow(
                  summaryBox('Most Common Symptom', htmlOutput('sym_rank_1'), 
                             style = "primary", border = 'bottom'),
                  summaryBox('Life Threatening symptom', htmlOutput('top_LT'),  
                             style = "warning", border = 'bottom'),
                  summaryBox('Fatal symptom', htmlOutput('top_D'),  
                             style = "danger", border = 'bottom')
              )),
          
          tabPanel("Gender graph", fluidRow( #Gender
            plotlyOutput("sex", height = "840", width = "1280")),
            fluidRow(
                summaryBox('Symptom Commonality', htmlOutput('sym_sex'), 
                           style = "primary", border = 'bottom'),
                summaryBox('Life Threatening commonality', htmlOutput('LT_sex'),  
                           style = "warning", border = 'bottom'),
                summaryBox('Deaths', htmlOutput('D_sex'),  
                           style = "danger", border = 'bottom')
            )),
          
          tabPanel("Age graph", fluidRow( #Age
            plotlyOutput("age_group", height = "840", width = "1280")),
            fluidRow(
                summaryBox('Symptom Commonality', htmlOutput('age_sym'), 
                           style = "primary", border = 'bottom'),
                summaryBox('Life Threatening commonality', htmlOutput('age_LT'),  
                           style = "warning", border = 'bottom'),
                summaryBox('Deaths', htmlOutput('age_deaths'),  
                           style = "danger", border = 'bottom')
            )),
          
          tabPanel("Manufacturer graph", fluidRow( #Manufacturer
            plotlyOutput("manu", height = "840", width = "1280")),
            fluidRow(
              summaryBox('Percentage of people fully vaccinated', 
                         htmlOutput('percent'), style = "primary", border = 'bottom'),
              summaryBox('Percentage of people by Manufacturer', 
                         htmlOutput('per_manu'), style = "warning", border = 'bottom'),
              summaryBox('Box 3', htmlOutput('manu_deaths'), 
                          style = "danger", border = 'bottom')
            )), 
          tabPanel('About', fluidRow(
              textOutput('About')
              ))
            )
        )
    )
))
