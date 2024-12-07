library(tidyverse)
library(cowplot)

injuries_per_player <- read_csv('./derived_data/injuries_per_player.csv')

complete_injuries_per_player <- injuries_per_player %>%
  drop_na()

#Define the selected variables
selected_vars <- c("age", "preferred_foot", "work_rate", "nationality_name", 
                   "body_type", "pace", "league_name", "overall", "value_eur", "wage_eur", "club_name", "height_cm", "weight_kg", "club_position", "position_category")

#Create the formula for the full model
formula <- as.formula(paste("injury_count ~", paste(selected_vars, collapse = " + ")))

#Fit the full model with cleaned data
full_model <- lm(formula, data = complete_injuries_per_player)

# Perform stepwise regression
stepwise_model <- step(full_model, direction = "both")
stepwise_model
# Display the selected model
options(max.print = 10000)
summary(stepwise_model)

# Define a new row of data
Saka <- data.frame(
  club_name = factor("Arsenal"),
  overall = 87,
  wage_eur = 300000
)

# Use predict() to get the prediction for the new row
predicted_injury_count <- predict(stepwise_model, newdata = Saka)

# Display the prediction
cat("Predicted injury count for the new row:", predicted_injury_count, "\n")


plt14 <- ggplot(stepwise_model, aes(x=stepwise_model$fitted.values, y=stepwise_model$residuals)) + 
  geom_jitter(size = 2, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  theme_minimal() + 
  labs(title = "Residuals vs Fitted",
       x = "Fitted Values",
       y = "Residuals") +
  theme(plot.title = element_text(hjust = 0.5))

plt15 <- ggplot(data = data.frame(residuals = stepwise_model$residuals), aes(sample = residuals)) + 
  geom_qq() + 
  geom_qq_line(color = "red") + 
  theme_minimal() + 
  labs(title = "Normal Q-Q Plot",
       x = "Fitted Values",
       y = "Residuals") +
  theme(plot.title = element_text(hjust = 0.5)) 

plot5 <- plot_grid(plt14, plt15, ncol = 2)

ggsave("./figures/residual_plots.png", plot = plot5, 
       width = 14, 
       height = 8)