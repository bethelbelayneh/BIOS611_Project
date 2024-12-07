library(tidyverse)
library(hrbrthemes)
library(viridis)
library(cowplot)

injuries_per_player <- read_csv('./derived_data/injuries_per_player.csv')

plt6 <- ggplot(injuries_per_player, aes(x= reorder(position_category, -table(position_category)[position_category]), y=injury_count, fill=position_category)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.3, alpha=0.7) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.title.x = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.title.y = element_text(size = 7)
  ) +
  ggtitle("Injuries per Player by Position Category (2021-2023)") +
  xlab("Position Category") +
  ylab("Injury Counts per Player")
  
plt7 <- ggplot(injuries_per_player, aes(x= reorder(position_category, -table(position_category)[position_category]), y=total_days_missed, fill=position_category)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.3, alpha=0.7) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.title.x = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.title.y = element_text(size = 7)
  ) +
  ggtitle("Total Days Missed due to Injury per Player by Position Category (2021-2023)") +
  xlab("Position Category") +
  ylab("Total Days Missed due to Injury per Player")
  
plt8 <- ggplot(injuries_per_player, aes(x= reorder(club_position, -table(club_position)[club_position]), y=injury_count, fill=club_position)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.3, alpha=0.7) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=13),
    axis.title.x = element_text(size = 10),
    axis.text.x = element_text(size = 8),
    axis.title.y = element_text(size = 7)
  ) +
  ggtitle("Injuries per Player by Specific Positions (2021-2023)") +
  xlab("Specific Position Names") +
  ylab("Injury Counts per Player")
  
plot3 <- plot_grid(plt6, plt8, plt7, nrow = 3)

ggsave("./figures/injury_vs_position_box.png", plot = plot3, 
       width = 15, 
       height = 14)