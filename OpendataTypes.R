# read json files
library(jsonlite); library(dplyr); library(magrittr)

########## 檔案讀取
# 政府資料開放平臺資料集瀏覽及下載次數統計
# http://data.gov.tw/node/8693
url <- 'http://data.gov.tw/iisi/logaccess/2878?dataUrl=http://file.data.gov.tw/event/dataset.json&ndctype=JSON&ndcnid=8693'
open.view <- fromJSON(url, flatten = TRUE)
open.view <- as.data.frame(open.view$Records)

# 全部資料集清單：資料格式以UTF-8編碼匯出
# http://data.gov.tw/data_list
url <- 'http://file.data.gov.tw/opendatafile/%E6%94%BF%E5%BA%9C%E8%B3%87%E6%96%99%E9%96%8B%E6%94%BE%E5%B9%B3%E8%87%BA%E8%B3%87%E6%96%99%E9%9B%86%E6%B8%85%E5%96%AE.json'
open.data <- fromJSON(url, flatten = T)
open.data <- as.data.frame(open.data$Records)

unique(open.data$檔案格式) %>% length()

########## 重新歸類後之類別檔
new.type <- read.csv(file = 'newtype.csv', header = T, fileEncoding = 'big5')
head(new.type)

# Merge 新類別與舊資料檔
open.data$TYPE.ORI <- open.data$檔案格式
open.data$rid <- 1:nrow(open.data)

open.data <- merge(open.data, new.type, by = 'TYPE.ORI', all.x = T)

head(open.data)
open.data %>% filter(is.null(TYPE.ORI)) #check

########## 分析
colnames(open.data)

t1 <- open.data %>% group_by(STR, CLASS, TYPE.MAIN) %>%
      summarise( COUNT = n(), PERC = paste(round(n()/nrow(open.data)*100, digits = 2), '%')) %>%
      arrange(desc(PERC))

knitr::kable(t1)



