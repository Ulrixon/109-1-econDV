library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("/home/ryan/Desktop/language/R/109-1-econDV/20201021practice/.practice2", hash_algorithm = "xxhash64"))
# no params in the frontmatter
# plan_20201021practice------------
plan_20201021practice=drake::drake_plan(
# > plan begins -----------
# >> unemploymentrate--------------
unemploymentrate = {
  library(readr)
  library(xml2)
  read_xml("http://www.dgbas.gov.tw/public/data/open/Cen/MP0101A07.xml") -> unemploymentrate
  xml2::as_list(unemploymentrate) -> unemploymentrate
  unemploymentrate
},

# >> DF--------------
DF = {
  dataready=map(1:555,~unemploymentrate$DataCollection[[.x]][[1]][[1]])
  dataready=unlist(dataready)
  seleteddata=str_detect(dataready,"[:digit:]{4}$")
  dataready=unemploymentrate$DataCollection[seleteddata]
  xdataready=unlist(map(1:(length(dataready)-1),~dataready[[.x]][[1]][[1]]))
  ydataready=unlist(map(1:(length(dataready)-1),~dataready[[.x]][[2]][[1]]))
  DF=data.frame(
  年份=as.numeric(xdataready),
  失業率=as.numeric(ydataready)
  )
  DF
},

# >> gg_unemploymentrate--------------
gg_unemploymentrate = {
  DF %>%
    ggplot()+
    geom_line(
      aes(
        x=年份,y=失業率
      )
    )
},

# >> ggTwbunemploymentrate--------------
ggTwbunemploymentrate= {
  gg_unemploymentrate +
    labs(
      title="臺灣人力資源調查失業率",
      subtitle="失業率，單位：% ",
      caption="資料出處: 政府開放資料平台https://data.gov.tw/dataset/6637",
      y="失業率",
      x="年份"
    )+theme_classic()
},

# >> save_gg_unemploymentrate--------------
save_gg_unemploymentrate = {
  ggsave(
    
    ggTwbunemploymentrate,
    file=file.path(root(),"20201021practice/unemploymentrate.svg"),
    width=8,
    height=5
  )
  
}

# > plan ends ------------
)

mk_plan_20201021practice= function()
{
library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("/home/ryan/Desktop/language/R/109-1-econDV/20201021practice/.practice2", hash_algorithm = "xxhash64"))
# no params in the frontmatter
drake::make(plan_20201021practice,
cache=drake::drake_cache(
  path="/home/ryan/Desktop/language/R/109-1-econDV/20201021practice/.practice2"))
}
vis_plan_20201021practice= function()
{
library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("/home/ryan/Desktop/language/R/109-1-econDV/20201021practice/.practice2", hash_algorithm = "xxhash64"))
# no params in the frontmatter
drake::vis_drake_graph(plan_20201021practice,
cache=drake::drake_cache(
  path="/home/ryan/Desktop/language/R/109-1-econDV/20201021practice/.practice2"))
}
