#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Diabetes Probability"),
  
  # Sidebar with a slider inputs
  sidebarLayout(
    sidebarPanel(
       sliderInput("npreg",
                   "Number of Pregnancies (4):",
                   min = 0,
                   max = 17,
                   value = 4),
       sliderInput("glu",
                   "Plasma glucose concentration in oral glucose tolerance test (121):",
                   min = 55,
                   max = 200,
                   value = 121),   
       sliderInput("bp",
                   "Diastolic blood pressure (mm Hg) (72):",
                   min = 24,
                   max = 110,
                   value = 72),
       sliderInput("skin",
                   "Triceps skin fold thickness (mm) (29):",
                   min = 7,
                   max = 100,
                   value = 29),
       sliderInput("bmi",
                   "Body mass index: (33)",
                   min = 15,
                   max = 68,
                   value = 33),
       sliderInput("ped",
                   "Diabetes pedigree function: (0.5)",
                   min = 0.05,
                   max = 2.5,
                   value = 0.5,
                   step = 0.05),
       sliderInput("age",
                   "Age in years: (32)",
                   min = 15,
                   max = 100,
                   value = 32),
       selectInput("variable", "View Effect of:",
                   c("Pregnancies" = "npreg",
                     "Plasma glucose" = "glu",
                     "Blood pressure" = "bp",
                     "Triceps skin fold" = "skin",
                     "BMI" = "bmi",
                     "Diabetes pedigree function" = "ped",
                     "Age" = "age"))
    ),
    
    # Main stuff
    mainPanel(
        h3("Description and Instruction (Documentation)"),
        p("In the background, a logistic regression model is trained via caret (method glm) on the Pima Indian Dataset, more info",a("here.", href="https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/Pima.tr.html")),
        p("This dataset measures different attributes and whether the subjects have diabetes for a population of Native American Women."), 
        p("You can input a new data point through the sliders (the term in parentheses is the mean for the population on which the model was built) and get a probability of a subject with those attributes having diabetes.
           Also, you can choose a variable to see the effect on the probability a change in this variable wold have, keeping all other values the same."),
        h3("Probability of diabetes with chosen values:"),
        textOutput("prob"),
        h3(textOutput("pick")),
        plotOutput("plot")
        
    )
  )
))
