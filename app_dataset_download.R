library(shiny)
library(rio)


ui <- fluidPage(
    helpText("Choose a dataset to download"),
    selectInput("dataset", "Select the dataset", c("MTcars", "Iris", "Plant Growth")),
    selectInput("filetype", "Select the filetype", c("CSV", "XLSX")),
    downloadButton(
    "downloaddata",
    label = "Download",
    class = NULL,
    icon = shiny::icon("download")
  )
)

  server <- function(input, output) {
    
    data <- reactive({
      switch(input$dataset,
       "MTcars" = mtcars,
       "Iris" = iris,
       "Plant Growth" = plantgrowth)
      })
    

    
    output$downloaddata <- downloadHandler(
      filename = function(){
        paste(input$dataset, Sys.time(), input$filetype, sep = ".")
        },
        content = function(file){
          rio::export(data(), file, format = input$filetype)
          }
        )}

  shinyApp(ui, server)

