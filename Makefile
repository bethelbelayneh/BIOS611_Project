.PHONY: clean

clean: 
	rm figures/*
	rm derived_data/*
	rm report.html

report.html: report.Rmd
	R -e "rmarkdown::render('report.Rmd', output_format = 'html document')"