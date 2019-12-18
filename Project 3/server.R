library(shiny)
library(ggplot2)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Create information for us population data and linear model
    data(uspop)
    us_pop <- data.frame(Population=as.matrix(uspop), Year=as.numeric(time(uspop)))
    fit <- lm(Population~Year, data=us_pop)
    slope <- unname(fit$coefficients["Year"])
    intercept <- unname(fit$coefficients["(Intercept)"])
    predict_pop <- function(x){return((slope*x) + intercept)}
    
    # Make prediction
    popPrediction <- reactive({ round(predict_pop(input$year), digits=2) })
    
    # Add prediction point to data frame to make plotting easier
    data_with_pred <- reactive({
        new_point <- c(popPrediction(), input$year)
        df <- rbind(us_pop, new_point)
        return(df)
    })
    
    output$popPlot <- renderPlot({
        plot_data <- data_with_pred()
        # Make scatterplot and line for model
        plot(Population~Year, data=plot_data, type="n",
             main="US Population Trend", xlab = "Year",
             ylab="US Population Size (in Millions)")
        points(Population~Year, data=plot_data, pch=19, col="blue")
        points(y=popPrediction(), x=input$year, pch=19, col="red")
        abline(a=intercept, b=slope, col="black")
    })
    
    output$predictionMessage <- renderText(paste("We predict that the US population in",
                                                 input$year, "will be:",
                                                 popPrediction(), "million!"))
})
