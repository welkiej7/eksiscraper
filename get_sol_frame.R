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
