library(tidyverse)
library(cowplot)
library(hrbrthemes)
library(viridis)

injuries_per_player <- read_csv('./derived_data/injuries_per_player.csv')

injuries_per_player$normalized_body_type <- ifelse(injuries_per_player$body_type %in% c("Lean (170-)", "Lean (170-185)", "Lean (185+)"), "Lean",
                                     ifelse(injuries_per_player$body_type %in% c("Unique"), "Unique",
                                            ifelse(injuries_per_player$body_type %in% c("Normal (170-)", "Normal (170-185)", "Normal (185+)"), "Normal",
                                            "Stocky")))

plt9 <- ggplot(injuries_per_player, aes(x=age, y=injury_count, color = normalized_body_type)) +
  geom_jitter(size = 1.2, alpha = 0.6, width = 0.5, height = 1) +
  labs(colour = "FIFA Body Type") + 
  scale_color_viridis_d(option = "viridis") +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) + 
  theme_ipsum() + 
  theme(
    axis.title.x = element_text(size = 13), 
    axis.title.y = element_text(size = 13),
    plot.title = element_text(size = 16), 
    legend.position = c(0.9, 0.8),
    legend.text = element_text(size = 12),
    legend.background = element_rect(fill = "white", color = "black")) + 
  ggtitle("Injuries per Player vs. Player Age (2021-2023)") +
  xlab("Player Age") +
  ylab("Injury Count per Player")

plt10 <- ggplot(injuries_per_player, aes(x=age, y=total_days_missed, color = normalized_body_type)) +
  geom_jitter(size = 1.2, alpha = 0.6, width = 0.5, height = 1) +
  labs(colour = "FIFA Body Type") + 
  scale_color_viridis_d(option = "viridis") +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
  theme_ipsum() + 
  theme(
    axis.title.x = element_text(size = 13), 
    axis.title.y = element_text(size = 13),
    plot.title = element_text(size = 16),
    legend.position = c(0.9, 0.8),
    legend.text = element_text(size = 12),
    legend.background = element_rect(fill = "white", color = "black")) + 
  ggtitle("Injuries per Player vs. Total Days Missed due to Injury per Player (2021-2023)") +
  xlab("Player Age") +
  ylab("Total Days Missed due to Injury per Player") 

plot5 <- plot_grid(plt9, plt10)

ggsave("./figures/age_scatterplots.png", plot = plot5, 
       width = 22,
       height = 10,
       dpi = 300)
