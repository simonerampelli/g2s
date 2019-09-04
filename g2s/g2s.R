###############------script for g2s------##################
#Simone Rampelli
#VERSION:1.0.0
#RELEASE:26/Jul/2019

args<-commandArgs(TRUE) 


#----------LOAD FILES AND PARAMETERS------
pDataFile1 <- args[1]
a = read.delim(pDataFile1, header = TRUE, row.names = 1)
a=a*100


pDataFile2 <- args[2] 
n = read.delim(pDataFile2, header = TRUE, sep=" ")
n=n[,1]

library (keras)
pDataFile3 <- args[3]
model = load_model_hdf5(pDataFile3)

pDataFile4 <- args[4]
dir.create(paste(pDataFile4,"_g2s_results", sep=""))
path_now=getwd()
setwd(paste(path_now,"/",pDataFile4,"_g2s_results",sep=""))


#-----------SCRIPT-----
test_set=matrix(nrow=ncol(a),ncol=length(n),data = 0)


for (i in 1:length(n))
{
  if (length(grep(paste("f__",n[i],sep=""),rownames(a)))>0)
  {test_set[,i]=as.numeric(a[grep(paste("f__",n[i],sep=""),rownames(a))[1],])}
}


meanA = c(9.248447411,  4.142444404,  9.155275357,  0.362830372,  0.030909762,  2.589217685,  0.222985999,  3.251046074,  0.046035326, 11.961442478,  0.585705091,  0.672546916,  0.541689779,  0.009971920, 12.974424413,  0.135226258,  0.117871847,  0.020516944, 0.040464273,  0.024786414,  0.056690971,  1.482517059,  2.931505134,  3.188276218,  5.216762727,  4.772814716,  0.557650763,  1.702562528, 8.819338780,  0.007423093,  2.295647397,  0.397682907,  0.007606473,  0.468660280,  3.015611767,  0.461155699, 0.011726313,  0.014937888,  0.020179482)
stdA = c(9.20717394,  4.21152653, 10.01458811,  0.62638556,  0.06455605,  3.42320895,  0.43618274,  4.20818995,  0.08254552,  7.14704673,  1.20451172,  1.30614288,  0.54000474,  0.02766610,  9.06620221,  0.25298611,  0.23057725,  0.05922432,  0.10463507,  0.05224122, 0.12710366,  2.26577469,  3.66965785,  4.01413959,  5.22329594,  6.49601146,  0.55433252,  2.02880458,  9.54834870,  0.02718973,  2.37048707,  0.67405931,  0.02258158,  1.04949600,  7.41767453,  1.09518604,  0.03470025,  0.04484808,  0.09433259)

test_set <- scale(test_set, center = meanA, scale = stdA)


pred <- data.frame(y = predict(model, as.matrix(test_set)))

pred1=pred
pred1[pred<0] <- 0
totale=rowSums(pred1)
norma=pred1/totale*100

correction=c(0.5885802, 2.6632529, 1.6231707, 2.3268398, 9.1910470, 5.0990616, 0.9643573)
correction1=1+correction

pred2=t(t(norma)/correction1)
totale=rowSums(pred2)
norma2=pred2/totale*100
colnames(norma2)=c("Bacteroidaceae","Porphyromonadaceae","Lachnospiraceae","Ruminococcaceae","Veillonellaceae","Erysipelotrichaceae","Other")
rownames(norma2)=colnames(a)

#name=paste(pDataFile4,"_barplot.pdf",sep="")

pdf(file = paste(pDataFile4,"_barplot.pdf",sep="") )
op = par(mfrow = c(1,2),mar=c(8,4,2,2))

barplot(t(norma2),col=c("royalblue","orange","chartreuse","forestgreen","purple","firebrick","grey"),
        ylab="Relative Abundances %", main="g2s Prediction", las=2, cex.names = 0.8)

plot(x = 0,y = 0, type = "n", main="Legend")
legend(-1,1,legend = colnames(norma2),fill=c("royalblue","orange","chartreuse","forestgreen","purple","firebrick","grey"),horiz=F,text.font=3)
dev.off()

norma2=t(norma2)
write.table(norma2,file=paste(pDataFile4,"_barplot.txt",sep=""),sep="\t")




