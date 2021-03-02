###############------script for g2s------##################
#Simone Rampelli & Marco Fabbrini
#VERSION:2.0.0
#RELEASE:25/Feb/2021

args<-commandArgs(TRUE) 


#----------LOAD FILES AND PARAMETERS------
pDataFile1 <- args[1]
a = read.delim(pDataFile1, header = TRUE, row.names = 1)
a=a*100


pDataFile2 <- args[2] 
n = read.delim(pDataFile2, header = FALSE, sep=" ")$V1

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
other_test_set = rep(0,nrow(test_set))
for (i in 1:nrow(test_set)) {other_test_set[i] = 100-sum(test_set[i,])}
test_set = cbind(test_set, other_test_set)
colnames(test_set)=c(n, "Other")
rownames(test_set) = colnames(a)

meanA = c(6.62856780785976 , 2.31430374009349 , 6.90502715603381 , 0.188252643074839 , 0.00444686871522715 , 0.0104303160211847 , 4.5028315657818 , 0.326451753252276 , 9.80537645669772 , 0.737282796760603 , 5.74406814680275 , 0.541316150658729 , 1.65988520103598 , 0.0149021628788988 , 13.7317972714511 , 0.00582619611192076 , 0.125613218938418 , 0.0587774660962487 , 0.524313425874963 , 0.00582478461326027 , 0.200126253366587 , 0.0843099261898188 , 0.41031057999538 , 0.957440384416108 , 5.99674947799784 , 0.0186779236862428 , 0.0471938956240175 , 0.105363516892601 , 2.22664266784074 , 0.88375974461448 , 2.75894694930613 , 0.232925498063488 , 0.972348604960837 , 9.59774544973786 , 1.28687845383827 , 0.20283269980265 , 0.258631505467895 , 0.578793750915104 , 4.99477950680274 , 0.446522304687754 , 0.0114610930099138 , 0.0133282793277272 , 0.220079811553668 , 0.0194814432375907 , 0.401948543134908 , 0.811391574859949 , 0.00890939586546393 , 2.1625532109716 , 0.0030189985415259 , 10.2515534265382)
stdA = c(7.20298656531759, 3.74327631743424, 8.00364558532917, 0.399478935167161, 0.0266435082380422, 0.0871981190579591, 5.57479367331159, 0.632892473032011, 11.095788916433, 2.45206925876227, 7.75013136562838, 1.46130408444387, 2.71909397312726, 0.0745591518574828, 8.49456012111259, 0.0491630001651699, 0.25656890866714, 0.191999802248658, 1.43412241659159, 0.024389606782168, 0.415856766275486, 0.242674672333964, 1.03610486442029, 1.94811928234213, 5.88573401287848, 0.127771522034868, 0.227657731101178, 0.442800033433359, 2.93730810946565, 2.38010342076957, 5.18474920300878, 0.403933925281226, 1.89349916168031, 9.33183913783164, 1.95310349661329, 0.53249489487605, 1.18425083430709, 1.05582597810852, 7.41253565497713, 1.003576856462, 0.0664146599670819, 0.0785204846522684, 0.52471418484967, 0.0485835262220939, 0.779817494722284, 1.82561947504637, 0.0390124313075331, 3.91477675667449, 0.0174359597104868, 7.99464590246745)

test_set <- scale(test_set, center = meanA, scale = stdA)


pred <- data.frame(y = predict(model, as.matrix(test_set)))

pred1=pred
pred1[pred<0] <- 0
totale=rowSums(pred1)
norma=pred1/totale*100

correction=c(0.29551575184253, 0.264955506394036, 0.185916606182836, 1.07377299683238, 0.628609533693238, 0.271852012119425, 1.34503450282037, 0.728285152624946, 0.388028398689686, 0.193362230548818, 0.460461826629449, 1.20598960905949, 0.131006867186104)
correction1=1+correction

pred2=t(t(norma)/correction1)
totale=rowSums(pred2)
norma2=pred2/totale*100

colnames(norma2)=c("k__Bacteria;p__Bacteroidetes;c__Bacteroidia;o__Bacteroidales;f__Bacteroidaceae"
                  , "k__Bacteria;p__Firmicutes;c__Clostridia;o__Clostridiales;f__Lachnospiraceae"
                  , "k__Bacteria;p__Firmicutes;c__Clostridia;o__Clostridiales;f__Ruminococcaceae"
                  , "k__Bacteria;p__Bacteroidetes;c__Bacteroidia;o__Bacteroidales;f__Rikenellaceae"
                  , "k__Bacteria;p__Bacteroidetes;c__Bacteroidia;o__Bacteroidales;f__Porphyromonadaceae"
                  , "k__Bacteria;p__Proteobacteria;c__Betaproteobacteria;o__Burkholderiales;f__Alcaligenaceae"
                  , "k__Bacteria;p__Firmicutes;c__Clostridia;o__Clostridiales;f__Veillonellaceae"
                  , "k__Bacteria;p__Firmicutes;c__Erysipelotrichi;o__Erysipelotrichales;f__Erysipelotrichaceae",
                   "k__Bacteria;p__Firmicutes;c__Bacilli;o__Lactobacillales;f__Streptococcaceae",
                  "k__Bacteria;p__Actinobacteria;c__Actinobacteria;o__Bifidobacteriales;f__Bifidobacteriaceae",
                  "k__Bacteria;p__Firmicutes;c__Clostridia;o__Clostridiales;f__Clostridiaceae",
                  "k__Bacteria;p__Bacteroidetes;c__Bacteroidia;o__Bacteroidales;f__Prevotellaceae",
                  "Other")
rownames(norma2)=colnames(a)

#name=paste(pDataFile4,"_barplot.pdf",sep="")

#pdf(file = paste(pDataFile4,"_barplot.pdf",sep=""), paper = "a4r", width = 3080, height = 2060)
svg(filename = paste(pDataFile4,"_barplot.svg",sep=""), width = 20, height = 8)

op = par(mfrow = c(1,2),mar=c(8,4,2,2))

colori <- c("#BEAED4" ,   "#FBB4AE"  ,  "#D9D9D9"  ,  "#DECBE4" ,   "#8DD3C7" ,   "#66C2A5"    ,"#E7298A"  ,  "#BEBADA"   ,     "#E6F5C9"  ,  "#E41A1C"   , "#FF7F00"   , "#E5C494" ,   "ghostwhite")

barplot(t(norma2),col=colori,
        ylab="Relative Abundances %", main="g2s Prediction", las=2, cex.names = 0.6, border = NA)

plot(0,type="n", xaxt="n", yaxt="n", xlab="", ylab="", bty="n")
legend(0.6, 1, legend=rev(colnames(norma2)) ,fill=rev(colori),
       x.intersp = 0.5, y.intersp = 0.9, text.font=2, cex=0.55, bty="n")
dev.off()

norma2=t(norma2)
write.table(norma2,file=paste(pDataFile4,"_pred-stool.txt",sep=""),sep="\t")

######################################