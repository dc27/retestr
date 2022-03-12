server = function(input, output, session){
  matches <- reactive(
    locate_matches(
      test_string = input$test_string,
      search_pattern = input$re_pattern
    )
  )
  
  ranges_arr <- reactive(
    convert_to_js_arr(matches()$ranges)
  )
  
  output$matchVect <- renderText(matches()$strs)
  
  # if re pattern is updated ...
  observeEvent(input$re_pattern, {
    
      # construct js expression to highlight matches found by stringr
      js_expr <- paste0(
        "
        $('textarea').highlightTextarea('destroy')
        $('textarea').highlightTextarea({color: '#ADF0FF', ranges: ",
        ranges_arr(),
        ",id:'retestr_highlight'});"
      )
      # execute js (highlight)
      shinyjs::runjs(js_expr)
    
  })
  
  # if test string is updated ...
  observeEvent(input$test_string, {
    # no matches was removing cursor from textarea annoyingly,
    # guard against that condition.
    if (!is.null(matches()$strs)) {
      # construct js expression to highlight matches found by stringr
      # destroy previous highlight but keep cursor position
      js_expr <- paste0(
      "
      // Get current cursor position
      var cursor_pos = $('textarea').prop('selectionStart');
      $('textarea').highlightTextarea('destroy');
      $('textarea').highlightTextarea({color: '#ADF0FF', ranges: ",
      ranges_arr(),
      ",id:'retestr_highlight'});
      $('textarea').focus();
      $('textarea').prop('selectionEnd', cursor_pos);
      "
      )
      # execute js (highlight)
      shinyjs::runjs(js_expr)
    }
  })
}