library(shiny)
library(DT)

shinyUI(fluidPage(
  tags$div(
    style = "text-align: center; margin-bottom: 20px;",
    tags$img(src = "logo.png", height = "100px"),
    tags$h4("A Circadian Expression Platform Across Tissues, Ages, and Feeding States", 
            style = "margin-top: 10px; font-weight: 300; color: #444;")
  ),
  
  tags$div(
    style = "text-align: center; margin: 20px;",
    tags$div(
      style = "display: inline-block; width: 300px;",
      selectizeInput(
        inputId = "search_gene",
        label = tags$strong("Search Gene:"),
        choices = gene_list,
        selected = "Gnai3",
        options = list(
          placeholder = 'Start typing gene symbol...',
          maxOptions = 5,
          openOnFocus = FALSE,
          closeAfterSelect = TRUE,
          highlight = TRUE,
          dropdownParent = 'body'
        ),
        width = '300px'
      )
    ),
    tags$style(HTML("
    .selectize-input {
      box-shadow: none;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 14px;
    }
    .selectize-control.single .selectize-input:after {
      content: none !important;
    }
  "))
  ),
  
  
  
  tags$div(
    style = "max-width: 1000px; margin: auto;",
    tabsetPanel(
      tabPanel("Circadian Profile",
               h4("48-Hour Time Course Expression Profile"),
               plotOutput("circadian_plot", height = "500px")
      ),
      tabPanel("Circadian Summary",
               h4("Maximum Circadian Expression (Per Diet & Age)"),
               plotOutput("gene_expression_plot", height = "500px")
      ),
      
      tabPanel("Multi-Condition Plot",
               h4("Condensed Circadian Expression by Diet and Age"),
               plotOutput("multi_condition_plot", height = "500px")
      ),
      tabPanel("Aging DE Summary",
               h4("Differential Expression with Age"),
               DT::DTOutput("aging_table")
      ),
      tabPanel("Gene Info",
               h4("Gene Annotation and Genomic Information"),
               DT::DTOutput("gene_info")
      )
    )
  )
))
