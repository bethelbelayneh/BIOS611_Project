library(tidyverse)
library(hrbrthemes)
library(viridis)

data <- read_csv('./derived_data/clean_data.csv')
injuries_per_season <- data %>% group_by(season, player_name) %>% tally()

plt3 <- ggplot(injuries_per_season, aes(x= reorder(season, -table(season)[season]), y=n, fill=season)) +
  geom_boxplot() +
  scale_fill_manual(values = c("21/22" = "#E97D72", 
                               "22/23" = "#56BBC1")) +  
  geom_jitter(color="black", size=0.3, alpha=0.7) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.title.x = element_text(size = 10), 
    axis.title.y = element_text(size = 10)
  ) +
  ggtitle("Injuries per Player by Competitive Season (21/22 vs. 22/23)") +
  xlab("Season") +
  ylab("Injury Counts per Player")

ggsave("./figures/season_injury_box.png", plot = plt3, 
       width = 13, 
       height = 6)