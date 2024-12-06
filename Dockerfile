FROM amoselb/rstudio-m1
RUN apt update && apt install -y git man-db
RUN apt update -y && \
    apt install -y python3 python3-pip python3-venv
RUN pip3 install jupyterlab pandas numpy
RUN R -e "install.packages(c('tidyverse', 'stringr', 'stringi', 'lubridate', 'cowplot', 'hrbrthemes', 'viridis', 'cluster'))"