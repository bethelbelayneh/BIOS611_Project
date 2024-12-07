library(tidyverse)

data <- read_csv('./derived_data/clean_data.csv')
injuries_per_player <- data %>% group_by(player_name) %>% 
  mutate(total_days_missed = sum(days_missed, na.rm = TRUE), injury_count = n()) %>% 
  slice(1) %>% ungroup()

write_csv(injuries_per_player, "./derived_data/injuries_per_player.csv")