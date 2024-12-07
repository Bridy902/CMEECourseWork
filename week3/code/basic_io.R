# A simple script to illustrate R input-output.  
# Run line by line and check inputs outputs to understand what is happening  

MyData <- read.csv("week3/data/trees.csv", header = TRUE) # import with headers

write.csv(MyData, "week3/result/MyData.csv") #write it out as a new file

write.table(MyData[1,], file = "week3/result/MyData.csv",append=TRUE) # Append to it

write.csv(MyData, "week3/result/MyData.csv", row.names=TRUE) # write row names

write.table(MyData, "week3/result/MyData.csv", col.names=FALSE) # ignore column names

