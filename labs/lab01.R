#### SETUP ####
df <- read.csv("Dec_lsoa_grocery.csv")

a  <-  df[df["area_id"] == "E01004735",]

#### STEP 1 ####
selected_cols <- c("area_id", "carb", "sugar", "alcohol", "population")
df <- df[selected_cols]


#### STEP 2 ####

# order based on alcohol consumption
df_alc <- df[order(df$alcohol, decreasing = TRUE),]

# top and bottom three alcohol consumers (regions)
highest_alc_regions <-  head(df_alc, n = 3)
highest_alc_regions
lowest_alc_regions <- tail(df_alc, 3)
lowest_alc_regions


# order based on sugar consumption
df_sugar <- df[order(df$sugar, decreasing = TRUE),]

# select top and bottom
highest_sugar_regions <- head(df_sugar, 3)
highest_sugar_regions
lowest_sugar_regions <- tail(df_sugar, 3)
lowest_sugar_regions


#### STEP 3 ####
# mean and stdev of the population sizes across all LSOA regions
pop_mean <- mean(df$population, na.rm = TRUE)
pop_stdedv <- sd(df$population, na.rm = TRUE)

pop_summary <- data.frame(mean = pop_mean,
                          standard_deviation = pop_stdedv
)

pop_summary

#### STEP 4 ####
plot(df$carb, df$sugar)

