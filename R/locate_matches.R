# since the app doesn't wait for confirmation, capture warnings for incomplete
# regex, rather than cause the app to stop 
re_is_valid <- function(test_string, search_pattern) {
  tryCatch(
    expr = {
      str_detect(test_string, search_pattern)
    },
    error = function(e){ 
      return(FALSE)
    },
    warning = function(w){
      return(FALSE)
    }
  )
}

# function to locate the positional indexes of the starts and ends of patterns
# to be then passed to jquery highlighting plugin
locate_matches <- function(test_string, search_pattern) {
  require(stringr)
  
  # make sure regex is valid
  if (!re_is_valid(test_string, search_pattern)) {
    ranges <- matrix(c(1,0), nrow = 1, byrow = TRUE)
    strs <- c()
  } else {
    ranges <- stringr::str_locate_all(test_string, search_pattern)[[1]]
    strs <- paste0(
      stringr::str_extract_all(
      string = test_string,
      pattern = search_pattern
      ),
      collapse = ""
    )
  }
  
  return(list(ranges = ranges, strs = strs))
}

# convert matrix of starts and ends of matches into a js array format, ready for
# highlighting
convert_to_js_arr <- function(m) {
  
  arr <- ""
  
  # js starts counting at 0, so the start index needs to be moved back by 1.
  for (i in 1:nrow(m)) {
    as_arr_el <- sprintf("[%i,%i]", m[i, 1] -1, m[i,2])
    arr <- paste(arr, as_arr_el, sep=", ")
  }
  
  arr <- str_sub(arr, start = 3)
  
  js_arr <- paste0("[", arr, "]")
  
  return(js_arr)
}
