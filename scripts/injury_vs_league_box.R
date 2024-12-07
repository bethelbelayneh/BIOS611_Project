library(tidyverse)
library(hrbrthemes)
library(viridis)
library(cowplot)

injuries_per_player <- read_csv('./derived_data/injuries_per_player.csv')

plt4 <- ggplot(injuries_per_player, aes(x= reorder(league_name, -table(league_name)[league_name]), y=injury_count, fill=league_name)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.13, alpha=0.7) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.title.x = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.title.y = element_text(size = 10)
  ) +
  ggtitle("Injuries per Player by League (2021-2023)") +
  xlab("League Names") +
  ylab("Injury Counts per Player")

plt5 <- ggplot(injuries_per_player, aes(x= reorder(league_name, -table(league_name)[league_name]), y=total_days_missed, fill=league_name)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.13, alpha=0.7) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.title.x = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.title.y = element_text(size = 10)
  ) +
  ggtitle("Total Days Missed due to Injury per Player by League (2021-2023)") +
  xlab("League Names") +
  ylab("Total Days Missed due to Injury per Player") + 
  ylim(0, 1113)

plot2 <- plot_grid(plt5, plt4, nrow = 2)

ggsave("./figures/injury_vs_league_box.png", plot = plot2,
       width = 15,
       height = 13)