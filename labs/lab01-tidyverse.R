#### SETUP ####
library(tidyverse)

df <- read_csv("Dec_lsoa_grocery.csv")
# This is different from read.csv

#### Filter ####
df %>% filter(area_id == "E01004735")

#### STEP 1 ####
selected_cols <- c("area_id", "carb", "sugar", "alcohol", "population")
df_small <- df %>% select(all_of(selected_cols))


#### STEP 2 ####

# order based on alcohol consumption
df_alc <- df_small %>% arrange(desc(alcohol))


# top and bottom three alcohol consumers (regions)

highest_alc_regions <- top_n(df_alc, 3, alcohol)
highest_alc_regions
lowest_alc_regions <- top_n(df_alc, -3, alcohol)
lowest_alc_regions


# order based on sugar consumption
df_sugar <- df_small %>% arrange(desc(sugar))

# select top and bottom
highest_sugar_regions <- top_n(df_sugar, 3, sugar)
highest_sugar_regions
lowest_sugar_regions <- top_n(df_sugar, -3, sugar)
lowest_sugar_regions


#### STEP 3 ####
# mean and stdev of the population sizes across all LSOA regions
pop_summary <- df_small %>%
  summarize(mean = mean(population),
            standard_deviation = sd(population)
            )
pop_summary

#### STEP 4 ####
ggplot(df, mapping = aes(x = carb, y = sugar)) + geom_point()



