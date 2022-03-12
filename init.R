# init.R
# (for heroku)
# installs required packages if not already installed.
#


retestr_packages <- c("htmltools","stringi", "stringr", "shinyjs")


install_if_missing <- function(p) {
  if (!p %in% installed.packages()) {
    install.packages(p)
  }
}

invisible(sapply(retestr_packages, install_if_missing))