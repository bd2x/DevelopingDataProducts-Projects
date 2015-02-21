library(shiny)
library(forecast)

inp <- read.csv("aggregate-ts-1wt-2wt-mc1v-jul07-nov012.csv")
all1wt <- ts(inp$Product_A, freq=12, start=c(2009,9))
all2wt <- ts(inp$Product_B, freq=12, start=c(2009,9))
allMc1v <- ts(inp$Product_C, freq=12, start=c(2009,9))
allProd <- ts(inp$AllWTProducts, freq=12, start=c(2009,9))

all1wtserfcast <- HoltWinters(all1wt)
all2wtserfcast <- HoltWinters(all2wt)
allMc1vserfcast <- HoltWinters(allMc1v)
allProdfcast <- HoltWinters(allProd, beta=FALSE)


# Define server logic required to plot various commodities
shinyServer(function(input, output) {

datasetInput <- reactive(function() {
    switch(input$dataset,
           Product_A = all1wt,
		   Product_B = all2wt,
           AllProducts = allProd)
  })
 
 # Identify which commodity is selected and for how long the data needs displayed 
 
  output$commSelected <- reactive(function() {
   paste(input$dataset, input$range, "month forecast")
})


  # Generate a time series forecast plot of the requested commodity 
 	output$CommForecast <- reactivePlot(function() {
 	all1wtserfcast2 <- forecast.HoltWinters(all1wtserfcast,h=input$range)
	all2wtserfcast2 <- forecast.HoltWinters(all2wtserfcast,h=input$range)
	allMc1vserfcast2 <-  forecast.HoltWinters(allMc1vserfcast,h=input$range)
	allProdfcast2 <-  forecast.HoltWinters(allProdfcast,h=input$range)
	
		switch (input$dataset, 
			Product_A = plot.forecast(all1wtserfcast2),
            Product_B = plot.forecast(all2wtserfcast2),
			AllProducts = plot.forecast(allProdfcast2))})
			
  # include decomposition chart if requested
 	output$CommodityDecomp <- reactivePlot(function() {
		if(input$decompose != FALSE) {
 			switch (input$dataset, 
			Product_A = plot(decompose(all1wt)),
            Product_B = plot(decompose(all2wt)),
			AllProducts = plot(decompose(allProd)))}})

  #Generate a time series table of the requested commodity 
  output$CommodityTable <- reactivePrint(function() {
   	switch (input$dataset, 
		Product_A = forecast.HoltWinters(all1wtserfcast,h=input$range),
		Product_B = forecast.HoltWinters(all2wtserfcast,h=input$range),
		AllProducts = forecast.HoltWinters(allProdfcast,h=input$range))
  })			
 # Generate a summary of the documentation

	output$Help <- renderUI({ 
    
        help_line1 =   '<p><h3></b>How this App works </b></h3></p>'
        help_line2 =   '<p><h4> Loading Data: </h4></p>'
        help_line3 =   '<p><b> The data for your commodities must be uploaded before using the app to make forecasts.</b> </br></br>When you set up the app for the first time, you will be provided a mechanism to connect your historical data to the app server which will generate forecasts. Each data set you connect will be available under the commodity tab for forecasting.</p>'
	help_line4 =   '<p><h4> Generating Forecasts: </h4></p>'
        help_line5 =   '<p> This app is designed to be very intuitive to use. Select the commodity you want to forecast using the drop down selector. Then use the slider to select the number of future months you want to forecast for. Optionally, select whether you want to show the time series decomposition or not using the check box. Thats it. </br></br> <b>Need forecasts for more commodities? </b></br></br>Contact us for pricing 800-555-1212 or info@forecastapps.com</p>'
        # ----------------------------------------------------------------------
        HTML(paste(help_line1,
                   help_line2,
                   help_line3, help_line4, help_line5, 
                   sep = '<br/>'))
        
    })

 
## closing brackets below			
})