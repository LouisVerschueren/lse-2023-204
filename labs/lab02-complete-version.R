#### Part 1: Setup ####
library(tidyverse)
library(xml2)

#### Part 2: Working with XML ####
# load in the data
df <- read_csv("Dec_lsoa_grocery.csv")

# select the relevant columns
selected_columns <- c("area_id", "fat", "saturate", "salt", "protein", "sugar", "carb", "fibre", "alcohol")
df[selected_columns]

# we want to convert a single row of data to XML and save it to a file
# select the row that we want to convert
row1 <- df %>% slice(1)

# create empty xml 'document' and assign a root node
tesco_row1_xml <- xml_new_root("data", .encoding = "UTF-8")
tesco_row1_xml

# create area_id root node
area_node <- xml_new_root("area", area_id = row1 %>% pull(area_id))
area_node

# Add children nodes to the area node (the nutrients)

for(nutrient in selected_columns[-1]) {
  xml_add_child(area_node, nutrient, row1 %>% pull(nutrient))
}
area_node

xml_add_child(tesco_row1_xml, area_node)
tesco_row1_xml

write_xml(tesco_row1_xml, "tesco_row1_xml1.xml")

#### Part 3: Multiple rows of data ####
# we will need a function that can convert a row of data to xml, in other words,
# a function that creates an area node for each row and that adds the child notes for all the nutrients

get_area_node <- function(row) {
  row <- data.frame(row)
  area_node <- xml_new_root("area", area_id = row %>% pull(area_id))
  
  for(nutrient in selected_columns[-1]) {
    xml_add_child(area_node, nutrient, row %>% pull(nutrient))
  }
  return(area_node)
}


tesco_10rows_xml <- xml_new_root("data", encoding = "UTF-8")
for(row_number in 1:10) {
  row <- df %>% slice(row_number)
  xml_add_child(tesco_10rows_xml, get_area_node(row))
}
tesco_10rows_xml  
write_xml(tesco_10rows_xml, "large_sample3.xml")


#### Part 4: Hierarchical XML ####
get_area_node <- function(row) {
  row <- data.frame(row)
  area_node <- xml_new_root("area", area_id = row %>% pull(area_id))
  nutrients_node <- xml_new_root("nutrients")
  
  for(nutrient in selected_columns[-1]) {
    xml_add_child(nutrients_node, nutrient, row %>% pull(nutrient))
  }
  xml_add_child(area_node, nutrients_node)
  return(area_node)
}


tesco_10rows_xml2 <- xml_new_root("data", encoding = "UTF-8")
for(row_number in 1:10) {
  row <- df %>% slice(row_number)
  xml_add_child(tesco_10rows_xml2, get_area_node(row))
}
tesco_10rows_xml2
write_xml(tesco_10rows_xml2, "large_sample5.xml")
