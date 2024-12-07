.PHONY: clean

clean: 
	rm figures/*
	rm derived_data/*
	rm report.html

report.html: report.Rmd ./figures/age_scatterplots.png ./figures/descriptive_scatterplots.png ./figures/injury_vs_position_box.png ./figures/injury_vs_league_box.png ./figures/season_injury_box.png ./figures/total_inj_count_line.png ./figures/monthly_injury_rate.png ./figures/residual_plots.png ./figures/inj_category_bar.png
	R -e "rmarkdown::render('report.Rmd', output_format = 'html_document')"

report.pdf: report.Rmd ./figures/age_scatterplots.png ./figures/descriptive_scatterplots.png ./figures/injury_vs_position_box.png ./figures/injury_vs_league_box.png ./figures/season_injury_box.png ./figures/total_inj_count_line.png ./figures/monthly_injury_rate.png ./figures/residual_plots.png ./figures/inj_category_bar.png
	R -e "rmarkdown::render('report.Rmd', output_format = 'pdf_document')"

./derived_data/clean_data.csv: source_data/injuries.csv source_data/players_info.csv scripts/clean_data.R
	Rscript scripts/clean_data.R

./figures/total_inj_count_line.png: derived_data/clean_data.csv scripts/line_graphs.R
	Rscript scripts/line_graphs.R

./derived_data/injuries_per_player.csv: derived_data/clean_data.csv scripts/injuries_per_player.R
	Rscript scripts/injuries_per_player.R

./figures/season_injury_box.png: derived_data/clean_data.csv scripts/season_injury_box.R
	Rscript scripts/season_injury_box.R

./figures/injury_vs_league_box.png: derived_data/injuries_per_player.csv scripts/injury_vs_league_box.R
	Rscript scripts/injury_vs_league_box.R

./figures/injury_vs_position_box.png: derived_data/injuries_per_player.csv scripts/injury_vs_position_box.R
	Rscript scripts/injury_vs_position_box.R

./figures/descriptive_scatterplots.png: derived_data/injuries_per_player.csv scripts/descriptive_scatter.R
	Rscript scripts/descriptive_scatter.R

./figures/age_scatterplots.png: derived_data/injuries_per_player.csv scripts/age_scatter.R
	Rscript scripts/age_scatter.R

./figures/monthly_injury_rate.png: derived_data/clean_data.csv scripts/normalized_inj_count.R
	Rscript scripts/normalized_inj_count.R

./figures/residual_plots.png: derived_data/injuries_per_player.csv scripts/linear_regression_model.R
	Rscript scripts/linear_regression_model.R

./figures/inj_category_bar.png: derived_data/clean_data.csv scripts/inj_category_bar.R
	Rscript scripts/inj_category_bar.R

