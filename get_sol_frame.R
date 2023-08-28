get_sol_frame <- function(){
rvest::read_html("https://eksisozluk1923.com") -> content.html
content.html%>%
html_elements(xpath = "/html[1]/body[1]/div[2]/div[1]/nav[1]/ul[1]")%>%
rvest::html_text()  -> frame

stringr::str_remove_all(frame, '\n') -> frame
frame%>%stringr::str_split("\r") -> frame
frame[[1]] -> frame
sol_frame_fin <- c()
for(i in 1:length(frame)){
    if(stringr::str_count(frame[i]) >= 13 ){
    sol_frame_fin <- append(sol_frame_fin, frame[i], after = 1)
    } 
}
return(sol_frame_fin)
}

get_sol_frame_links <- function(){
    url <- "https://eksisozluk1923.com"
    read_html(url)%>%html_nodes('#partial-index > ul')%>%
    html_elements("a")%>%html_attrs() -> frame.attr
    return(unlist(frame.attr))
}
