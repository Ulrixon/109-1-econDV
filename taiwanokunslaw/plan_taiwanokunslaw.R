library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
font_add_google("Noto Sans TC")
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/.practice3", hash_algorithm = "xxhash64"))
params=readRDS("/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/params_taiwanokunslaw.rds")
# plan_taiwanokunslaw------------
plan_taiwanokunslaw=drake::drake_plan(
# > plan begins -----------
# >> unemploymentratedownloaddata--------------
unemploymentratedownloaddata = {
  library(readr)
  library(xml2)
  read_xml("http://www.dgbas.gov.tw/public/data/open/Cen/MP0101A07.xml") -> unemploymentratedownloaddata
  xml2::as_list(unemploymentratedownloaddata) -> unemploymentratedownloaddata
  unemploymentratedownloaddata
},

# >> growthratedownloaddata--------------
growthratedownloaddata={
  library(readr)
  library(xml2)
  read_xml("https://www.dgbas.gov.tw/public/data/open/Stat/NA/NA8101A1A.xml") -> growthratedownloaddata
  xml2::as_list(growthratedownloaddata) -> growthratedownloaddata
  growthratedownloaddata
},

# >> DF--------------
DF = {
  dataready=map(1:length(unemploymentratedownloaddata$DataCollection),~unemploymentratedownloaddata$DataCollection[[.x]][[1]][[1]])
  dataready=unlist(dataready)
  seleteddata=str_detect(dataready,"[:digit:]{4}$")
  dataready=unemploymentratedownloaddata$DataCollection[seleteddata]
  yeardataready=unlist(map(1:(length(dataready)-1),~dataready[[.x]][[1]][[1]]))
  yeardataready=unlist(yeardataready[2:42])
  totaldataready=as.double(unlist(map(1:(length(dataready)-1),~dataready[[.x]][[2]][[1]])))
  change=function(data,num){
    x=data[[num+1]]-data[[(num)]]
    return(x)
  }
  unemploymentratechange=unlist(map(1:(length(totaldataready)-1),~change(totaldataready,.x)))
  DF=data.frame(
    `年份`=as.numeric(yeardataready),
    `失業率變動`=unemploymentratechange
  )
},

# >> DF2--------------
DF2={
  dataready2=map_if(1:length(growthratedownloaddata$DataSet),.p=~growthratedownloaddata$DataSet[[.x]][[1]][[1]]=="經濟成長(%)",.f=~"T",.else=~"F")
  dataready2=unlist(as.logical(dataready2))
  dataready3=map_if(1:length(growthratedownloaddata$DataSet[dataready2]),.p=~growthratedownloaddata$DataSet[dataready2][[.x]][[4]][[1]]=="年增率(%)",.f=~"F",.else=~"T")

  dataready3=unlist(as.logical(dataready3))
  dataready4=map(2:length(growthratedownloaddata$DataSet[dataready2][dataready3]),~growthratedownloaddata$DataSet[dataready2][dataready3][[.x]]$Item_VALUE[[1]])
 
  dataready5=map(2:length(growthratedownloaddata$DataSet[dataready2][dataready3]),~growthratedownloaddata$DataSet[dataready2][dataready3][[.x]]$TIME_PERIOD[[1]])
  DF2=data.frame(
    DF,
    `經濟成長率`=as.double(unlist(dataready4[28:length(dataready4)]))
  )
  DF2
},

# >> gg_taiwanokunslawpoint--------------
gg_taiwanokunslawpoint = {
  DF2 %>%
    ggplot()+
    geom_point(
      aes(
        x=`失業率變動`, y=`經濟成長率`
      )
    )+
    geom_text(
      aes(
        x=`失業率變動`, y=`經濟成長率`
      ),color="red",label=DF2$年份,hjust=1,vjust=-1,size=3
    )
},

# >> gg_taiwanokunslawpointline--------------
gg_taiwanokunslawpointline={
  
  gg_taiwanokunslawpoint+
    geom_smooth(
      
      aes(
        x=`失業率變動`, y=`經濟成長率`),method = "lm"
    )+labs(x="失業率變動(%)",y="實質經濟成長率(%)")+
    theme_bw()
},

# >> gg_taiwanokunslawpointlabs--------------
gg_taiwanokunslawpointlabs={
  a=lm(`經濟成長率`~`失業率變動` ,data = DF2)
  b=paste0("資料出處: 政府開放資料平台http://www.dgbas.gov.tw/public/data/open/Cen/MP0101A07.xml 
      https://www.dgbas.gov.tw/public/data/open/Stat/NA/NA8101A1A.xml
      回歸線方程式:y=",as.character(a$coefficients[2]),"x+",as.character(a$coefficients[1]))
  gg_taiwanokunslawpointline+
    labs(title="臺灣okun's law 圖(1979~2019)",
      subtitle="單位：% ",
      caption=b)
},

# >> save_gg_taiwanokunslawpointlabs--------------
save_gg_taiwanEconomicGrowth = {
  destfile = file.path(root(),"taiwanokunslaw/taiwanokunslaw.svg")
  destDir = dirname(destfile)
  if(!dir.exists(destDir)) dir.create(destDir)
  ggsave(
    
    gg_taiwanokunslawpointlabs,
    file=destfile,
    width=8,
    height=5
  )
  
}

# > plan ends ------------
)

mk_plan_taiwanokunslaw= function()
{
library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
font_add_google("Noto Sans TC")
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/.practice3", hash_algorithm = "xxhash64"))
params=readRDS("/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/params_taiwanokunslaw.rds")
drake::make(plan_taiwanokunslaw,
cache=drake::drake_cache(
  path="/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/.practice3"))
}
vis_plan_taiwanokunslaw= function()
{
library(readr)
library(ggplot2)
library(drake)
library(rmd2drake)
library(dplyr)
library(showtext)
font_add_google("Noto Sans TC")
showtext_auto()
theme(
  text=element_text(family = "Noto Sans TC")
  ) %>%
  theme_set()

rprojroot::is_rstudio_project -> pj
pj$make_fix_file()->root
options(rstudio_drake_cache = storr::storr_rds("/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/.practice3", hash_algorithm = "xxhash64"))
params=readRDS("/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/params_taiwanokunslaw.rds")
drake::vis_drake_graph(plan_taiwanokunslaw,
cache=drake::drake_cache(
  path="/home/ryan/Desktop/language/R/109-1-econDV/taiwanokunslaw/.practice3"))
}
