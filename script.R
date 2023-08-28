#0. Preamble
require(tidyverse)
require(rvest)
run.time <- 100 # An integer that defines the total number of iterations. 
refresh.time <- 20 # An integer that defines the required minutes between iterations.
schema.path <- "/Users/onurtuncaybal/Documents/R Projects/EksiScraper/"
db.path <- "/Users/onurtuncaybal/Documents/R Projects/EksiScraper/Database"

#1. Functions.
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

get_topic <- function(main = "https://eksisozluk1923.com", link, leftover = FALSE){
  main.page <- rvest::read_html(paste(main,link, "?p=1", sep = ""))
  page.count <-main.page%>%
      html_elements(xpath = "/html/body/div[2]/div[2]/div[2]/section/div[1]/div[1]/div[2]")%>%
      html_attr("data-pagecount")
  page.count <- as.numeric(page.count)
  results <- as.data.frame(matrix(NA_real_, nrow = 0, ncol = 3))
  colnames(results) <- c("Suser","Content","Date")
  message(paste("Retrieving",link))
  if(leftover == FALSE){
    pbar <- txtProgressBar(min = 0, max = page.count, char = "≈", style = 3)
    message("New Iteration in Progress...")
      for(page in 1:page.count){
         moving.page <- rvest::read_html(paste(main,link,"?p=", page, sep = ""))
         users_vector <- moving.page%>%html_nodes(".entry-author")%>%html_text2()
         content_vector <- moving.page%>%html_nodes(".content")%>%html_text2()%>%stringr::str_remove_all("\n")
         date_vector <- moving.page%>%html_nodes(".entry-date")%>%html_text2()   
         temp.frame <- data.frame(users_vector, content_vector, date_vector)
         colnames(temp.frame) <- colnames(results)
         results <- rbind(results,temp.frame)
         rm(temp.frame)
         setTxtProgressBar(value = page, pb = pbar)       
      }
   } else {
    pbar <- txtProgressBar(min = leftover, max = page.count + 1, char = "≈", style = 3)
    message("Updating the Topic")
    if(leftover != page.count){
    for(page in leftover:page.count){
      moving.page <- rvest::read_html(paste(main,link,"?p=", page, sep = ""))
      users_vector <- moving.page%>%html_nodes(".entry-author")%>%html_text2()
      content_vector <- moving.page%>%html_nodes(".content")%>%html_text2()%>%stringr::str_remove_all("\n")
      date_vector <- moving.page%>%html_nodes(".entry-date")%>%html_text2()   
      temp.frame <- data.frame(users_vector, content_vector, date_vector)
      colnames(temp.frame) <- colnames(results)
      results <- rbind(results,temp.frame)
      rm(temp.frame)
      setTxtProgressBar(value = page, pb = pbar)       
    }
    }
  }
  return(list(results, page.count))
}

get_sol_frame <- function(){
  url <- "https://eksisozluk1923.com"
  read_html(url)%>%html_nodes('#partial-index > ul')%>%
    html_elements("a")%>%html_attrs() -> frame.attr
  frame.attr <- unlist(frame.attr)
  frame.attr <- str_remove_all(frame.attr, pattern = fixed("?a=popular"))
  frame.attr <- as.data.frame(str_split_fixed(frame.attr, pattern = "--", n =2 ))
  colnames(frame.attr) <- c("Topic","Identifier")
  return(frame.attr)
}




#2. Script
set_env(db.create = TRUE, 
schema.path = schema.path ,
db.path = db.path) 
#Database Step, if first run, that is db.create = TRUE, will create a table called schema in the 
#Global environment. otherwise, it will read the already existing schema. 
### PROGRAM
for(run in 1:run.time){
  message(paste("Cycle No:",run))
  ##Get the Topics
  current.frame <- get_sol_frame()
  for(topic in 1:nrow(current.frame)){
    exists <- current.frame$Identifier[topic] %in% schema$Identifier
    if(exists){
     entry.row <- which(schema$Identifier %in% current.frame$Identifier[topic])
     leftover.no <- schema$Page[entry.row]
     retrieved <- get_topic(link = paste(current.frame$Topic[topic],"--", 
     current.frame$Identifier[topic], sep = ""), leftover = leftover.no)
     temp.frame <- retrieved[[1]]
     main.frame <- readr::read_csv(paste(db.path,current.frame$Topic[topic],".csv", sep = ""))
     main.frame <- rbind(temp.frame, main.frame) 
     ## Updated the Topic and Wrote it to Disk
     write.csv(main.frame, paste(db.path,current.frame$Topic[topic],".csv", sep = ""), row.names = FALSE)
     rm(main.frame)
    ## Update the schema
      schema$Page[entry.row] <- retrieved[[2]]
    write.csv(schema, paste(schema.path,"schema.csv",sep = ""), row.names = FALSE)
    Sys.sleep(8)
    ## Done.
    } else {
    ## This part runs to create a file in the database and updates schema. 
    retrieved <- get_topic(link = paste(current.frame$Topic[topic],"--", 
     current.frame$Identifier[topic], sep = ""))
    main.frame <- retrieved[[1]]
    page.info <- retrieved[[2]]
    write.csv(main.frame, paste(db.path,current.frame$Topic[topic],".csv", sep = ""), row.names = FALSE)
    rm(main.frame)
    db.update <- data.frame(current.frame$Topic[topic], current.frame$Identifier[topic], page.info, Sys.time())
    colnames(db.update) <- colnames(schema)
    schema <- rbind(db.update, schema)
    write.csv(schema, paste(schema.path,"/schema.csv",sep = ""), row.names = FALSE)
    }
  }
  message("Waiting for refresh...")
  schema <- readr::read_csv(paste(schema.path,"schema.csv",sep = ""))
  pbar <- txtProgressBar(min = 0, max = refresh.time, style = 3, char = "|**|")
  for(min in 1:refresh.time){
    setTxtProgressBar(pbar, value = min)
    Sys.sleep(60)
  }
}

