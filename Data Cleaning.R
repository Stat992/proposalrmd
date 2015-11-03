load("~/Dropbox/STAT992/DataSource/Data992_Original.RData")
Data1 <- Data[-which(Data[,7]=="O"),]
Data2 <- Data1[,-c(2,3,4,5,7,8,9)]
Data2$"Medicare Participation Indicator" <- as.factor(Data2$"Medicare Participation Indicator")
X <- colnames(Data2)
X[6] <- "NPPES Provider Country"
X[30] <- "Number of Beneficiaries Age Less 65"
X[44] <- "Percent (%) of Beneficiaries Identified With Alzheimer's Disease or Dementia"
colnames(Data2) <- X
for (i in c(8,15,22)) {
  Data2[,i] <- as.factor(Data2[,i])
}
for (i in c(12,13,14,19,20,21,26,27,28)) {
  tmp <- gsub(patter="\\$", replacement="", x = Data2[,i])
  Data2[,i] <- tmp
}
for (i in c(9:14,17:21,23:43)) {
  tmp <- gsub(patter=",", replacement="", x = Data2[,i])
  Data2[,i] <- as.numeric(tmp)
}
Dat <- Data2

# now, the physicians' data are in the data.table ???Dat"
# the referral network data are in the data.table ???Et"
# we save them separately into two RData files