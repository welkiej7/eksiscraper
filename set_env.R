set_env <- function(main = "https://eksisozluk1923.com", db.create = FALSE, schema.path, db.path){
  require(rvest)
  require(tidyverse)
  require(httr)
  assign("main.direct", main, envir = .GlobalEnv)
  message("Libraries Loaded... Setting the Database")
  if(db.create == TRUE){
    eksi.base.schema <- as.data.frame(matrix(NA_real_, nrow = 0, ncol = 4))
    colnames(eksi.base.schema) <- c("Topic","Identifier","Page","Date")
    assign("schema",eksi.base.schema, envir = .GlobalEnv)
    write.csv(schema, paste(schema.path,"/schema.csv",sep = ""),row.names = FALSE)
    assign("db.path",db.path, envir = .GlobalEnv)
  } else {
    assign("schema", readr::read_csv(paste(schema.path,"/schema.csv", sep = "")), envir = .GlobalEnv)
    assign("db.path", db.path, envir = .GlobalEnv)
  }
  message("Database Schema and Database Set!")
}
