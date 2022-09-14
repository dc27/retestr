ui = fluidPage(
  shinyjs::useShinyjs(),
  htmltools::htmlDependency("jquery", "3.3.1",
                            src = c(href = "https://code.jquery.com/"),
                            script = "jquery-3.3.1.min.js"),
  
  tags$head(
    tags$script(type="text/javascript",src=c(href="js/jquery.highlighttextarea/jquery.highlighttextarea.js")),
    tags$link(rel="stylesheet", href="js/jquery.highlighttextarea/jquery.highlighttextarea.css"),
    tags$link(rel="stylesheet", href="styles.css"),
    tags$title("retestr")
  ),
  tags$br(),
  textInput(
    "re_pattern", label = NULL,width = "100%",value = "[:punct:]",
    placeholder = "pattern to test"
  ),
  tags$div(
    class = "textareainContainer",
    textAreaInput(
      "test_string",
      label = NULL,
      value = placeHolderText,
      height = "65vh",
      width = "100%",
      resize = c("none"),
      placeholder = "string to match against"
    )
  ),
  verbatimTextOutput(
    "matchVect"
  ),
  tagList(
    tags$footer(
      tags$p(
        "Made using the ",
        tags$a(
          href = "http://garysieling.github.io/jquery-highlighttextarea/index.html",
          "highlighttextarea plugin", target="_blank"),
        "for jquery. GitHub:",
        tags$a(
          href = "https://github.com/garysieling/jquery-highlighttextarea",
          "garysieling",
          target = "_blank"
        )
      ),
      tags$p(
        "Inspired by sites like: ",
        tags$a(
          href = "https://regexr.com/",
          "regexr.com",
          target = "_blank"
        )
      )
    )
  )
)