source("R/locate_matches.R")

placeHolderText = paste0(
  stringi::stri_rand_lipsum(n_paragraphs = 2),
  collapse = "\n\n"
)