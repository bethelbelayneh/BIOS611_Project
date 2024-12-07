library(tidyverse)

data <- read_csv('./derived_data/clean_data.csv')

plt15 <- data %>%
  count(injury_category, season) %>% 
  ggplot(aes(x = reorder(injury_category, -n), y = n, fill = season)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9)) + 
  geom_text(aes(label = n), position = position_dodge(width = 0.8), vjust = -0.5, size = 3) + 
  labs(
    x = "Injury Category",
    y = "Injury Count",
    fill = "Season", 
    title = "Injury Category Count by Competitive Season"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 55, hjust = 1, size = 11),
    plot.title = element_text(face = "bold"),
    legend.position = c(0.9, 0.8),
    legend.background = element_rect(fill = "white", color = "black"))

ggsave("./figures/inj_category_bar.png", plot = plt15, 
       width = 15)

