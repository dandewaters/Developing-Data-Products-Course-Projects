library(shiny)

# Define UI
shinyUI(fluidPage(
    # Application title
    titlePanel("Predict US Population Size"),
    # Layout
    sidebarLayout(
        sidebarPanel(
            numericInput("year", "What year do you want to predict the US Population for?",
                         value=2000, min=1790, max=3000, step=10),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("popPlot"),
            textOutput("predictionMessage")
        )
    )
))
