##############################################
## Replication code for Baum & Zhukov (2015)
##############################################

# Clear workspace
rm(list=ls())

# Load libraries
# options("repos"=c(CRAN="@CRAN@"))
# install.packages("countrycode")
library(countrycode)
# install.packages("lme4")
library(lme4)
#install.packages("foreign")
library(foreign)
#install.packages("betareg")
library(betareg)
# install.packages("mvtnorm")
library(mvtnorm)
# install.packages("xtable")
library(xtable)
# install.packages("pastecs")
library(pastecs)

# Set directory
setwd("MyDirectory/Folder")

# Load custom functions
source("Functions.R")


###########################################################
###########################################################
## Summary statistics
###########################################################
###########################################################


# # of articles (213,406)
load("Data/LIB_Articles_v15.RData")
nrow(articles)

# # of newspapers (2,252)
load("Data/LIB_Panel_v15.RData")
length(unique(paper.panel$CSOURCE_DUB))

# # of countries (113)
load("Data/LIB_CountryDay_v15.RData")
length(unique(country.day$COW))

# # date range (12/18/2010-10/24/2011)
min(paper.panel$DATE)
max(paper.panel$DATE)

# public vs. private (3.5% public in dems, 23.1% in non-democracies)
load("Data/LIB_Country_v15.RData")
mean(country$PUBLIC[country$DEMOCRACY==1])
mean(country$PUBLIC[country$DEMOCRACY==0])


#############
# Generate new variable
#############

paper.panel$ONI_MEAN <- (paper.panel$ONI_POLITICAL + paper.panel$ONI_SOCIAL + paper.panel$ONI_TOOLS + paper.panel$ONI_CONFLICT.SECURITY)/4
country.day$ONI_MEAN <- (country.day$ONI_POLITICAL + country.day$ONI_SOCIAL + country.day$ONI_TOOLS + country.day$ONI_CONFLICT.SECURITY)/4
country$ONI_MEAN <- (country$ONI_POLITICAL + country$ONI_SOCIAL + country$ONI_TOOLS + country$ONI_CONFLICT.SECURITY)/4

#############
# Summary stat tables
#############

vars <- c("Pub","Pub.b","PUB","W_pub_n_t","PROTEST_MEAN","V_CIV_I_MEAN","V_CIV_G_MEAN","POLITY2","CIRI_SPEECH","FH_FOTPSC5","NATO","PARTICIPATE","PROTEST","ALL","V_CIV_I","V_CIV_G","PUBLIC","DIST_KM","WARYEARS","TID","INTERNET100_ITU_MI","WB_SECEDUC","ONI_MEAN","N_PAPERS","PAID_CIRC")

# Country
statmat <- t(stat.desc(country[,names(country)%in%vars]))[,c("nbr.val","median","mean","std.dev","min","max")]
xtable(statmat,digits=3)

# Country-day
statmat <- t(stat.desc(country.day[,names(country.day)%in%vars]))[,c("nbr.val","median","mean","std.dev","min","max")]
xtable(statmat,digits=3)

# Newspaper-day
statmat <- t(stat.desc(paper.panel[,names(paper.panel)%in%vars]))[,c("nbr.val","median","mean","std.dev","min","max")]
xtable(statmat,digits=3)


#############
## Figure 2 (world map)
#############

data(wrld_simpl)
map <- wrld_simpl
map$INDATA <- "white"
map$DEM <- "white"
map$PUB <- NA
map$AUT <- 0
names(map)

# Align country codes
ccodez <- function(data,var){
  data$ISO3 <- countrycode(data[,var], "cowc", "iso3c")
  missing <- sort(unique(data[is.na(data$ISO3),var]))
  print(missing)
  return(data)}

missing.codez <- function(data,invar,outvar,missing){
  for(j in 1:nrow(missing)){  
    data[which(data[,invar]==as.character(missing[j,invar])),outvar] <-as.character(missing[j,outvar])}
  return(data)}

# Country-day
country.day. <- ccodez(country.day,"COW")
missing <- data.frame(COW=c("ETI","FJI","KOS","PRI","RUM","VIE","WGB","ZAI"),ISO3=c("ETH","FJI","UNK","PRI","ROU","VNM","PSE","COD"))
for(i in 1:ncol(missing)){missing[,i] <- as.character(missing[,i])}
country.day. <- missing.codez(data=country.day.,invar="COW",outvar="ISO3",missing)
head(country.day.)
sort(unique(country.day.$ISO3))
country.day <- country.day.

# Newspaper-day
paper.panel. <- ccodez(paper.panel,"COW")
missing <- data.frame(COW=c("ETI","FJI","KOS","PRI","RUM","VIE","WGB","ZAI"),ISO3=c("ETH","FJI","UNK","PRI","ROU","VNM","PSE","COD"))
for(i in 1:ncol(missing)){missing[,i] <- as.character(missing[,i])}
paper.panel. <- missing.codez(data=paper.panel.,invar="COW",outvar="ISO3",missing)
head(paper.panel.)
sort(unique(paper.panel.$ISO3))
paper.panel <- paper.panel.

# Articles
head(articles)
articles. <- ccodez(articles,"COW")
missing <- data.frame(COW=c("ETI","FJI","KOS","PRI","RUM","VIE","WGB","ZAI"),ISO3=c("ETH","FJI","UNK","PRI","ROU","VNM","PSE","COD"))
for(i in 1:ncol(missing)){missing[,i] <- as.character(missing[,i])}
articles. <- missing.codez(data=articles.,invar="COW",outvar="ISO3",missing)
head(articles.)
sort(unique(articles.$ISO3))
articles <- articles.

# Create map symbology
paper.panel$DEMOCRACY <- paper.panel$DEMOCRACY6
dmat <- aggregate(paper.panel[,c("DEMOCRACY","Pub")],by=list(COW=paper.panel$COW),FUN=mean)
dmat. <- ccodez(dmat,"COW")
missing <- data.frame(COW=c("ETI","FJI","KOS","PRI","RUM","VIE","WGB","ZAI"),ISO3=c("ETH","FJI","UNK","PRI","ROU","VNM","PSE","COD"))
for(i in 1:ncol(missing)){missing[,i] <- as.character(missing[,i])}
dmat. <- missing.codez(data=dmat.,invar="COW",outvar="ISO3",missing)
head(dmat.)
sort(unique(dmat.$ISO3))
dmat <- dmat.
indata <- dmat$ISO3
indata[!indata%in%wrld_simpl$ISO3]
map$INDATA[map$ISO3%in%indata] <- "darkblue"
map$DEM[map$ISO3%in%(dmat$ISO3[dmat$DEMOCRACY==1])] <- "blue"
map$DEM[map$ISO3%in%(dmat$ISO3[dmat$DEMOCRACY==0])] <- "red"
map$AUT[map$ISO3%in%(dmat$ISO3[dmat$DEMOCRACY==0])] <- 20
map$PUB[map$ISO3%in%(dmat$ISO3[dmat$Pub<.05])] <- "gray80"
map$PUB[map$ISO3%in%(dmat$ISO3[dmat$Pub>=.05&dmat$Pub<.25])] <- "gray50"
map$PUB[map$ISO3%in%(dmat$ISO3[dmat$Pub>=.25&dmat$Pub<.5])] <- "gray30"
map$PUB[map$ISO3%in%(dmat$ISO3[dmat$Pub>=.5])] <- "gray0"


pdf("Figures/Figure2.pdf",height=3,width=5)
par(mar=c(0,0,0,0))
plot(map[!map$ISO3%in%c("ATA","GRL"),],col=map$PUB[!map$ISO3%in%c("ATA","GRL")],border="grey",lwd=.6)
plot(map[!map$ISO3%in%c("ATA","GRL"),],col="red",border=NA,density=map$AUT[!map$ISO3%in%c("ATA","GRL")],add=T,lwd=.5)
legend(x="bottomleft",fill=c("gray80","gray50","gray30","gray0"),border=NA,lwd=c(NA,NA,NA,NA),col="red",legend=c("[0.00, 0.05)","[0.05, 0.25)","[0.25, 0.50)","[0.50, 1.00]"),bty="n",cex=1,ncol=3)
legend(x="bottomright",fill=c(NA),border=NA,lwd=c(1),col="red",legend=c("Non-democracy"),bty="n",cex=1,ncol=1)
dev.off()



#############
## Figure 3 (Bar graph)
#############

country$DEMOCRACY <- country[,"DEMOCRACY6"]

## Articles by country

# Global
y1 <- sum(country$N_ARTICLES[country$DEMOCRACY==1])
y0 <- sum(country$N_ARTICLES[country$DEMOCRACY==0])
y1_n <- sum(country$DEMOCRACY==1)
y0_n <- sum(country$DEMOCRACY==0)

## Africa
africa <- c("BEN" ,"BFO", "CAO","BOT","GAB" ,"ZAI","ZAM","ZIM","TAZ","UGA","SAF","SEN","SIE","RWA","MAG","MAS","MZM","NAM","NIG", "KEN","LBR","GAM","GHA", "ETI" )
y_africa <- sum(country$N_ARTICLES[country$COW%in%africa])
y1_africa <- sum(country$N_ARTICLES[country$DEMOCRACY==1&country$COW%in%africa])
y0_africa <- sum(country$N_ARTICLES[country$DEMOCRACY==0&country$COW%in%africa])
y1_africa_n <- sum(country$COW%in%africa&country$DEMOCRACY==1)
y0_africa_n <- sum(country$COW%in%africa&country$DEMOCRACY==0)

## W. Europe
weurope <- c( "BEL","AUS","FRN", "UKG","SPN","SWZ","NTH","ITA","GMY","IRE","DEN","FIN" )
y_we <- sum(country$N_ARTICLES[country$COW%in%weurope])
y1_we <- sum(country$N_ARTICLES[country$DEMOCRACY==1&country$COW%in%weurope])
y0_we <- sum(country$N_ARTICLES[country$DEMOCRACY==0&country$COW%in%weurope])
y1_we_n <- sum(country$COW%in%weurope&country$DEMOCRACY==1)
y0_we_n <- sum(country$COW%in%weurope&country$DEMOCRACY==0)

## E. Europe & FSU 
eeurope <- c( "ARM","ALB","BUL","BOS","TUR","UKR","SLO","SLV","POL", "RUM", "RUS","LIT","KOS","LAT","GRG","HUN", "CRO","CYP","CZR","EST"  )
y_ee <- sum(country$N_ARTICLES[country$COW%in%eeurope])
y1_ee <- sum(country$N_ARTICLES[country$DEMOCRACY==1&country$COW%in%eeurope])
y0_ee <- sum(country$N_ARTICLES[country$DEMOCRACY==0&country$COW%in%eeurope])
y1_ee_n <- sum(country$COW%in%eeurope&country$DEMOCRACY==1)
y0_ee_n <- sum(country$COW%in%eeurope&country$DEMOCRACY==0)

## ME & N. Africa
me <- c("BAH","ALG","YEM", "TUN","UAE","SAU","SYR", "OMA" ,"QAT","MAA","MOR","JOR", "LEB","LIB","IRN","IRQ","ISR","EGY" )
y_me <- sum(country$N_ARTICLES[country$COW%in%me])
y1_me <- sum(country$N_ARTICLES[country$DEMOCRACY==1&country$COW%in%me])
y0_me <- sum(country$N_ARTICLES[country$DEMOCRACY==0&country$COW%in%me])
y1_me_n <- sum(country$COW%in%me&country$DEMOCRACY==1)
y0_me_n <- sum(country$COW%in%me&country$DEMOCRACY==0)

## Asia
asia <- c("CHN","BNG", "AUL","AFG","CAM","FJI", "THI","VIE","SIN","SRI","TAW","PAK","PHI","PNG","ROK", "MAL" ,"NEP","NEW","JPN","KUW","KZK","LAO","GUA","IND","INS")
y_asia <- sum(country$N_ARTICLES[country$COW%in%asia])
y1_asia <- sum(country$N_ARTICLES[country$DEMOCRACY==1&country$COW%in%asia])
y0_asia <- sum(country$N_ARTICLES[country$DEMOCRACY==0&country$COW%in%asia])
y1_asia_n <- sum(country$COW%in%asia&country$DEMOCRACY==1)
y0_asia_n <- sum(country$COW%in%asia&country$DEMOCRACY==0)

## Lat Am
latam <- c("ARG","COL","COS","CHL","BRA","BOL" ,"URU","VEN","PER", "MEX","ECU")
y_latam <- sum(country$N_ARTICLES[country$COW%in%latam])
y1_latam <- sum(country$N_ARTICLES[country$DEMOCRACY==1&country$COW%in%latam])
y0_latam <- sum(country$N_ARTICLES[country$DEMOCRACY==0&country$COW%in%latam])
y1_latam_n <- sum(country$COW%in%latam&country$DEMOCRACY==1)
y0_latam_n <- sum(country$COW%in%latam&country$DEMOCRACY==0)

## USA & Canada
usac <- c("CAN","USA")
y_usac <- sum(country$N_ARTICLES[country$COW%in%usac])
y1_usac <- sum(country$N_ARTICLES[country$DEMOCRACY==1&country$COW%in%usac])
y0_usac <- sum(country$N_ARTICLES[country$DEMOCRACY==0&country$COW%in%usac])
y1_usac_n <- sum(country$COW%in%usac&country$DEMOCRACY==1)
y0_usac_n <- sum(country$COW%in%usac&country$DEMOCRACY==0)

## Make plot
pdf(file="Figures/Figure3.pdf",width=4,height=3)
par(mar=c(2,6,.5,.5))
plot(x=0,y=0,col=NA,ylim=c(1,10),xlim=c(0,230000),yaxt="n",ylab="",xlab="",bty="l",cex.axis=.7,xaxt="n")
axis(1,at=pretty(0:y1),labels=formatC(pretty(0:y1), format="d", big.mark=','),cex.axis=.7)
segments(x0=seq(0,230000,by=10000),x1=seq(0,230000,by=10000),y0=0,y1=12,lty=3,col="lightgrey",lwd=.5)
# Global
rect(xleft=0, ybottom=9.5, xright=y0, ytop=10, col = "grey10");text(x=y0,y=9.7,label=paste("N =",y0_n,"countries"),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=9, xright=y1, ytop=9.5, col = "grey90");text(x=y1,y=9.2,label=paste("N =",y1_n),cex=.6,pos=4,col="darkgrey")
# W. Europe
rect(xleft=0, ybottom=7.5, xright=y0_we, ytop=7.9, col = "grey10");text(x=y0_we,y=7.7,label=paste("N =",y0_we_n),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=7.1, xright=y1_we, ytop=7.5, col = "grey90");text(x=y1_we,y=7.2,label=paste("N =",y1_we_n),cex=.6,pos=4,col="darkgrey")
# N. America
rect(xleft=0, ybottom=6.5, xright=y0_usac, ytop=6.9, col = "grey10");text(x=y0_usac,y=6.7,label=paste("N =",y0_usac_n),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=6.1, xright=y1_usac, ytop=6.5, col = "grey90");text(x=y1_usac,y=6.2,label=paste("N =",y1_usac_n),cex=.6,pos=4,col="darkgrey")
# S. America
rect(xleft=0, ybottom=5.5, xright=y0_latam, ytop=5.9, col = "grey10");text(x=y0_latam,y=5.7,label=paste("N =",y0_latam_n),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=5.1, xright=y1_latam, ytop=5.5, col = "grey90");text(x=y1_latam,y=5.2,label=paste("N =",y1_latam_n),cex=.6,pos=4,col="darkgrey")
# E. Europe
rect(xleft=0, ybottom=4.5, xright=y0_ee, ytop=4.9, col = "grey10");text(x=y0_ee,y=4.7,label=paste("N =",y0_ee_n),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=4.1, xright=y1_ee, ytop=4.5, col = "grey90");text(x=y1_ee,y=4.2,label=paste("N =",y1_ee_n),cex=.6,pos=4,col="darkgrey")
# Africa
rect(xleft=0, ybottom=3.5, xright=y0_africa, ytop=3.9, col = "grey10");text(x=y0_africa,y=3.7,label=paste("N =",y0_africa_n),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=3.1, xright=y1_africa, ytop=3.5, col = "grey90");text(x=y1_africa,y=3.2,label=paste("N =",y1_africa_n),cex=.6,pos=4,col="darkgrey")
# Asia
rect(xleft=0, ybottom=2.5, xright=y0_asia, ytop=2.9, col = "grey10");text(x=y0_asia,y=2.7,label=paste("N =",y0_asia_n),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=2.1, xright=y1_asia, ytop=2.5, col = "grey90");text(x=y1_asia,y=2.2,label=paste("N =",y1_asia_n),cex=.6,pos=4,col="darkgrey")
# Middle East
rect(xleft=0, ybottom=1.5, xright=y0_me, ytop=1.9, col = "grey10");text(x=y0_me,y=1.7,label=paste("N =",y0_me_n),cex=.6,pos=4,col="darkgrey")
rect(xleft=0, ybottom=1.1, xright=y1_me, ytop=1.5, col = "grey90");text(x=y1_me,y=1.2,label=paste("N =",y1_me_n),cex=.6,pos=4,col="darkgrey")
# Y axis labels
axis(2,at=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,9.5),labels=c("Middle East","Asia","Africa","East Europe","South America","North America","West Europe","Global"),las=1,cex.axis=.8)
# Legend
legend("bottomright",fill=c("grey10","grey90"),legend=c("Non-democracy","Democracy"),bg="white",cex=.7,bty="")
# X axis label
par(xpd=NA)
text(x=-17000,y=-.65,label="Articles:",pos=2,cex=.75)
dev.off()



#############
## Figure 4 (timeplot)
#############

ticker <- data.frame(YEAR=c(rep(2010,14),rep(2011,31+28+31+30+31+30+31+31+30+24)),MONTH=c(rep(12,14),rep(1,31),rep(2,28),rep(3,31),rep(4,30),rep(5,31),rep(6,30),rep(7,31),rep(8,31),rep(9,30),rep(10,24)),DAY=c(18:31,1:31,1:28,1:31,1:30,1:31,1:30,1:31,1:31,1:30,1:24))
ticker$DATE <- ticker$YEAR*10000+ticker$MONTH*100+ticker$DAY
ticker$TID <- 1:nrow(ticker)
ticker <- ticker[,c("DATE","TID")]
ticker$LABEL <- paste(as.numeric(substr(ticker$DATE,5,6)),"/",substr(ticker$DATE,3,4),sep="")
ticker$LABEL[duplicated(ticker$LABEL)] <- ""
ticker$TICK <- NA
ticker$TICK[ticker$LABEL!=""] <- ticker$TID[ticker$LABEL!=""]
ticker$LABEL[ticker$LABEL!=""] <- c("","Jan","Feb","Mar","Apr","Mar","Jun","Jul","Aug","Sep","Oct")
country.day$DEMOCRACY <- country.day[,"DEMOCRACY6"]
time.data.v <- aggregate(country.day[,c("PROTEST","V_CIV_I","V_CIV_G","ALL")],by=list(TID=country.day$TID),FUN=function(x){mean(x,na.rm=T)})
time.data.d <- aggregate(country.day[country.day$DEMOCRACY==1,c("PROP_DAY","PUB")],by=list(TID=country.day[country.day$DEMOCRACY==1,"TID"]),FUN=function(x){mean(x,na.rm=T)})
time.data.nd <- aggregate(country.day[country.day$DEMOCRACY==0,c("PROP_DAY","PUB")],by=list(TID=country.day[country.day$DEMOCRACY==0,"TID"]),FUN=function(x){mean(x,na.rm=T)})

x <- time.data.v$TID


## Plot
pdf("Figures/Figure4.pdf",height=3,width=8)
par(mar = c(2, 4, .5, 4))
plot(x,time.data.v$ALL,type="h",col="gray",xlab="",xaxt="n",ylab="Libya civil war violence")
points(x,-1/4*(time.data.v$PROTEST>0),col=ifelse(time.data.v$PROTEST>0,"orange3",NA),cex=.5,pch=5)
points(x,-3/4*(time.data.v$V_CIV_G>0),col=ifelse(time.data.v$V_CIV_G>0,"green3",NA),cex=.5,pch=8)
points(x,-1/2*(time.data.v$V_CIV_I>0),col=ifelse(time.data.v$V_CIV_I>0,"black",NA),cex=.5,pch=6)
axis(1,at=ticker$TICK,labels=ticker$LABEL,cex.axis=.8,xlab="")
legend("topleft",col=c("gray"),lwd=c(1),legend=c("Incidents/day"),title="Libya civil war violence",cex=.7,bty="n")
legend("topright",col=c("blue","red"),lty=c(1,2),legend=c("Democracies","Non-democracies"),title="News coverage",cex=.7,bty="n")
legend(x=130,y=max(time.data.v$ALL)+1,col=c("orange3","black","green3"),pch=c(5,6,8),legend=c("Protests","Rebel killings","Government killings"),title="Types of incidents",cex=.7,bty="n",ncol=1)
par(new = TRUE)
plot(x,time.data.d$PROP_DAY,type="l",bty="n",axes=F,col="blue",ylab="",xlab="",lwd=.7)
axis(side=4, at = pretty(range(time.data.d$PROP_DAY)))
par(new = TRUE)
plot(x,time.data.nd$PROP_DAY,type="l",bty="n",axes=F,col="red",ylab="",xlab="",lwd=.7,lty=2)
mtext("News coverage", side=4, line=3)
dev.off()


#############
## Figure 5a (country-day)
#############


# Specification 
form_outcome <- "PUB"
form_lags <- "PUB_t1 + "
form_controls <- "PUBLIC + DIST_KM  + WARYEARS + TID + N_PAPERS + INTERNET100_ITU_MI + WB_SECEDUC"
form_interactions <- "DEMOCRACY + PROTEST + INT_DEM_PRO + ALL + INT_DEM_ALL + V_CIV_I + INT_DEM_CIVI + V_CIV_G + INT_DEM_CIVG + "
form_mod <- as.formula(paste(form_outcome,"~",form_lags,form_interactions,form_controls,sep=""))
data <- country.day
varz <- "DEMOCRACY6"
data$DEMOCRACY <- data[,varz]

## Interactions
names(data)
data$INT_DEM_ALL <- data$DEMOCRACY*data$ALL
data$INT_DEM_PRO <- data$DEMOCRACY*data$PROTEST
data$INT_DEM_NATO <- data$DEMOCRACY*data$NATO_STRIKE
data$INT_DEM_CIVI <- data$DEMOCRACY*data$V_CIV_I
data$INT_DEM_CIVG <- data$DEMOCRACY*data$V_CIV_G
data$INT_DEM_DIST <- data$DEMOCRACY*data$V_MEAN_DIST
data$INT_DEM_SDD <- data$DEMOCRACY*data$V_SDD_Radius
data$INT_DEM_PUB <- data$DEMOCRACY*data$PUBLIC
data$INT_DEM_NET <- data$DEMOCRACY*data$NETSIZE

## Dem interactions
inter <- list(
  INT_DEM_PRO=c("INT_DEM_PRO","DEMOCRACY","PROTEST"),
  INT_DEM_ALL=c("INT_DEM_ALL","DEMOCRACY","ALL"),
  INT_DEM_CONV=c("INT_DEM_CONV","DEMOCRACY","CONV"),
  INT_DEM_CIVG=c("INT_DEM_CIVG","DEMOCRACY","V_CIV_G"),
  INT_DEM_CIVI=c("INT_DEM_CIVI","DEMOCRACY","V_CIV_I"),
  INT_DEM_NATO=c("INT_DEM_NATO","DEMOCRACY","NATO_STRIKE"),
  INT_DEM_DIST=c("INT_DEM_DIST","DEMOCRACY","V_MEAN_DIST"),
  IND_DEM_SDD=c("INT_DEM_SDD","DEMOCRACY","V_SDD_Radius"),
  INT_DEM_NET=c("INT_DEM_NET","DEMOCRACY","NETSIZE"),
  INT_DEM_PUB=c("INT_DEM_PUB","DEMOCRACY","PUBLIC")
)

# Fit model
mod <- glm(form_mod, data=data, family="binomial"); summary(mod)

# Predict 
conds <- list(DEMOCRACY=0,DEMOCRACY=1)
xvar <- "PROTEST"
rr.protest <- rr.100.X(mod=mod,xvar=xvar,x0=quantile(data[,xvar],.01,na.rm=T),x1=quantile(data[,xvar],.99,na.rm=T),conds=conds,inter=inter)
rr.protest
xvar <- "V_CIV_I"
rr.civi <- rr.100.X(mod=mod,xvar=xvar,x0=quantile(data[,xvar],.01,na.rm=T),x1=quantile(data[,xvar],.99,na.rm=T),conds=conds,inter=inter)
rr.civi
xvar <- "V_CIV_G"
rr.civg <- rr.100.X(mod=mod,xvar=xvar,x0=quantile(data[,xvar],.01,na.rm=T),x1=quantile(data[,xvar],.99,na.rm=T),conds=conds,inter=inter)
rr.civg

## Plot
l1 <- list(PROTEST=rr.protest,V_CIV_I=rr.civi,V_CIV_G=rr.civg)
varnames <- c("Protest","Rebel killings of civilians","Government killings of civilians")
xlims <- c(floor(min(unlist(l1))/50)*50,ceiling(max(unlist(l1))/50)*50)
pdf(file=paste("Figures/Figure5a.pdf",sep=""),width=4,height=3)
par(mar=c(4,8,.5,.5))
plot(0,0,xlim=xlims,ylim=c(0.5,3.5),col=NA,yaxt="n",bty="n",xlab="Percent change",ylab=NA,cex.axis=.8,cex.lab=.8)
par(xpd=NA)
for(i in 1:length(l1)){
  text(x=xlims[1],y=i+.15,varnames[i],pos=2,cex=.7)
  text(x=xlims[1],y=i-.25,paste("CF:",round(quantile(data[,names(l1)[i]],.01,na.rm=T),0), "to" ,round(quantile(data[,names(l1)[i]],.99,na.rm=T),0)),cex=.7,col="gray60",pos=2)
  rect(xleft=xlims[1],ybottom=i-.4,xright=xlims[2],ytop=i+.4,col="beige",border=NA)
  rect(xleft=l1[[i]][[1]][2],ybottom=i-.3,xright=l1[[i]][[1]][3],ytop=i-.05,col="gray60",border=NA)
  segments(x0=l1[[i]][[1]][1],x1=l1[[i]][[1]][1],y0=i-.3,y1=i-.05,col="white")
  rect(xleft=l1[[i]][[2]][2],ybottom=i+.05,xright=l1[[i]][[2]][3],ytop=i+.3,col="gray20",border=NA)
  segments(x0=l1[[i]][[2]][1],x1=l1[[i]][[2]][1],y0=i+.3,y1=i+.05,col="white")
}
segments(x0=0,x1=0,y0=.6,y1=3.4,lty=3)
legend(x=xlims[1]-.6*(xlims[2]-xlims[1]),y=0.5,fill=c("gray20","gray60"),legend=c("Non-democracies","Democracies"),bty="n",cex=.7)
dev.off()




#############
## Figure 5b (newspaper-day)
#############

# Specification
form_outcome <- "Pub"
form_lags <- "W_pub_n_t + "
form_controls <- "PUBLIC + DIST_KM  + WARYEARS + TID + N_PAPERS + INTERNET100_ITU_MI + WB_SECEDUC"
form_interactions <- "DEMOCRACY + PROTEST + INT_DEM_PRO + ALL + INT_DEM_ALL + V_CIV_I + INT_DEM_CIVI + V_CIV_G + INT_DEM_CIVG + "
form_mod <- as.formula(paste(form_outcome,"~",form_lags,form_interactions,form_controls,sep=""))
data <- paper.panel
varz <- "DEMOCRACY6"
data$DEMOCRACY <- data[,varz]
  names(data)
  ## Interactions
  data$INT_DEM_ALL <- data$DEMOCRACY*data$ALL
  data$INT_DEM_PRO <- data$DEMOCRACY*data$PROTEST
  data$INT_DEM_NATO <- data$DEMOCRACY*data$NATO_STRIKE
  data$INT_DEM_CIVI <- data$DEMOCRACY*data$V_CIV_I
  data$INT_DEM_CIVG <- data$DEMOCRACY*data$V_CIV_G
  data$INT_DEM_DIST <- data$DEMOCRACY*data$V_MEAN_DIST
  data$INT_DEM_SDD <- data$DEMOCRACY*data$V_SDD_Radius
  data$INT_DEM_PUB <- data$DEMOCRACY*data$PUBLIC
  data$INT_DEM_NET <- data$DEMOCRACY*data$NETSIZE
  
  ## Dem interactions
  inter <- list(
    INT_DEM_PRO=c("INT_DEM_PRO","DEMOCRACY","PROTEST"),
    INT_DEM_ALL=c("INT_DEM_ALL","DEMOCRACY","ALL"),
    INT_DEM_CIVG=c("INT_DEM_CIVG","DEMOCRACY","V_CIV_G"),
    INT_DEM_CIVI=c("INT_DEM_CIVI","DEMOCRACY","V_CIV_I"),
    INT_DEM_NATO=c("INT_DEM_NATO","DEMOCRACY","NATO_STRIKE"),
    INT_DEM_DIST=c("INT_DEM_DIST","DEMOCRACY","V_MEAN_DIST"),
    IND_DEM_SDD=c("INT_DEM_SDD","DEMOCRACY","V_SDD_Radius"),
    INT_DEM_NET=c("INT_DEM_NET","DEMOCRACY","NETSIZE"),
    INT_DEM_PUB=c("INT_DEM_PUB","DEMOCRACY","PUBLIC")
  )
  
# Fit model
mod <- glm(form_mod, data=data[,], family="binomial");summary(mod)

# Predict
  conds <- list(DEMOCRACY=0,DEMOCRACY=1)
  xvar <- "PROTEST"
  rr.protest <- rr.100.X(mod=mod,xvar=xvar,x0=quantile(data[,xvar],.01,na.rm=T),x1=quantile(data[,xvar],.99,na.rm=T),conds=conds,inter=inter)
  rr.protest
  xvar <- "V_CIV_I"
  rr.civi <- rr.100.X(mod=mod,xvar=xvar,x0=quantile(data[,xvar],.01,na.rm=T),x1=quantile(data[,xvar],.99,na.rm=T),conds=conds,inter=inter)
  rr.civi
  xvar <- "V_CIV_G"
  rr.civg <- rr.100.X(mod=mod,xvar=xvar,x0=quantile(data[,xvar],.01,na.rm=T),x1=quantile(data[,xvar],.99,na.rm=T),conds=conds,inter=inter)
  rr.civg
  
## Plot
  l1 <- list(PROTEST=rr.protest,V_CIV_I=rr.civi,V_CIV_G=rr.civg)
  varnames <- c("Protest","Rebel killings of civilians","Government killings of civilians")
  data <- data
  xlims <- c(floor(min(unlist(l1))/50)*50,ceiling(max(unlist(l1))/50)*50)
  pdf(file="Figures/Figure5b.pdf",width=4,height=3)
  par(mar=c(4,8,.5,.5))
  plot(0,0,xlim=xlims,ylim=c(0.5,3.5),col=NA,yaxt="n",bty="n",xlab="Percent change",ylab=NA,cex.axis=.8,cex.lab=.8)
  par(xpd=NA)
  for(i in 1:length(l1)){
    text(x=xlims[1],y=i+.15,varnames[i],pos=2,cex=.7)
    text(x=xlims[1],y=i-.25,paste("CF:",round(quantile(data[,names(l1)[i]],.01,na.rm=T),0), "to" ,round(quantile(data[,names(l1)[i]],.99,na.rm=T),0)),cex=.7,col="grey",pos=2)
    rect(xleft=xlims[1],ybottom=i-.4,xright=xlims[2],ytop=i+.4,col="beige",border=NA)
    rect(xleft=l1[[i]][[1]][2],ybottom=i-.3,xright=l1[[i]][[1]][3],ytop=i-.05,col="gray60",border=NA)
    segments(x0=l1[[i]][[1]][1],x1=l1[[i]][[1]][1],y0=i-.3,y1=i-.05,col="white")
    rect(xleft=l1[[i]][[2]][2],ybottom=i+.05,xright=l1[[i]][[2]][3],ytop=i+.3,col="gray20",border=NA)
    segments(x0=l1[[i]][[2]][1],x1=l1[[i]][[2]][1],y0=i+.3,y1=i+.05,col="white")
  }
  segments(x0=0,x1=0,y0=.6,y1=3.4,lty=3)
  legend(x=xlims[1]-.6*(xlims[2]-xlims[1]),y=0.5,fill=c("gray20","gray60"),legend=c("Non-democracies","Democracies"),bty="n",cex=.7)
  dev.off()











########################################
## Table I (country)
########################################

# Specification
form_X <- "DEMOCRACY"
form_Xa <- "POLITY2"
form_controls <- "PUBLIC + DIST_KM + WARYEARS + WB_SECEDUC+  INTERNET100_ITU_MI +N_PAPERS"
form_controls_a <- "PUBLIC + DIST_KM + WARYEARS + WB_SECEDUC+  INTERNET100_ITU_MI +N_PAPERS + ONI_MEAN"
form_mod_a <- as.formula(paste("Y ~ ",form_X,"+",form_controls))
form_mod_b <- as.formula(paste("Y ~ ",form_Xa,"+",form_controls))

  varz <- "DEMOCRACY6"
  print(varz)
  country$DEMOCRACY <- country[,varz]
  
  # Protests
  country$Y <- country$PROTEST_MEAN
  country. <- country[country$Y!=0&country$Y!=1&!is.na(country$Y),]
  #country$Y[country$Y==0] <- 1e-16
  #country$Y[country$Y==1] <- 1-(1e-16)
  mod1 <- betareg(form_mod_a, data=country., link="loglog",type="BC");summary(mod1a)
  mod2 <- betareg(form_mod_b, data=country., link="loglog",type="BC");summary(mod1b)
  
  # Insurgent killings
  country$Y <- country$V_CIV_I_MEAN
  country. <- country[country$Y!=0&country$Y!=1&!is.na(country$Y),]
  #country$Y[country$Y==0] <- 1e-16
  #country$Y[country$Y==1] <- 1-1e-16
  mod3 <- betareg(form_mod_a, data=country., link="loglog",type="BC");summary(mod2a)
  mod4 <- betareg(form_mod_b, data=country., link="loglog",type="BC");summary(mod2b)
  
  # Govt killings
  country$Y <- country$V_CIV_G_MEAN
  country. <- country[country$Y!=0&country$Y!=1&!is.na(country$Y),]
  #country$Y[country$Y==0] <- 1e-16
  #country$Y[country$Y==1] <- 1-1e-16
  mod5 <- betareg(form_mod_a, data=country., link="loglog",type="BC");summary(mod3a)
  mod6 <- betareg(form_mod_b, data=country., link="loglog",type="BC");summary(mod3b)
  
# Print to file
rnd <- 3
modlist <- list(Protest=mod1,Protest=mod2,Rebel=mod3,Rebel=mod4,Government=mod5,Government=mod6)
modmat <- outreg_beta(modlist,rnd=rnd)
print.xtable(xtable(modmat),file="Tables/TableI.tex",include.rownames=F)

# AIC
k <- length(attr(mod1$terms$full,"term.labels"));ll <- mod1$loglik;aic1 <- 2*k - 2*ll
k <- length(attr(mod2$terms$full,"term.labels"));ll <- mod2$loglik;aic2 <- 2*k - 2*ll
k <- length(attr(mod3$terms$full,"term.labels"));ll <- mod3$loglik;aic3 <- 2*k - 2*ll
k <- length(attr(mod4$terms$full,"term.labels"));ll <- mod4$loglik;aic4 <- 2*k - 2*ll
k <- length(attr(mod5$terms$full,"term.labels"));ll <- mod5$loglik;aic5 <- 2*k - 2*ll
k <- length(attr(mod6$terms$full,"term.labels"));ll <- mod6$loglik;aic6 <- 2*k - 2*ll
paste0(round(c(aic1,aic2,aic3,aic4,aic5,aic6),3),collapse=" & ")



########################################
## Table II (country-day)
########################################

data <- country.day
varz <- "DEMOCRACY6"
data$DEMOCRACY <- data[,varz]

## Interactions
data$INT_DEM_ALL <- data$DEMOCRACY*data$ALL
data$INT_DEM_PRO <- data$DEMOCRACY*data$PROTEST
data$INT_DEM_NATO <- data$DEMOCRACY*data$NATO_STRIKE
data$INT_DEM_CIVI <- data$DEMOCRACY*data$V_CIV_I
data$INT_DEM_CIVG <- data$DEMOCRACY*data$V_CIV_G
data$INT_DEM_DIST <- data$DEMOCRACY*data$V_MEAN_DIST
data$INT_DEM_SDD <- data$DEMOCRACY*data$V_SDD_Radius
data$INT_DEM_PUB <- data$DEMOCRACY*data$PUBLIC
data$INT_DEM_NET <- data$DEMOCRACY*data$NETSIZE

## Dem interactions
inter <- list(
  INT_DEM_PRO=c("INT_DEM_PRO","DEMOCRACY","PROTEST"),
  INT_DEM_ALL=c("INT_DEM_ALL","DEMOCRACY","ALL"),
  INT_DEM_CIVG=c("INT_DEM_CIVG","DEMOCRACY","V_CIV_G"),
  INT_DEM_CIVI=c("INT_DEM_CIVI","DEMOCRACY","V_CIV_I"),
  INT_DEM_NATO=c("INT_DEM_NATO","DEMOCRACY","NATO_STRIKE"),
  INT_DEM_DIST=c("INT_DEM_DIST","DEMOCRACY","V_MEAN_DIST"),
  IND_DEM_SDD=c("INT_DEM_SDD","DEMOCRACY","V_SDD_Radius"),
  INT_DEM_NET=c("INT_DEM_NET","DEMOCRACY","NETSIZE"),
  INT_DEM_PUB=c("INT_DEM_PUB","DEMOCRACY","PUBLIC")
)


# Specification
form_Y <- "PUB"
form_lag <- "PUB_t1"
form_interactions <- "DEMOCRACY + PROTEST + INT_DEM_PRO + ALL + INT_DEM_ALL+  V_CIV_I + INT_DEM_CIVI + V_CIV_G + INT_DEM_CIVG"
form_controls <- "PUBLIC +DIST_KM  + WARYEARS + WB_SECEDUC + INTERNET100_ITU_MI + N_PAPERS"
form_i <- "(1 | CCODE)"
form_t <- "(1 | TID)"
form_mod_7 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + TID"))
form_mod_8 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + TID +",form_i))
form_mod_9 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + ",form_t))
form_mod_10 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + ",form_i," + ",form_t))

# No RE
mod7 <- glm(form_mod_7, data=data, family="binomial")
# Country RE
mod8 <- glmer(form_mod_8, data=data, family=binomial) 
# Day FE
mod9 <- glmer(form_mod_9, data=data, family=binomial) 
# Country + Time RE
mod10 <- glmer(form_mod_10, data=data, family=binomial) 

# Print to file
modlist <- list(Model7=mod7,Model8=mod8,Model9=mod9,Model10=mod10)
modmat <- outreg3alt(modlist,3,"CCODE","TID"); xtable(modmat)
print.xtable(xtable(modmat),file="Tables/TableII.tex",include.rownames=F)
modmat <- outreg3alt(modlist,6,"CCODE","TID"); xtable(modmat)
print.xtable(xtable(modmat),file="Tables/TableIIa.tex",include.rownames=F)



########################################
## Table III (newspaper-day)
########################################

data <- paper.panel
varz <- "DEMOCRACY6"
data$DEMOCRACY <- data[,varz]

## Interactions
data$INT_DEM_ALL <- data$DEMOCRACY*data$ALL
data$INT_DEM_PRO <- data$DEMOCRACY*data$PROTEST
data$INT_DEM_NATO <- data$DEMOCRACY*data$NATO_STRIKE
data$INT_DEM_CIVI <- data$DEMOCRACY*data$V_CIV_I
data$INT_DEM_CIVG <- data$DEMOCRACY*data$V_CIV_G
data$INT_DEM_DIST <- data$DEMOCRACY*data$V_MEAN_DIST
data$INT_DEM_SDD <- data$DEMOCRACY*data$V_SDD_Radius
data$INT_DEM_PUB <- data$DEMOCRACY*data$PUBLIC
data$INT_DEM_NET <- data$DEMOCRACY*data$NETSIZE

## Dem interactions
inter <- list(
  INT_DEM_PRO=c("INT_DEM_PRO","DEMOCRACY","PROTEST"),
  INT_DEM_ALL=c("INT_DEM_ALL","DEMOCRACY","ALL"),
  INT_DEM_CIVG=c("INT_DEM_CIVG","DEMOCRACY","V_CIV_G"),
  INT_DEM_CIVI=c("INT_DEM_CIVI","DEMOCRACY","V_CIV_I"),
  INT_DEM_NATO=c("INT_DEM_NATO","DEMOCRACY","NATO_STRIKE"),
  INT_DEM_DIST=c("INT_DEM_DIST","DEMOCRACY","V_MEAN_DIST"),
  IND_DEM_SDD=c("INT_DEM_SDD","DEMOCRACY","V_SDD_Radius"),
  INT_DEM_NET=c("INT_DEM_NET","DEMOCRACY","NETSIZE"),
  INT_DEM_PUB=c("INT_DEM_PUB","DEMOCRACY","PUBLIC")
)


# Specification
form_Y <- "Pub"
form_lag <- "W_pub_n_t"
form_interactions <- "DEMOCRACY + PROTEST + INT_DEM_PRO + ALL + INT_DEM_ALL+  V_CIV_I + INT_DEM_CIVI + V_CIV_G + INT_DEM_CIVG"
form_controls <- "PUBLIC +DIST_KM  + WARYEARS + WB_SECEDUC + INTERNET100_ITU_MI"
form_i <- "(1 | SID)"
form_t <- "(1 | TID)"
form_mod_11 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + TID"))
form_mod_12 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + TID + ",form_i))
form_mod_13 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + ",form_t))
form_mod_14 <- as.formula(paste(form_Y," ~ ",form_lag,"+",form_interactions," + ",form_controls," + ",form_i," + ",form_t))

# No RE
mod11 <- glm(form_mod_11, data=data, family="binomial")
# Newspaper RE
mod12 <- glmer(form_mod_12, data=data, family=binomial) 
# Day FE
mod13 <- glmer(form_mod_13, data=data, family=binomial) 
# Newspaper + Time RE
mod14 <- glmer(form_mod_14, data=data, family=binomial) 

modlist <- list(Model11=mod11,Model12=mod12,Model13=mod13,Model14=mod14)
modmat <- outreg3alt(modlist,3,"CCODE","TID"); xtable(modmat)
print.xtable(xtable(modmat),file="Tables/TableIII.tex",include.rownames=F)
modmat <- outreg3alt(modlist,6,"CCODE","TID"); xtable(modmat)
print.xtable(xtable(modmat),file="Tables/TableIIIa.tex",include.rownames=F)

