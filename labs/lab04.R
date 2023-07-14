#### Part 0: Setup ####
library(tidyverse)
library(rvest)

#### Part 1: Navigating the DOM with rvest ####
# Path Logo: 
# body > div.vector-header-container > header > div.vector-header-start > a > img

url <- "https://en.wikipedia.org/"
html <- read_html(url)

logo <- html %>% html_element(xpath = "/html/body/div[1]/header/div[1]/a/img")
html_attrs(logo)

typeof(logo)

#### Part 2: Understanding HTML structure ####
featured_article <- html %>% html_element(xpath = '//*[@id="mp-tfa"]')

featured_article %>% html_element("p") %>% html_text()

featured_article_links <- featured_article %>% html_elements("a") 

titles <- featured_article_links %>% html_attr('title')
hrefs <- featured_article_links %>% html_attr("href")

df <- data.frame(
  title = titles,
  href = hrefs
)
view(df)


#### Part 3: Website crawl ####
first_link <- slice(df, 2)[2]
first_link_url <- paste0("https://en.wikipedia.org", first_link)

html_first_link <- read_html(first_link_url)
html_first_link %>% html_nodes("h2") %>% html_text()



#### Bonus Task ####
select(df, starts_with("/wiki"))
titles <- df[grepl("^/wiki", df$href),][1] # only keep rows that refer to other Wikipedia articles
urls <- df[grepl("^/wiki", df$href),][2] # only keep rows that refer to other Wikipedia articles
links <- lapply(urls, function(x) paste("https://en.wikipedia.org", x, sep=""))
view(links)

featured_article_h2 <- data.frame(
  url = "",
  page_title = "",
  link = "",
  header = ""
)

for(i in 1:lengths(links)){
  link <- sapply(links, "[[", i)
  html_link <- read_html(link)
  vector_headers <- html_link %>% html_elements("h2") %>% html_text()
  string_headers <- vector_headers %>% shQuote(type = "cmd") %>% paste(collapse = ", ")
  featured_article_h2 <- featured_article_h2 %>% add_row(
    url = sapply(urls, "[[", i),
    page_title = sapply(titles, "[[", i),
    link = link,
    header = string_headers
  )
}
view(featured_article_h2)




