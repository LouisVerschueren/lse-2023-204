#### Part 1: Setup ####
library(tidyverse)
library(xml2)

df <- read_csv("Dec_lsoa_grocery.csv")

selected_columns <- c("area_id", "fat", "saturate", "salt", "protein", "sugar", "carb", "fibre", "alcohol")

tesco_xml_extended <- xml_new_root("data", .encoding = "UTF-8") # data node


get_area_node <- function(row) {
  row <- data.frame(row)
  area_node <- xml_new_root("area", area_id = row %>% pull(area_id)) #area node
  nutrient_statistics_node <- xml_new_root("nutrient-statistics") #nutrient-statistics node
  
  for(nutrient in selected_columns[-1]) {
    nutrient_node <- xml_new_root(nutrient)
    nutrient_stats <- colnames(df)[startsWith(colnames(df), nutrient)]
    for(nutrient_stat in nutrient_stats) {
      xml_add_child(nutrient_node, nutrient_stat, row %>% pull(nutrient_stat))
    }
    xml_add_child(nutrient_statistics_node, nutrient_node)
  }
  xml_add_child(area_node, nutrient_statistics_node)
  return(area_node)
}


for(row_number in 1:10) {
  row <- df %>% slice(row_number)
  xml_add_child(tesco_xml_extended, get_area_node(row))
}
tesco_xml_extended


write_xml(tesco_xml_extended, "Bonus_task_lab02.xml")


