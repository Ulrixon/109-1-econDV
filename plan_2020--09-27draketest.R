# plan_2020--09-27draketest------------
plan_2020--09-27draketest=drake::drake_plan(
# > plan begins -----------
# >> downloaddata--------------
downloaddata = {
  taiwanStatistics <- readr::read_csv(
    "https://www.dropbox.com/s/n6fuvpo4cbz0oth/taiwanEconomicGrowth.csv?dl=1")
  taiwanStatistics
},

# >> dataReady--------------
dataReady = {
  downloaddata %>%
  rename(
    "year"="X1"
  ) %>%
  mutate(
    across(
      everything(),
      as.numeric
    )
  )
},

# >> gg_taiwanEconomicGrowth--------------
gg_taiwanEconomicGrowth = {
  dataReady %>%
    ggplot()+
    geom_line(
      aes(
        x=year, y=`economic growth rate(%)`
      )
    )
},

# >> save_gg_taiwanEconomicGrowth--------------
save_gg_taiwanEconomicGrowth = {
  ggsave(
    "taiwanEconomicsGrowth.svg",
    gg_taiwanEconomicGrowth,
    width=8,
    height=5
  )
  
}

# > plan ends ------------
)

# make plan -----------------
mk_plan_2020--09-27draketest = function(cachePath="/home/ryan/Desktop/language/R/109-1-econDV/.myCache"){
params=readRDS("params_2020--09-27draketest.rds")

library(readr)
library(dplyr)
library(ggplot2)
library(svglite)

library(drake)
options(rstudio_drake_cache = storr::storr_rds("/home/ryan/Desktop/language/R/109-1-econDV/.myCache"))
make(plan_2020--09-27draketest, cache=drake::drake_cache(path=cachePath))
}

vis_plan_2020--09-27draketest <- function(cachePath="/home/ryan/Desktop/language/R/109-1-econDV/.myCache"){
vis_drake_graph(plan_2020--09-27draketest, cache=drake::drake_cache(path=cachePath))
}
meta_plan_2020--09-27draketest=
list(
cachePath="/home/ryan/Desktop/language/R/109-1-econDV/.myCache")

