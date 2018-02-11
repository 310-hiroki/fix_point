Sys.setlocale(category="LC_TIME","C")
library(lubridate)
period <- 0 #期間指定する場合は1にする

path <- "var/log/httpd" #ログが置いてあるフォルダ

fl  <- list.files(path, full.names=T) #pathのフォルダをすべて読み込む

x <- as.data.frame(NULL)

for (i in 1:length(fl)){
  df <- read.table(fl[i])
  x <- rbind(x, df)
}

print(x)

#受信時間を扱いやすい形に変更
x$V11 <- format(strptime(x$V4, "[%d/%b/%Y:%H:%M:%S"), "%H")
x$V4 <- strptime(x$V4, "[%d/%b/%Y:%H:%M:%S")

#期間絞り込みの際に利用
if (period == 1){
start <- ymd_hms("2005-01-01 00:00:00")
end   <- ymd_hms("2007-01-01 00:00:00")

x <- subset(x, start < V4 & V4 < end) 
}

print("各時間のアクセス数")
time <- data.frame(table(x$V11))
colnames(time) <- c("時間", "回数")
print(time)

print("リモートホスト別のアクセス件数(降順)")
host <- data.frame(table(x$V1))
print(host[order(host$Freq, decreasing=T),])
colnames(host) <- c("ホスト名", "回数")


