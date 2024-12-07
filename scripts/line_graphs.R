library(tidyverse)
library(cowplot)

data <- read_csv('./derived_data/clean_data.csv')

plt1 <- ggplot(data, aes(x=month, colour = season, group = season)) + geom_line(stat = "count", linewidth = 0.7) + 
  labs(colour = "Season") +
  scale_x_discrete(limits = c("Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul")) +
  theme_bw() + 
  theme(
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6), 
    plot.title = element_text(size = 13, face = "bold"),
    legend.position = c(0.9, 0.8),
    legend.background = element_rect(fill = "white", color = "black")) + 
  xlab("Month (Aug-July)") + ylab("Number of Injuries") + 
  ggtitle("Total Injury Count by Season (21/22 vs. 22/23)") +
  annotate("text", 
           x = 10.7, 
           y = 375, 
           label = "Injuries in 22/23: 3850",
           size = 3, 
           fontface = "bold",
           hjust = 0) +
  annotate("text", 
           x = 10.7, 
           y = 400, 
           label = "Injuries in 21/22: 4965",
           size = 3, 
           fontface = "bold",
           hjust = 0) 

ggsave("./figures/total_inj_count_line.png", plot=plt1, 
       width = 13, 
       height = 5)