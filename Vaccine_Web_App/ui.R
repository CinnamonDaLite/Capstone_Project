#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(bslib)
shinyUI(fluidPage(
    
    # Application title
    title = "Vaccine Treatment",
    
    # Application theme
    theme = bs_theme(bootswatch = 'slate'),
    
    # create input for items
    sidebarLayout(
        sidebarPanel(
            selectizeInput('SYMPTOM_TEXT', label = 'Symptom', choices = NULL)
        ),
    mainPanel(
        tabsetPanel(
            tabPanel("By Gender", fluidRow(
                plotlyOutput("symptoms", height = "360", width = "540"),
                plotlyOutput("Critical", height = "360", width = "540"),
                plotlyOutput("Dead", height = "360", width = "540"))),
            tabPanel("By Age", fluidRow(
                plotlyOutput("Symptom_age", height = "360", width = "540"),
                plotlyOutput("Critical_age", height = "360", width = "540"),
                plotlyOutput("Dead_age", height = "360", width = "540"))),
            tabPanel("By Manufacturer", fluidRow(
                plotlyOutput("Symptom_man", height = "360", width = "540"),
                plotlyOutput("Critical_man", height = "360", width = "540"),
                plotlyOutput("Dead_man", height = "360", width = "540"))),
            tabPanel("Overall chance", fluidRow(
                plotlyOutput("overall", height = "720", width = "1080")))
            )
        )
    )
))