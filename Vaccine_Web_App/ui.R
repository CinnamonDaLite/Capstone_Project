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
          tabPanel("Splash page", fluidPage(htmlOutput('Intro')
            )),
            tabPanel("Symptom graph", fluidRow( #Symptom
              plotlyOutput("symptoms", height = "840", width = "1280")),
              fluidRow(
                  summaryBox('Most Common Symptom', htmlOutput('sym_rank_1'),
                             icon = 'fas fa-syringe', style = "primary", border = 'bottom'),
                  summaryBox('Life Threatening symptom', htmlOutput('top_LT'),
                             icon = 'fas fa-biohazard', style = "warning", border = 'bottom'),
                  summaryBox('Fatal symptom', htmlOutput('top_D'),  
                             icon = 'fas fa-skull-crossbones', style = "danger", border = 'bottom')
              )),
          
          tabPanel("Gender graph", fluidRow( #Gender
            plotlyOutput("sex", height = "840", width = "1280")),
            fluidRow(
                summaryBox('Symptom Commonality', htmlOutput('sym_sex'), 
                           icon = 'fas fa-syringe', style = "primary", border = 'bottom'),
                summaryBox('Life Threatening commonality', htmlOutput('LT_sex'),  
                           icon = 'fas fa-biohazard', style = "warning", border = 'bottom'),
                summaryBox('Deaths', htmlOutput('D_sex'),  
                           icon = 'fas fa-skull-crossbones', style = "danger", border = 'bottom')
            )),
          
          tabPanel("Age graph", fluidRow( #Age
            plotlyOutput("age_group", height = "840", width = "1280")),
            fluidRow(
                summaryBox('Symptom Commonality', htmlOutput('age_sym'), 
                           icon = 'fas fa-syringe', style = "primary", border = 'bottom'),
                summaryBox('Life Threatening commonality', htmlOutput('age_LT'),  
                           icon = 'fas fa-biohazard', style = "warning", border = 'bottom'),
                summaryBox('Deaths', htmlOutput('age_deaths'),  
                           icon = 'fas fa-skull-crossbones', style = "danger", border = 'bottom')
            )),
          
          tabPanel("Manufacturer graph", fluidRow( #Manufacturer
            plotlyOutput("manu", height = "840", width = "1280")),
            fluidRow(
              summaryBox('Symptom Shots', htmlOutput('percent'), icon = 'fas fa-syringe', 
                         style = "primary", border = 'bottom'),
              summaryBox('Percentage of people by Manufacturer', 
                         htmlOutput('per_manu'), style = "warning", border = 'bottom'),
              summaryBox('Manufacturer deaths', htmlOutput('manu_deaths'), 
                         icon = 'fas fa-skull-crossbones', style = "danger", border = 'bottom')
            )),
          tabPanel('Conclusion', fluidRow(
              htmlOutput('Conclusion') 
          )),
          tabPanel('About', fluidPage(
              h5('Noah Montero is a free lancing computer scientist who enjoyes coding and anything tech-related.'),
              h5('He is also interested in asssisting the medical business with anything tech-related including data science.'),
              h5('The list of things he does for a hobby is the following'),
              h6('1. build custom desktops'),
              h6('2. provide tech support for family and friends'),
              h6('3. Tweek linux boxes for gamming/peak performance'),
              h6('4. Coding projects that are soon to be made'),
              h5('You can find him on LinkedIn via link below'),
              uiOutput('linkedin')
              ))
            )
        )
    )
))
