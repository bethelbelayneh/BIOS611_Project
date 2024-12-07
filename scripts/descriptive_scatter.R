library(tidyverse)
library(cowplot)
library(hrbrthemes)

injuries_per_player <- read_csv('./derived_data/injuries_per_player.csv')

plt11 <- ggplot(injuries_per_player, aes(x=wage_eur, y=injury_count, color = league_name)) +
  geom_jitter(size = 1, alpha = 0.8, width = 0.5, height = 1) +
  labs(colour = "League") + 
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  theme_ipsum() + 
  theme(
    axis.title.x = element_text(size = 13), 
    axis.title.y = element_text(size = 13),
    plot.title = element_text(size = 16)) + 
  scale_x_continuous(labels = scales::dollar_format()) +
  ggtitle("Injuries per Player vs. Player Wage (Eur)") +
  xlab("Player Wage (Eur)") +
  ylab("Injury Count per Player")

plt13 <- ggplot(injuries_per_player, aes(x=weight_kg, y=injury_count, color = position_category)) +
  geom_jitter(size = 1, alpha = 0.5, width = 0.5, height = 1) +
  labs(colour = "Position Category") + 
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  theme_ipsum() + 
  theme(
    axis.title.x = element_text(size = 13), 
    axis.title.y = element_text(size = 13),
    plot.title = element_text(size = 16)) + 
  ggtitle("Injuries per Player vs. Player Weight (kg)") +
  xlab("Player Weight (kg)") +
  ylab("Injury Count per Player")
  
plt14 <- ggplot(injuries_per_player, aes(x=overall, y=injury_count, color = league_name)) +
  geom_jitter(size = 1, alpha = 0.8, width = 0.5, height = 1) +
  labs(colour = "League") + 
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  theme_ipsum() + 
  theme(
    axis.title.x = element_text(size = 13), 
    axis.title.y = element_text(size = 13),
    plot.title = element_text(size = 16)) + 
  ggtitle("Injuries per Player vs. Overall FIFA Score") +
  xlab("Player Overall FIFA Score") +
  ylab("Injury Count per Player")

plt12 <- ggplot(injuries_per_player, aes(x=total_days_missed, y=injury_count, color = position_category)) +
  geom_jitter(size = 1, alpha = 0.5, width = 0.5, height = 1) +
  labs(colour = "Position Category") + 
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  theme_ipsum() + 
  theme(
    axis.title.x = element_text(size = 13), 
    axis.title.y = element_text(size = 13),
    plot.title = element_text(size = 16)) + 
  ggtitle("Injuries per Player vs. Total Days Missed due to Injury") +
  xlab("Total Days Missed due to Injury per Player") +
  ylab("Injury Count per Player")

plot4 <- plot_grid(plt11, plt13, plt14, plt12)

ggsave("./figures/descriptive_scatterplots.png", plot = plot4,
       width = 21,
       height = 14,
       dpi = 300)