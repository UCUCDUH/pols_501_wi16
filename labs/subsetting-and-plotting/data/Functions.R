is.odd <- function(x) x %% 2 != 0



#################################
## Data cleanup function
#################################


dataclean <- function(data){
charvars <- c()
for(j in 1:ncol(data)){charvars[j] <- class(data[,j])}
for(j in which(charvars=="factor")){data[,j] <- as.character(data[,j])}
for(j in which(charvars=="matrix")){data[,j] <- as.numeric(data[,j])}
charvars <- c()
for(j in 1:ncol(data)){charvars[j] <- class(data[,j])}
for(j in which(charvars=="character")){data[,j] <- substr(data[,j],1,50)}
return(data)
}




#################################
## Design matrix
#################################

X.design <- function(mod,xvar,xrange,cond=NULL,inter=NULL){
	n <- length(xrange)
	data <- mod$data
	vars <- unlist(strsplit(strsplit(as.character(mod$formula),split=" ~ ",fixed=T)[[3]]," + ",fixed=T))
	medians <- apply(data[,vars],2,function(x){median(x,na.rm=T)})
	X <- as.data.frame(matrix(medians,nrow=n,ncol=length(vars),byrow=T))
	names(X) <- vars
	X[,xvar] <- xrange
	if(length(cond)>0){for(i in 1:length(cond)){X[,names(cond)[i]] <- cond[[i]]}}
	if(length(inter)>0){inter <- inter[names(inter)%in%vars]
		for(i in 1:length(inter)){
		X[,inter[[i]][1]] <- X[,inter[[i]][2]]*X[,inter[[i]][3]]}}
	return(X)
}

#################################
## Binomial GLM predict function
#################################

bglm.predict <- function(mod,xvar,xrange,cond=NULL,inter=NULL){
	n <- length(xrange)
	data <- mod$data
	vars <- unlist(strsplit(strsplit(as.character(mod$formula),split=" ~ ",fixed=T)[[3]]," + ",fixed=T))
	medians <- apply(data[,vars],2,function(x){median(x,na.rm=T)})
	X <- as.data.frame(matrix(medians,nrow=n,ncol=length(vars),byrow=T))
	names(X) <- vars
	X[,xvar] <- xrange
	if(length(cond)>0){for(i in 1:length(cond)){X[,names(cond)[i]] <- cond[[i]]}}
	if(length(inter)>0){inter <- inter[names(inter)%in%vars]
		for(i in 1:length(inter)){
		X[,inter[[i]][1]] <- X[,inter[[i]][2]]*X[,inter[[i]][3]]}}

	preds <- predict.glm(mod,newdata=X,type="link",se.fit=T)
	pred.y <- 1/(1+exp(-preds$fit))
	pred.hi <- 1/(1+exp(-(preds$fit+1.96*preds$se.fit)))
	pred.lo <- 1/(1+exp(-(preds$fit-1.96*preds$se.fit)))
	return(list(pred.y=pred.y,pred.lo=pred.lo,pred.hi=pred.hi))
}


#################################
## Binomial GLM predict function (w/ SE)
#################################

bglm.predict2 <- function(mod,xvar,xrange,cond=NULL,inter=NULL){
	n <- length(xrange)
	data <- mod$data
	vars <- unlist(strsplit(strsplit(as.character(mod$formula),split=" ~ ",fixed=T)[[3]]," + ",fixed=T))
	medians <- apply(data[,vars],2,function(x){median(x,na.rm=T)})
	X <- as.data.frame(matrix(medians,nrow=n,ncol=length(vars),byrow=T))
	names(X) <- vars
	X[,xvar] <- xrange
	if(length(cond)>0){for(i in 1:length(cond)){X[,names(cond)[i]] <- cond[[i]]}}
	if(length(inter)>0){inter <- inter[names(inter)%in%vars]
		for(i in 1:length(inter)){
		X[,inter[[i]][1]] <- X[,inter[[i]][2]]*X[,inter[[i]][3]]}}

	preds <- predict.glm(mod,newdata=X,type="link",se.fit=T)
	pred.y <- 1/(1+exp(-preds$fit))
	pred.y <- preds$fit
	pred.se <- preds$se.fit
	return(list(pred.y=pred.y,pred.se=pred.se))
}

#################################
## GLM predict function (MVN)
#################################

glm.predict.mvn <- function(mod,xvar,xrange,cond=NULL,inter=NULL){
  nsim <- 1000
  n <- length(xrange)
  data <- mod$data
  vars <- unlist(strsplit(strsplit(as.character(mod$formula),split=" ~ ",fixed=T)[[3]]," + ",fixed=T))
  medians <- apply(data[,vars],2,function(x){median(x,na.rm=T)})
  X <- as.data.frame(matrix(medians,nrow=n,ncol=length(vars),byrow=T))
  names(X) <- vars
  X[,xvar] <- xrange
  X <- cbind(data.frame(Intercept=1),X)
  if(length(cond)>0){for(i in 1:length(cond)){X[,names(cond)[i]] <- cond[[i]]}}
  if(length(inter)>0){inter <- inter[names(inter)%in%vars]
                      for(i in 1:length(inter)){
                        X[,inter[[i]][1]] <- X[,inter[[i]][2]]*X[,inter[[i]][3]]}}
  
  betas <- rmvnorm(n=nsim,mean=coefficients(mod),sigma=vcov(mod))
  mu <- betas%*%t(X)
  pred.y <- mod$family$linkinv(mu)
#  pred.y <- 1/(1+exp(-mu))
  return(pred.y=pred.y)
  #  pred.y <- 1/(1+exp(-apply(mu,2,mean)))
  #  pred.hi <- 1/(1+exp(-apply(mu,2,function(x){quantile(x,.975)})))
  #  pred.lo <- 1/(1+exp(-apply(mu,2,function(x){quantile(x,.025)})))
  #  return(list(pred.y=pred.y,pred.lo=pred.lo,pred.hi=pred.hi))
}


#################################
## Relative risk
#################################

rr.100 <- function(mod,xvar,x0,x1,inter,char=F){

xrange <- c(x0,x1)
preds0 <- bglm.predict(mod,xvar=xvar,xrange=xrange,cond=list(DEMOCRACY=0),inter=inter)
preds1 <- bglm.predict(mod,xvar=xvar,xrange=xrange,cond=list(DEMOCRACY=1),inter=inter)

mn <- 1
mx <- 2
y0 <- (preds0$pred.y[mx]/preds0$pred.y[mn]-1)*100
y0hi <- (preds0$pred.hi[mx]/preds0$pred.hi[mn]-1)*100
y0lo <- (preds0$pred.lo[mx]/preds0$pred.lo[mn]-1)*100

y1 <- (preds1$pred.y[mx]/preds1$pred.y[mn]-1)*100
y1hi <- (preds1$pred.hi[mx]/preds1$pred.hi[mn]-1)*100
y1lo <- (preds1$pred.lo[mx]/preds1$pred.lo[mn]-1)*100

out <- ifelse(rep(char==F,2),list(Democracy=c(round(y1,2),round(y1lo,2),round(y1hi,2)), NonDemocracy=c(round(y0,2),round(y0lo,2),round(y0hi,2))),list(Democracy=paste(round(y1,2),"% (",round(y1lo,2),"%, ",round(y1hi,2),"%)",sep=""), NonDemocracy=paste(round(y0,2),"% (",round(y0lo,2),"%, ",round(y0hi,2),"%)",sep="")))
names(out) <- c("Democracy","NonDemocracy")
return(out)
}


#################################
## Relative risk (more conservative CIs)
#################################

rr.100.2 <- function(mod,xvar,x0,x1,inter,char=F){

xrange <- c(x0,x1)
preds0 <- bglm.predict2(mod,xvar=xvar,xrange=xrange,cond=list(DEMOCRACY=0),inter=inter)
preds1 <- bglm.predict2(mod,xvar=xvar,xrange=xrange,cond=list(DEMOCRACY=1),inter=inter)
preds0
mn <- 1
mx <- 2

nu <- rnorm(n=1000,mean=preds0$pred.y[mn],sd=preds0$pred.se[mn])
preds00 <- 1/(1+exp(-nu))
nu <- rnorm(n=1000,mean=preds0$pred.y[mx],sd=preds0$pred.se[mx])
preds01 <- 1/(1+exp(-nu))

y0 <- mean((preds01/preds00-1)*100)
y0hi <- quantile((preds01/preds00-1)*100,.975)
y0lo <- quantile((preds01/preds00-1)*100,.025)

nu <- rnorm(n=1000,mean=preds1$pred.y[mn],sd=preds1$pred.se[mn])
preds10 <- 1/(1+exp(-nu))
nu <- rnorm(n=1000,mean=preds1$pred.y[mx],sd=preds1$pred.se[mx])
preds11 <- 1/(1+exp(-nu))

y1 <- mean((preds11/preds10-1)*100)
y1hi <- quantile((preds11/preds10-1)*100,.975)
y1lo <- quantile((preds11/preds10-1)*100,.025)

out <- ifelse(rep(char==F,2),list(Democracy=c(round(y1,2),round(y1lo,2),round(y1hi,2)), NonDemocracy=c(round(y0,2),round(y0lo,2),round(y0hi,2))),list(Democracy=paste(round(y1,2),"% (",round(y1lo,2),"%, ",round(y1hi,2),"%)",sep=""), NonDemocracy=paste(round(y0,2),"% (",round(y0lo,2),"%, ",round(y0hi,2),"%)",sep="")))
names(out) <- c("Democracy","NonDemocracy")
return(out)
}





#################################
## Relative risk (more conservative CIs) NATO
#################################

rr.100.3 <- function(mod,xvar,x0,x1,inter,char=F){
  
  xrange <- c(x0,x1)
  preds0 <- bglm.predict2(mod,xvar=xvar,xrange=xrange,cond=list(NATO=0),inter=inter)
  preds1 <- bglm.predict2(mod,xvar=xvar,xrange=xrange,cond=list(NATO=1),inter=inter)
  preds0
  mn <- 1
  mx <- 2
  
  nu <- rnorm(n=1000,mean=preds0$pred.y[mn],sd=preds0$pred.se[mn])
  preds00 <- 1/(1+exp(-nu))
  nu <- rnorm(n=1000,mean=preds0$pred.y[mx],sd=preds0$pred.se[mx])
  preds01 <- 1/(1+exp(-nu))
  
  y0 <- mean((preds01/preds00-1)*100)
  y0hi <- quantile((preds01/preds00-1)*100,.975)
  y0lo <- quantile((preds01/preds00-1)*100,.025)
  
  nu <- rnorm(n=1000,mean=preds1$pred.y[mn],sd=preds1$pred.se[mn])
  preds10 <- 1/(1+exp(-nu))
  nu <- rnorm(n=1000,mean=preds1$pred.y[mx],sd=preds1$pred.se[mx])
  preds11 <- 1/(1+exp(-nu))
  
  y1 <- mean((preds11/preds10-1)*100)
  y1hi <- quantile((preds11/preds10-1)*100,.975)
  y1lo <- quantile((preds11/preds10-1)*100,.025)
  
  out <- ifelse(rep(char==F,2),list(NATO=c(round(y1,2),round(y1lo,2),round(y1hi,2)), NonNATO=c(round(y0,2),round(y0lo,2),round(y0hi,2))),list(NATO=paste(round(y1,2),"% (",round(y1lo,2),"%, ",round(y1hi,2),"%)",sep=""), NonNATO=paste(round(y0,2),"% (",round(y0lo,2),"%, ",round(y0hi,2),"%)",sep="")))
  names(out) <- c("NATO","NonNATO")
  return(out)
}




#################################
## Relative risk (more conservative CIs) PARTICIPATE
#################################

rr.100.4 <- function(mod,xvar,x0,x1,inter,char=F){
  
  xrange <- c(x0,x1)
  preds0 <- bglm.predict2(mod,xvar=xvar,xrange=xrange,cond=list(PARTICIPATE=0),inter=inter)
  preds1 <- bglm.predict2(mod,xvar=xvar,xrange=xrange,cond=list(PARTICIPATE=1),inter=inter)
  preds0
  mn <- 1
  mx <- 2
  
  nu <- rnorm(n=1000,mean=preds0$pred.y[mn],sd=preds0$pred.se[mn])
  preds00 <- 1/(1+exp(-nu))
  nu <- rnorm(n=1000,mean=preds0$pred.y[mx],sd=preds0$pred.se[mx])
  preds01 <- 1/(1+exp(-nu))
  
  y0 <- mean((preds01/preds00-1)*100)
  y0hi <- quantile((preds01/preds00-1)*100,.975)
  y0lo <- quantile((preds01/preds00-1)*100,.025)
  
  nu <- rnorm(n=1000,mean=preds1$pred.y[mn],sd=preds1$pred.se[mn])
  preds10 <- 1/(1+exp(-nu))
  nu <- rnorm(n=1000,mean=preds1$pred.y[mx],sd=preds1$pred.se[mx])
  preds11 <- 1/(1+exp(-nu))
  
  y1 <- mean((preds11/preds10-1)*100)
  y1hi <- quantile((preds11/preds10-1)*100,.975)
  y1lo <- quantile((preds11/preds10-1)*100,.025)
  
  out <- ifelse(rep(char==F,2),list(NATO=c(round(y1,2),round(y1lo,2),round(y1hi,2)), NonNATO=c(round(y0,2),round(y0lo,2),round(y0hi,2))),list(NATO=paste(round(y1,2),"% (",round(y1lo,2),"%, ",round(y1hi,2),"%)",sep=""), NonNATO=paste(round(y0,2),"% (",round(y0lo,2),"%, ",round(y0hi,2),"%)",sep="")))
  names(out) <- c("PARTICIPATE","NonPARTICIPATE")
  return(out)
}




#################################
## Relative risk (general)
#################################



rr.100.X <- function(mod,xvar,x0,x1,conds=NULL,inter,char=F){
  xrange <- c(x0,x1)
  preds0 <- glm.predict.mvn(mod,xvar=xvar,xrange=xrange,cond=conds[1],inter=inter)
  preds1 <- glm.predict.mvn(mod,xvar=xvar,xrange=xrange,cond=conds[2],inter=inter)
  rrs <- (preds0[,2]/preds0[,1]-1)*100
  y0 <- mean(rrs)
  y0hi <- quantile(rrs,.975)
  y0lo <- quantile(rrs,.025)
  rrs <- (preds1[,2]/preds1[,1]-1)*100
  y1 <- mean(rrs)
  y1hi <- quantile(rrs,.975)
  y1lo <- quantile(rrs,.025)
  l1. <- list(c(round(y1,2),round(y1lo,2),round(y1hi,2)), c(round(y0,2),round(y0lo,2),round(y0hi,2)))
  l2. <- list(paste(round(y1,2),"% (",round(y1lo,2),"%, ",round(y1hi,2),"%)",sep=""),paste(round(y0,2),"% (",round(y0lo,2),"%, ",round(y0hi,2),"%)",sep=""))
  names(l1.) <- c(names(conds)[1],paste("Non",names(conds)[2],sep=""))
  names(l2.) <- c(names(conds)[1],paste("Non",names(conds)[2],sep=""))
  out <- ifelse(rep(char==F,2),l1.,l2.)
  names(out) <- c(names(conds)[1],paste("Non",names(conds)[2],sep=""))
  return(out)
}


##############################################
## Outreg
##############################################

outreg2 <- function(modlist,rnd){

nrs <- c()
for(j in 1:length(modlist)){nrs <- c(nrs,rownames(summary(modlist[[j]])$estimate))}
nrs <- unique(nrs)
coeflist <- vector("list", length(nrs))
names(coeflist) <- nrs
for(i in 1:length(coeflist)){coeflist[i] <- list(matrix("",2,length(modlist)))}

for(j in 1:length(modlist)){
coefs <- round(summary(modlist[[j]])$estimate,rnd)[,1]
ses <- round(summary(modlist[[j]])$estimate,rnd)[,2]
ps <- round(summary(modlist[[j]])$estimate,rnd)[,4]
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
}
coefmat <- do.call(rbind,coeflist)
vnames <- matrix(NA,nrow=2*length(nrs),1)
vnames[is.odd(1:nrow(vnames))] <- names(coeflist)
vnames[!is.odd(1:nrow(vnames))] <- ""
coefmat <- as.data.frame(cbind(vnames,coefmat))
names(coefmat) <- c("Variable",names(modlist))
rownames(coefmat) <- NULL


moddiag <- as.data.frame(matrix(NA,3,1+length(modlist)))
names(moddiag) <- names(coefmat)
moddiag[,1] <- c("N","logLik","AIC")

for(j in 1:length(modlist)){
k <- summary(modlist[[j]])$NActivePar
ll <- summary(modlist[[j]])$loglik[[1]]
N <- nrow(modlist[[j]]$model)
aic <- 2*k-2*ll
moddiag[1,j+1] <- as.character(as.integer(N))
moddiag[2,j+1] <- as.character(round(ll,2))
moddiag[3,j+1] <- as.character(round(aic,2))}

out <- rbind(coefmat,moddiag)
return(out)
}

#############################


outreg3 <- function(modlist,rnd){


nrs <- c()
for(j in 1:length(modlist)){nrs <- c(nrs,rownames(attr(summary(modlist[[j]]),"coef")))}
nrs <- unique(nrs)
coeflist <- vector("list", length(nrs))
names(coeflist) <- nrs
for(i in 1:length(coeflist)){coeflist[i] <- list(matrix("",2,length(modlist)))}
for(j in 1:length(modlist)){	
if(class(modlist[[j]])[1]=="mer"){
coefs. <- attr(summary(modlist[[j]]),"coef")
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
}
if(class(modlist[[j]])[1]=="glm"){
coefs. <- summary(modlist[[j]])$coefficients
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
}
}

coefmat <- do.call(rbind,coeflist)
vnames <- matrix(NA,nrow=2*length(nrs),1)
vnames[is.odd(1:nrow(vnames))] <- names(coeflist)
vnames[!is.odd(1:nrow(vnames))] <- ""
coefmat <- as.data.frame(cbind(vnames,coefmat))
names(coefmat) <- c("Variable",names(modlist))
rownames(coefmat) <- NULL
moddiag <- as.data.frame(matrix(NA,4,1+length(modlist)))
names(moddiag) <- names(coefmat)
moddiag[,1] <- c("CCODE","TID","N","AIC")

for(j in 1:length(modlist)){
if(class(modlist[[j]])[1]=="mer"){
remat <- attr(summary(modlist[[j]]),"REmat")
if(nrow(remat)==1){
moddiag[moddiag[,1]=="CCODE",j+1] <- as.character(ifelse(remat[1]=="CCODE",round(as.numeric(remat[,"Variance"]),rnd),""))
moddiag[moddiag[,1]=="TID",j+1] <- as.character(ifelse(remat[1]=="TID",round(as.numeric(remat[,"Variance"]),rnd),""))
}
if(nrow(remat)==2){
moddiag[moddiag[,1]=="CCODE",j+1] <- as.character(round(as.numeric(remat[remat[,1]=="CCODE","Variance"]),rnd))
moddiag[moddiag[,1]=="TID",j+1] <- as.character(round(as.numeric(remat[remat[,1]=="TID","Variance"]),rnd))}
moddiag[moddiag[,1]=="N",j+1] <- as.character(nrow(attr(summary(modlist[[j]]),"X")))
moddiag[moddiag[,1]=="AIC",j+1] <- as.character(round(attr(summary(modlist[[j]]),"AICtab")$AIC,2))
}
if(class(modlist[[j]])[1]=="glm"){
moddiag[moddiag[,1]=="CCODE",j+1] <- ""
moddiag[moddiag[,1]=="TID",j+1] <- ""
moddiag[moddiag[,1]=="N",j+1] <- nrow(modlist[[j]]$model)
moddiag[moddiag[,1]=="AIC",j+1] <- round(summary(modlist[[j]])$aic,2)
}
}
out <- rbind(coefmat,moddiag)
return(out)
}


#############################




outreg3alt <- function(modlist,rnd,cid=NULL,tid=NULL){


nrs <- c()
for(j in 1:length(modlist)){nrs <- c(nrs,rownames(summary(modlist[[j]])$coefficients))}
nrs <- unique(nrs)
coeflist <- vector("list", length(nrs))
names(coeflist) <- nrs
for(i in 1:length(coeflist)){coeflist[i] <- list(matrix("",2,length(modlist)))}
for(j in 1:length(modlist)){	
if(class(modlist[[j]])[1]=="glmerMod"){
coefs. <- summary(modlist[[j]])$coefficients
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
}
if(class(modlist[[j]])[1]=="glm"){
coefs. <- summary(modlist[[j]])$coefficients
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
}
}

coefmat <- do.call(rbind,coeflist)
vnames <- matrix(NA,nrow=2*length(nrs),1)
vnames[is.odd(1:nrow(vnames))] <- names(coeflist)
vnames[!is.odd(1:nrow(vnames))] <- ""
coefmat <- as.data.frame(cbind(vnames,coefmat))
names(coefmat) <- c("Variable",names(modlist))
rownames(coefmat) <- NULL
moddiag <- as.data.frame(matrix(NA,4,1+length(modlist)))
names(moddiag) <- names(coefmat)
moddiag[,1] <- c(cid,tid,"N","AIC")



for(j in 1:length(modlist)){
if(class(modlist[[j]])[1]=="glmerMod"){
remat <- summary(modlist[[j]])$varcor
if(length(remat)==1){
moddiag[moddiag[,1]==cid,j+1] <- as.character(ifelse(names(remat[1])==cid,round(as.numeric(summary(modlist[[j]])$varcor[[cid]][[1]]),rnd),""))
moddiag[moddiag[,1]==tid,j+1] <- as.character(ifelse(names(remat[1])==tid,round(as.numeric(summary(modlist[[j]])$varcor[[tid]][[1]]),rnd),""))
}
if(length(remat)==2){
moddiag[moddiag[,1]==cid,j+1] <- as.character(round(as.numeric(summary(modlist[[j]])$varcor[[cid]][[1]]),rnd))
moddiag[moddiag[,1]==tid,j+1] <- as.character(round(as.numeric(summary(modlist[[j]])$varcor[[tid]][[1]]),rnd))
}
moddiag[moddiag[,1]=="N",j+1] <- summary(modlist[[j]])$devcomp$dims["N"]
moddiag[moddiag[,1]=="AIC",j+1] <- round(summary(modlist[[j]])$AICtab["AIC"],2)
}
if(class(modlist[[j]])[1]=="glm"){
moddiag[moddiag[,1]==cid,j+1] <- ""
moddiag[moddiag[,1]==tid,j+1] <- ""
moddiag[moddiag[,1]=="N",j+1] <- nrow(modlist[[j]]$model)
moddiag[moddiag[,1]=="AIC",j+1] <- round(summary(modlist[[j]])$aic,2)
}
}
out <- rbind(coefmat,moddiag)
return(out)
}

#############################



outreg_beta <- function(modlist,rnd,cid=NULL,tid=NULL){


nrs <- c()
for(j in 1:length(modlist)){
	if(class(modlist[[j]])=="betareg"){ 
	nrs <- c(nrs,rownames(summary(modlist[[j]])$coefficients$mean))}
	if(class(modlist[[j]])=="glm"){ 
	nrs <- c(nrs,rownames(summary(modlist[[j]])$coefficients))}
nrs <- unique(nrs)}
coeflist <- vector("list", length(nrs))
names(coeflist) <- nrs
for(i in 1:length(coeflist)){coeflist[i] <- list(matrix("",2,length(modlist)))}
preclist <- vector("list", 1)
names(preclist) <- "Phi"
for(i in 1:length(preclist)){preclist[i] <- list(matrix("",2,length(modlist)))}


for(j in 1:length(modlist)){	
if(class(modlist[[j]])[1]=="betareg"){
coefs. <- summary(modlist[[j]])$coefficients$mean
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))
coefs.2 <- summary(modlist[[j]])$coefficients$precision
coefs2 <- round(coefs.2[,1],rnd)
ses2 <- round(coefs.2[,2],rnd)
ps2 <- round(coefs.2[,4],rnd)
ps2 <- ifelse(ps2<.001,"***",ifelse(ps2<.001,"***",ifelse(ps2<.01,"**",ifelse(ps2<.05,"*",ifelse(ps2<.1,"'","")))))
nrs2 <- "Phi"
for(i in 1:length(nrs2)){
preclist[nrs2[i]][[1]][,j] <- rbind(coefs2,paste("(",ses2,")",ps2,sep=""))
}
}
if(class(modlist[[j]])[1]=="glm"){
coefs. <- summary(modlist[[j]])$coefficients
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
preclist[nrs2[i]][[1]][,j] <- rbind("","")
}
}
}

coeflist <- c(coeflist,preclist)
coefmat <- do.call(rbind,coeflist)
vnames <- matrix(NA,nrow=2*length(coeflist),1)
vnames[is.odd(1:nrow(vnames))] <- names(coeflist)
vnames[!is.odd(1:nrow(vnames))] <- ""
coefmat <- as.data.frame(cbind(vnames,coefmat))
names(coefmat) <- c("Variable",names(modlist))
rownames(coefmat) <- NULL
moddiag <- as.data.frame(matrix(NA,2,1+length(modlist)))
names(moddiag) <- names(coefmat)
moddiag[,1] <- c("N","AIC")



for(j in 1:length(modlist)){
if(class(modlist[[j]])[1]=="betareg"){
moddiag[moddiag[,1]=="N",j+1] <- as.character(modlist[[j]]$n)
moddiag[moddiag[,1]=="AIC",j+1] <- round(2*(modlist[[j]]$df.null-modlist[[j]]$df.residual)-2*modlist[[j]]$loglik,2)
}
if(class(modlist[[j]])[1]=="glm"){
moddiag[moddiag[,1]=="N",j+1] <- nrow(modlist[[j]]$model)
moddiag[moddiag[,1]=="AIC",j+1] <- round(summary(modlist[[j]])$aic,2)
}
}
out <- rbind(coefmat,moddiag)
return(out)
}



###########################

outreg4 <- function(modlist,rnd){

nrs <- c()
for(j in 1:length(modlist)){nrs <- c(nrs,rownames(attr(summary(modlist[[j]]),"coef")))}
nrs <- unique(nrs)
coeflist <- vector("list", length(nrs))
names(coeflist) <- nrs
for(i in 1:length(coeflist)){coeflist[i] <- list(matrix("",2,length(modlist)))}
for(j in 1:length(modlist)){	
if(class(modlist[[j]])[1]=="mer"){
coefs. <- attr(summary(modlist[[j]]),"coef")
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
}
if(class(modlist[[j]])[1]=="glm"){
coefs. <- summary(modlist[[j]])$coefficients
coefs <- round(coefs.[,1],rnd)
ses <- round(coefs.[,2],rnd)
ps <- round(coefs.[,4],rnd)
ps <- ifelse(ps<.001,"***",ifelse(ps<.001,"***",ifelse(ps<.01,"**",ifelse(ps<.05,"*",ifelse(ps<.1,"'","")))))
nrs1 <- names(coefs)
for(i in 1:length(nrs1)){
coeflist[nrs1[i]][[1]][,j] <- rbind(coefs[nrs1[i]],paste("(",ses[nrs1[i]],")",ps[nrs1[i]],sep=""))}
}
}

coefmat <- do.call(rbind,coeflist)
vnames <- matrix(NA,nrow=2*length(nrs),1)
vnames[is.odd(1:nrow(vnames))] <- names(coeflist)
vnames[!is.odd(1:nrow(vnames))] <- ""
coefmat <- as.data.frame(cbind(vnames,coefmat))
names(coefmat) <- c("Variable",names(modlist))
rownames(coefmat) <- NULL
moddiag <- as.data.frame(matrix(NA,4,1+length(modlist)))
names(moddiag) <- names(coefmat)
moddiag[,1] <- c("SID","TID","N","AIC")

for(j in 1:length(modlist)){
if(class(modlist[[j]])[1]=="mer"){
remat <- attr(summary(modlist[[j]]),"REmat")
if(nrow(remat)==1){
moddiag[moddiag[,1]=="SID",j+1] <- as.character(ifelse(remat[1]=="SID",round(as.numeric(remat[,"Variance"]),rnd),""))
moddiag[moddiag[,1]=="TID",j+1] <- as.character(ifelse(remat[1]=="TID",round(as.numeric(remat[,"Variance"]),rnd),""))
}
if(nrow(remat)==2){
moddiag[moddiag[,1]=="SID",j+1] <- as.character(round(as.numeric(remat[remat[,1]=="SID","Variance"]),rnd))
moddiag[moddiag[,1]=="TID",j+1] <- as.character(round(as.numeric(remat[remat[,1]=="TID","Variance"]),rnd))}
moddiag[moddiag[,1]=="N",j+1] <- as.character(nrow(attr(summary(modlist[[j]]),"X")))
moddiag[moddiag[,1]=="AIC",j+1] <- as.character(round(attr(summary(modlist[[j]]),"AICtab")$AIC,2))
}
if(class(modlist[[j]])[1]=="glm"){
moddiag[moddiag[,1]=="SID",j+1] <- ""
moddiag[moddiag[,1]=="TID",j+1] <- ""
moddiag[moddiag[,1]=="N",j+1] <- nrow(modlist[[j]]$model)
moddiag[moddiag[,1]=="AIC",j+1] <- round(summary(modlist[[j]])$aic,2)
}
}
out <- rbind(coefmat,moddiag)
return(out)
}






#############################
## Custom palette function ## 
#############################

custom.palette <- function(var,col.vec,n.color=5,choose=F,style="pretty",fixedBreaks){
	
col.ramp <- colorRampPalette(col.vec, space = "rgb")


library(classInt)

# Create palette with n color classes
pal <- col.ramp(n=n.color) 

## (1) Show options
if(choose==T){
#classes_fx <- classIntervals(var, n=n.color, style="fixed", fixedBreaks=pretty(var,min.n=3,n=n.color), rtimes = 1)
classes_pr<-classIntervals(var,n=n.color,style="pretty",rtimes=1)
classes_sd<-classIntervals(var,n=n.color,style="sd",rtimes=1)
classes_fi<-classIntervals(var,n=n.color,style="fisher",rtimes=3)
classes_eq<-classIntervals(var,n=n.color,style="equal",rtimes=1)
classes_km<-classIntervals(var,n=n.color,style="kmeans",rtimes=1)
classes_qt<-classIntervals(var,n=n.color,style="quantile",rtimes=1)
classes_hc<-classIntervals(var,n=n.color,style="hclust",rtimes=1)
classes_bc<-classIntervals(var,n=n.color,style="bclust",rtimes=1)

par(mar=c(2,2,2,1)+0.1, mfrow=c(2,4))
#plot(classes_fx, pal=pal, main="Fixed Intervals", xlab="", ylab="")
plot(classes_pr, pal=pal, main="pretty", xlab="", ylab="")
plot(classes_sd, pal=pal, main="sd", xlab="", ylab="")
plot(classes_fi, pal=pal, main="fisher (jenks)", xlab="", ylab="")
plot(classes_km, pal=pal, main="kmeans", xlab="", ylab="")
plot(classes_eq, pal=pal, main="equal", xlab="", ylab="")
plot(classes_qt, pal=pal, main="quantile", xlab="", ylab="")
plot(classes_hc, pal=pal, main="hclust", xlab="", ylab="")
plot(classes_bc, pal=pal, main="bclust", xlab="", ylab="")
}

## (2) Create cupoints
if(choose==F){
	
## Define intervals
classes<-classIntervals(var,n=n.color,style=style,rtimes=1)
if(style=="fixed"){classes <- classIntervals(var, n=n.color, style="fixed", fixedBreaks=fixedBreaks, rtimes = 1)}

## Create vector of colors
cols <- findColours(classes, pal)
return(cols)	
}
}


####################################
## round.intervals                ## 
####################################


round.intervals <- function(cols,rnd){
labs <- names(attr(cols, "table"))
labs <- gsub("[","",labs,perl=F,fixed=T)
labs <- gsub("]","",labs,perl=F,fixed=T)
labs <- gsub("(","",labs,perl=F,fixed=T)
labs <- gsub(")","",labs,perl=F,fixed=T)
labs <- strsplit(labs,",")
labs <- round(as.numeric(unlist(labs)),rnd)
nn <- length(labs)/2
labs. <- list()
for(i in 1:nn){
	labs.[[i]] <- labs[c(2*i-1,2*i)]
	labs.[[i]] <- paste("[",paste(labs.[[i]],collapse=", "),")",sep="")
}
labs.[[length(labs.)]] <- gsub(")","]",labs.[[length(labs.)]],fixed=T)
labs. <- unlist(labs.)
return(labs.)}

