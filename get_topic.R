get_topic <- function(main = "https://eksisozluk1923.com/", link, leftover = FALSE){
  main.page <- rvest::read_html(paste(main,link, "?p=1", sep = ""))
  page.count <-main.page%>%
      html_elements(xpath = "/html/body/div[2]/div[2]/div[2]/section/div[1]/div[1]/div[2]")%>%
      html_attr("data-pagecount")
  page.count <- as.numeric(page.count)
  results <- as.data.frame(matrix(NA_real_, nrow = 0, ncol = 3))
  colnames(results) <- c("Suser","Content","Date")
  if(!leftover){
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
    pbar <- txtProgressBar(min = leftover, max = page.count, char = "≈", style = 3)
    message("Updating the Topic")
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
  return(results)
}
