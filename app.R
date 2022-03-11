library(shiny)

source("R/locate_matches.R")

placeHolderText = paste0(
  stringi::stri_rand_lipsum(n_paragraphs = 2),
  collapse = "\n\n"
)

# destroy previous highlight but keep cursor position
ui = fluidPage(
  shinyjs::useShinyjs(),
  htmltools::htmlDependency("jquery", "3.3.1",
                            src = c(href = "https://code.jquery.com/"),
                            script = "jquery-3.3.1.min.js"),
  
  tags$head(
    tags$script(type="text/javascript",src=c(href="js/jquery.highlighttextarea/jquery.highlighttextarea.js")),
    tags$link(rel="stylesheet", href="js/jquery.highlighttextarea/jquery.highlighttextarea.css"),
    tags$link(rel="stylesheet", href="styles.css"),
  ),
  tags$br(),
  textInput("re_pattern", label = NULL, width = "100%", value = "[:punct:]"),
  tags$div(class = "textareainContainer",
    textAreaInput(
    "test_string",
    label = NULL,
    value = placeHolderText,
    height = "65vh",
    width = "100%",
    resize = c("none")
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

server = function(input, output, session){
  
  # update if either input is changed
  listenInputs <- reactive(
    list(
      input$re_pattern,
      input$test_string
    )
  )
  
  observeEvent(input$re_pattern, {
    matches <- locate_matches(
      test_string = input$test_string,
      search_pattern = input$re_pattern
    )
  
    ranges_arr <- convert_to_js_arr(matches$ranges)
    
    output$matchVect <- renderText(matches$strs)
    
    # construct js expression to highlight matches found by stringr
    js_expr <- paste0(
      "
      $('textarea').highlightTextarea('destroy')
      $('textarea').highlightTextarea({color: '#ADF0FF', ranges: ",
      ranges_arr,
      ",id:'retestr_highlight'});"
    )
    # execute js (highlight)
    shinyjs::runjs(js_expr)
    
  })
  
  observeEvent(input$test_string, {
    
      matches <- locate_matches(
          test_string = input$test_string,
          search_pattern = input$re_pattern
          )
      
      ranges_arr <- convert_to_js_arr(matches$ranges)
      
      output$matchVect <- renderText(matches$strs)
      
      # construct js expression to highlight matches found by stringr
      js_expr <- paste0(
      "
      // Get current cursor position
      var cursor_pos = $('textarea').prop('selectionStart');
      $('textarea').highlightTextarea('destroy');
      $('textarea').highlightTextarea({color: '#ADF0FF', ranges: ",
      ranges_arr,
      ",id:'retestr_highlight'});
      $('textarea').focus();
      $('textarea').prop('selectionEnd', cursor_pos);
      "
      )
      # execute js (highlight)
      shinyjs::runjs(js_expr)
  })
}

shinyApp(ui, server)