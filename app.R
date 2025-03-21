library(shiny)
library(rio)


ui <- fluidPage(
  titlePanel("Upload File Example"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload File", accept = c(".csv", ".xls", ".xlsx", ".txt")),
      helpText("Supported formats: CSV, XLSX, TXT")
    ),
    mainPanel(
      tableOutput("head_table")
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    req(input$file)
    
    
    # Get the file extension
    file_ext <- tools::file_ext(input$file$datapath)
    
    # Define allowed extensions
    allowed_ext <- c(".csv", ".xls", ".xlsx", ".txt")
    
    # Check if the file extension is allowed
    if (!tolower(file_ext) %in% allowed_ext) {
      showNotification("Unsupported file format. Please upload a csv, excel or txtfile.", type = "error")
      return(NULL)
    }
    
    rio::import(input$file$datapath)
  })
  
  output$head_table <- renderTable({
    req(data())
    # Validation checks
    validate(
      need("id" %in% names(data()), "Dataset must contain an 'id' column."),
      need("value" %in% names(data()), "Dataset must contain a 'value' column."),
      need(is.numeric(data()$value), "'value' column must be numeric.")
    )
    
    head(data(), 5)
  })
}

shinyApp(ui, server)
