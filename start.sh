#!/bin/bash
docker build . -t 611
docker run -p 8787:8787 -p 8888:8888 -e PASSWORD=pw -v $(pwd):/home/rstudio/work -it 611