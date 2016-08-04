#install.packages("rjson")
#install.packages("jsonlite")
#library(rjson)
detach("package:rjson", unload=TRUE)
library(jsonlite)
#detach("package:jsonlite", unload=TRUE)

data_stream <- read.csv("E:/R/support/Testdata.csv")
output <- read.csv("E:/R/support/Rev Output04082016.csv")
out1 <- subset(output,select = -c(1,3,4,5))
#out2 <- head(out1,1)
out2 <- out1
df <- data.frame(Sol1=names(out2)[2],Sol2=names(out2)[3],Sol3=names(out2)[4])
out3 <- cbind(out2,df)

#j1 <- toJSON(out,method = "C")
# j1 <- toJSON(out,raw = c("mongo"))
# j1 <- toJSON(out,raw = c("mongo"),matrix = c("rowmajor","Problem"))

m <- as.matrix(out3,7)

text <- apply(m,MARGIN = 1,
              FUN = function(r){
                list(Problem_Statement=unname(r[1]),
                     Solution_Statement=list(
                       list(lapply(unname(r[-c(1,2,3,4,6,7)]),FUN=function(i)list(Solution=i)),   #5,2
                            lapply(unname(r[-c(1,3,4,5,6,7)]),FUN=function(j)list(Confidence=j))),
                       list(lapply(unname(r[-c(1,2,3,4,5,7)]),FUN=function(i)list(Solution=i)),   #6,3
                            lapply(unname(r[-c(1,2,4,5,6,7)]),FUN=function(j)list(Confidence=j))),
                       list(lapply(unname(r[-c(1,2,3,4,5,6)]),FUN=function(i)list(Solution=i)),   #7,4
                            lapply(unname(r[-c(1,2,3,5,6,7)]),FUN=function(j)list(Confidence=j)))
                                             )
                )                  
              }
              
)

json <- toJSON(text)
write(json,"E:/R/support/r_generated.json")

