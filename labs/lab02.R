#### Part 1: Setup ####
library(tidyverse)
library(xml2)

df <- read_csv("Dec_lsoa_grocery.csv")


#### Part 2: Working with XML ####
selected_cols <- c("area_id", "fat", "saturate", "salt", "protein", "sugar", "carb", "fibre", "alcohol")

df[selected_cols]


#### Extract the first row ####
row1 <- df %>% slice(1)

#### Create root note ####
tesco_data_xml <- xml_new_root("data", .encoding = "UTF-8")
tesco_data_xml

# the encoding is not compulsory 
temp <- xml_new_root("data")
temp

area_node <- xml_new_root("area",
                          area_id = row1 %>% pull(area_id))
area_node

#### Add children nodes to the area node ####
for(nutrient_name in selected_cols[-1]) {
  xml_add_child(area_node, nutrient_name, row1 %>% pull(nutrient_name))
}
area_node
# area node has a bunch of children; the nutritions


#### Add area node as a child to root ####
xml_add_child(tesco_data_xml, area_node)
tesco_data_xml


#### saving the file ####
write_xml(tesco_data_xml, "sample_tesco_data.xml")


#### get area node function ####
get_area_node <- function(row){
  row <- data.frame(row)
  area_node <- xml_new_root("area",
                            area_id = row %>% pull(area_id))
  for(nutrient_name in selected_cols[-1]){
    xml_add_child(area_node, nutrient_name, row %>% pull(nutrient_name))
  }
  
  return(area_node)
}


####
tesco_data_xml_2 <- xml_new_root("data")
selected_rows <- c(1:10)

for(row_number in selected_rows){
  row <- df %>% slice(row_number)
  print(row)
  xml_add_child(tesco_data_xml_2, get_area_node(row))
}

write_xml(tesco_data_xml_2, "sample_tesco_data2.xml")


#### Part 4 ####






#### Reading xml to R ####
tesco_data_xml_2
tesco_data_xml_3 <- read_xml("sample_tesco_data2.xml")
tesco_data_xml_3
