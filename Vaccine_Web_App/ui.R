#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shinydashboard)
dashboardPage(
    
    # Application title
    dashboardHeader(title = "Carcrash Data"),
    
    # create input for items
    dashboardSidebar(
        sidebarMenu( 
            menuItem("Graphs", tabName = 'Graphs', icon = icon('chart-bar')),
            menuItem("Raw Data", tabName = 'map', icon = icon("map"))
        ),
        selectizeInput('VAX_TYPE', label = 'Vaccine for', choices = NULL),
        selectizeInput('SYMPTOM_TEXT', label = 'Symptom', choices = NULL)
    ),
    
    # Show a plot of the generated distribution
    dashboardBody(
        tabItems(
            tabItem(tabName = "Graphs",
                    fluidRow(
                        box(plotlyOutput("symptoms", height = "360", width = "540")),
                        box(plotlyOutput("Critical", height = "360", width = "540")),
                        box(plotlyOutput("Dead", height = "360", width = "540")),
                        box(plotlyOutput("Symptom_man", height = "360", width = "540")),   
                        box(plotlyOutput("Critical_man", height = "360", width = "540")),
                        box(plotlyOutput("Dead_man", height = "360", width = "540")) 
                    )),
            tabItem(tabName = 'map', 
                    #this will create a space for us to display our map
                    leafletOutput(outputId = "mymap"), #this allows me to put the checkmarks ontop of the map to allow people to view earthquake depth or overlay a heatmap
                    absolutePanel(top = 60, left = 20, 
                                  checkboxInput("markers", "Depth", FALSE),
                                  checkboxInput("heat", "Heatmap", FALSE)
                    ))
        )
    )
)