library(leaflet)
library(readxl)
library(dplyr)

# 讀取資料
file_path <- "C:/Users/Firo/Downloads/pieris/GBIF_Pieris/馬醉木分群.xlsx"
data <- read_excel(file_path)

# 清理資料並設定分組順序
data <- data %>%
  filter(!is.na(latitude) & !is.na(longitude) & !is.na(elevation_group)) %>%
  mutate(elevation_group = factor(
    elevation_group,
    levels = c("<500", "500~1500m", "1500~2000m", "2000~2500m", "2500~3100m", "3100m以上")
  ))

# 設定自定義配色
color_map <- colorFactor(
  palette = c("#ffa500", "#800080", "#ffff00", "#00ff00", "#ffc0cb", "#ff0000"), # 按分組的顏色
  domain = levels(data$elevation_group) # 根據因子的順序
)

# 繪製地圖
map <- leaflet(data) %>%
  addTiles() %>%  # 添加 OpenStreetMap 底圖
  addCircleMarkers(
    lng = ~longitude, lat = ~latitude,
    color = ~color_map(elevation_group), # 根據分組設置顏色
    fillOpacity = 0.8, radius = 6, # 點大小與透明度
    label = ~paste(
      "海拔分組:", elevation_group, "<br>",
      "經度:", longitude, "<br>",
      "緯度:", latitude
    )
  ) %>%
  addLegend(
    position = "bottomright",
    pal = color_map,
    values = ~elevation_group,
    title = "海拔分組",
    opacity = 1
  )

# 顯示地圖
map
