% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spsServerCollections.R
\name{shinyCheckPkg}
\alias{shinyCheckPkg}
\title{Shiny package checker}
\usage{
shinyCheckPkg(
  session,
  cran_pkg = NULL,
  bioc_pkg = NULL,
  github = NULL,
  quietly = FALSE
)
}
\arguments{
\item{session}{shiny session}

\item{cran_pkg}{a vector of package names}

\item{bioc_pkg}{a vector of package names}

\item{github}{a vector of github packages, github package must use the format of
"github user name/ repository name", eg. c("user1/pkg1", "user2/pkg2")}

\item{quietly}{bool, should warning messages be suppressed?}
}
\value{
TRUE if pass, sweet alert massage and FALSE if fail
}
\description{
A server end function to check package namespace for some required
packages of users' environment. If all packages are installed, a successful message
will be displayed on the bottom-right. If not, pop up
a message box in shiny to tell users how to install the missing packages.

This is useful when some of packages are required by a shiny app. Before
running into that part of code, using this function to check the required
pakcage and pop up warnings will prevent app to crash.
}
\examples{
if(interactive()){
  library(shiny)

  ui <- fluidPage(
    tags$label('Check if package "pkg1", "pkg2", "bioxxx",
                    github package "user1/pkg1" are installed'), br(),
    actionButton("check_random_pkg", "check random_pkg"),
    br(), spsHr(),
    tags$label('We can combine `spsValidate` to block server code to prevent
                     crash if some packages are not installed.'), br(),
    tags$label('If "shiny" is installed, make a plot.'), br(),
    actionButton("check_shiny", "check shiny"), br(),
    tags$label('If "ggplot99" is installed, make a plot.'), br(),
    actionButton("check_gg99", "check ggplot99"), br(),
    plotOutput("plot_pkg")
  )

  server <- function(input, output, session) {
    observeEvent(input$check_random_pkg, {
      shinyCheckPkg(session, cran_pkg = c("pkg1", "pkg2"),
                    bioc_pkg = "bioxxx", github = "user1/pkg1")
    })
    observeEvent(input$check_shiny, {
      spsValidate(verbose = FALSE, {
        if(!shinyCheckPkg(session, cran_pkg = c("shiny"))) stop("Install packages")
      })
      output$plot_pkg <- renderPlot(plot(1))
    })
    observeEvent(input$check_gg99, {
      spsValidate({
        if(!shinyCheckPkg(session, cran_pkg = c("ggplot99"))) stop("Install packages")
      })
      output$plot_pkg <- renderPlot(plot(99))
    })
  }

  shinyApp(ui, server)
}
}
