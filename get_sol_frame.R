get_sol_frame <- function(){
  url <- "https://eksisozluk1923.com"
  frame.attr <- read_html(url)%>%html_nodes('#partial-index > ul')%>%
    html_elements("a")%>%html_attrs() 
  frame.attr <- unlist(frame.attr)
  results <- as.data.frame(matrix(NA_real_, nrow = length(frame.attr), ncol = 2))
  colnames(results) <- c("Topic","Identifier")
  for(row in 1:length(frame.attr)){
    frame.attr[row] <- stringr::str_remove_all(frame.attr[row], pattern = fixed("?a=popular"))
    results[row,] <- stringr::str_split_fixed(frame.attr[row], pattern = "--", n = 2)
  }
  return(results)
}
