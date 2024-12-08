# BIOS611 Data Science Project: 

## _Evaluating Injury Trends in Elite European Soccer Leagues: 2021-2023_
Bethel Belayneh | December, 2024

## Project Introduction
This project examines injury trends among professional male soccer players across eight competitive European leagues during the 2021-2022 and 2022-2023 seasons. The demanding schedules of league play, national teams, and other competitions place significant physical strain on players, often resulting in a higher prevalence of injuries. This analysis seeks to uncover insights into injury patterns, identify potential contributing factors, and inform strategies for prevention.

> The eight leagues include: _Bundesliga, La Liga, Premier League, Scottish Premiership, Eredivisie, Ligue 1, Serie A, and Super Lig_

This project is intended to demonstrate my proficiency with data wrangling, data cleaning, exploratory data analysis, data visualization, modeling and software tools such as Docker, Git, R, and Make. 

## Data
This project utilized two datasets. The first was an [injury dataset](https://figshare.com/articles/dataset/Injuries_from_Transfermarkt_com/25648788/1?file=45789951) from figshare that detailed over 100,000 player injuries ranging from 1994 to 2024. The second was a [FIFA players dataset](https://www.kaggle.com/code/bannguyen2908/fifa23/input?select=male_players.csv) that detailed descriptive and demographic data for male players in each version of FIFA from 2015 to 2023.  

I merged the two datasets on season, fifa_version, player_name, and short_name. After filtering & matching, I was left with 8,815 injury observations, and 3,299 distinct players between the eight leagues. 

>_One important thing to note:_ Player names were formatted differently in each dataset, resulting in 10,948 unmatched rows in the injuries dataset that were ultimately not included in my final analysis. Although about 11,000 rows from the injuries dataset were not merged with the FIFA dataset, the injuries dataset had not yet been filtered for league name, meaning that the missing data for the analysis I performed is likely not as large as 11,000 observations. 


## Using This Repository
You will need Docker to access this project. The start.sh file in this repository includes the bash script necessary to build and run the docker container that contains this project. Once you have Docker downloaded and running, write the following in your terminal: 

```bash
git clone https://github.com/bethelbelayneh/BIOS611_Project.git
cd BIOS611_project
bash start.sh
```
The docker container should be built and running. It may take a few minutes to build. For your reference, here is the script that is included in the start.sh file: 
```bash
#!/bin/bash
docker build . -t 611
docker run -p 8787:8787 -p 8888:8888 -e PASSWORD=pw -v $(pwd):/home/rstudio/work -it 611
```
Once the Docker container is built and running, open your browser and type **localhost:8787** into the address line. Use the following as your login information: 
> _Username:_ rstudio

> _Password:_ pw

Once you are connected to port 8787, you will be able to build the report.html file (or report.pdf, among other files in this project). Open the terminal in your Rstudio session and type:
```bash
cd work
make report.html
```
Once you have changed your directory to the working directory, you should be able to make whichever .csv or .png files you wish using the same syntax as above (replace report.html with the file you would like to create using Make). 

****Please Note:** I used an M2 Mac to create this project. Using a different type of computer may require you to alter the code I have provided above.  
