library(tidyverse)

consumption <- read.table("~/github/springboard_capstone_1/alcohol_consumption/state_consumption_data_2.csv", sep = ',', header = TRUE) %>%
              mutate(GEO_ID = as.numeric(as.character(GEO_ID)))

data_source <- read.table("~/github/springboard_capstone_1/alcohol_consumption/data_source.csv", sep = ',', header = TRUE)

state_codes <- read.table("~/github/springboard_capstone_1/alcohol_consumption/state_codes.csv", sep = ',', header = TRUE)%>%
    mutate(GEO_ID = as.numeric(as.character(GEO_ID)))

bev_type <- read.table("~/github/springboard_capstone_1/alcohol_consumption/bev_type.csv", sep = ',', header = TRUE)


combo <- consumption %>%
        left_join(data_source, by = "DATA_SOURCE_CODE") %>%
        left_join(state_codes, by = "GEO_ID") %>%
        left_join(bev_type, by = "BEVERAGE_TYPE_CODE") %>%
        filter(BEVERAGE_TYPE == "All_beverages",
               GEO_ID %in% 1:56, 
               YEAR >= 2010) %>%
        select(one_of(c("YEAR", "GALLONS_ALCOHOL", "GALLONS_ALCOHOL_PER_CAP_21", "DECILE_21",  "STATE", "GEO_ID")))





