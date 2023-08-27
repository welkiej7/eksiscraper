set_env <- function(main = "https://eksisozluk1923.com", db.create = FALSE, schema.path, db.path){
  require(rvest)
  require(tidyverse)
  require(httr)
  assign("main.direct", main, envir = .GlobalEnv)
  message("Libraries Loaded... Setting the Database")
  if(db.create == TRUE){
    eksi.base.schema <- as.data.frame(matrix(NA_real_, nrow = 0, ncol = 3))
    colnames(eksi.base.schema) <- c("Topic","Page","Date")
    assign("eksi.base.schema",eksi.base.schema, envir = .GlobalEnv)
    write.csv(eksi.base.schema, schema.path, row.names = FALSE)
    assign("db.path",db.path, envir = .GlobalEnv)
  } else {
    assign("eksi.base.schema", readr::read_csv(schema.path), envir = .GlobalEnv)
    assign("db.path", db.path, envir = .GlobalEnv)
  }
  message("Database Schema and Database Set!")
}
