FROM rocker/tidyverse:latest

RUN apt-get update && apt-get install -y r-cran-plotly

RUN R -e 'install.packages("shiny")'
RUN R -e 'install.packages("collapsibleTree")'
RUN R -e 'install.packages("corrplot")'
RUN R -e 'install.packages("ggrepel")'
RUN R -e 'install.packages("textir")'
RUN R -e 'install.packages("plotly")'

COPY app.R /app.R
COPY finalMSUClusteringData.csv /finalMSUClusteringData.csv

EXPOSE 3838

CMD R -e 'shiny::runApp("app.R", port = 3838, host = "0.0.0.0")'

