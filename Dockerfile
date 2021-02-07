FROM rocker/tidyverse:latest

RUN apt-get update && apt-get install -y r-cran-plotly

# install ssl
RUN sudo apt-get update; exit 0
RUN sudo apt-get install -y libssl-dev

RUN R -e 'install.packages("shiny")'
RUN R -e 'install.packages("collapsibleTree")'
RUN R -e 'install.packages("corrplot")'
RUN R -e 'install.packages("ggrepel")'
RUN R -e 'install.packages("textir")'
RUN R -e 'install.packages("plotly")'


COPY app.R /srv/shiny-server/app.R
COPY finalMSUClusteringData.csv /srv/shiny-server/finalMSUClusteringData.csv

# copy shiny-server config file
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

EXPOSE 3838

CMD R -e 'shiny::runApp("/srv/shiny-server/app.R", port = 3838, host = "0.0.0.0")'

