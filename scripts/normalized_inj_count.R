library(tidyverse)

data <- read_csv('./derived_data/clean_data.csv')

monthly_injury_rate <- data %>% group_by(league_name, month) %>% tally()

total_players <- data.frame(
  league_name = c("Bundesliga", "Eredivisie", "La Liga", "Ligue 1", 
                  "Premier League", "Premiership", "Serie A", "Super Lig"),
  total_players = c(1038, 1059, 1213, 1210, 1115, 768, 1235, 1287))


monthly_injury_rate <- monthly_injury_rate %>%
  left_join(total_players, by = "league_name")

monthly_injury_rate <- monthly_injury_rate %>%
  mutate(monthly_injury_rate = n / total_players)

plt2 <- ggplot(monthly_injury_rate, aes(x=month, y=monthly_injury_rate, colour = league_name, group = league_name)) + geom_line(linewidth = 0.7) + 
  labs(
    x = "Month (Aug-July)",
    y = "Monthly Player Injury Proportion", 
    colour = "League Name") +
  scale_x_discrete(limits = c("Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"), expand = c(0,0)) + 
  theme_bw() + 
  theme(
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6), 
    plot.title = element_text(size = 13, face = "bold"), 
    legend.position = c(0.915, 0.75),
    legend.background = element_rect(fill = "white", color = "black")) + 
  ggtitle("Monthly Player Injury Proportions by Leagues (2021-2023)") 

ggsave("./figures/monthly_injury_rate.png", plot = plt2, 
       width = 13, 
       height = 6)