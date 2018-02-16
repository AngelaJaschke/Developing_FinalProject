#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
library(caret)

# Define server logic 
shinyServer(function(input, output) {

        # Train model
        all<-rbind(Pima.tr,Pima.te)
        all$type<-as.character(all$type)
        all$type[all$type=="Yes"]<-TRUE
        all$type[all$type=="No"]<-FALSE
        all$type<-as.factor(all$type)
        
        model <- train(type~., method='glm', data=all)
        
        prob<-reactive({
                pr<-predict(model,newdata=data.frame(npreg=input$npreg,glu=input$glu,bp=input$bp,skin=input$skin,bmi=input$bmi,ped=input$ped,age=input$age),type="prob")
                return(pr[1,2])
        })

        
        output$prob<-renderText({
                prob()
        })
        
        output$pick<-renderText({
                paste("Effect of ", input$variable, ":")
        })
        
        # Make multiple predictions for selected variable changed:
        output$plot<-renderPlot({
                varvar<-data.frame(npreg=input$npreg,glu=input$glu,bp=input$bp,skin=input$skin,bmi=input$bmi,ped=input$ped,age=input$age)
                tmp<-varvar
                pts<-50
                for(i in 1:(pts-1)){
                        varvar<-rbind(varvar,tmp)
                }
                intervals<-function(a,b){
                        step<-(b-a)/(pts-1)
                        
                        c<-a
                        for(i in 1:(pts-1)){
                                c<-cbind(c,(c[i]+step))
                        }
                        return(c)
                }
                
                
                if(input$variable=="npreg"){
                        varvar$npreg<-replace(varvar$npreg,list=1:pts,values=intervals(0,18))
                        xid=1
                        inx<-input$npreg
                }
                if(input$variable=="glu"){
                        varvar$glu<-replace(varvar$glu,list=1:pts,values=intervals(50,200))
                        xid=2
                        inx<-input$glu
                }
                if(input$variable=="bp"){
                        varvar$bp<-replace(varvar$bp,list=1:pts,values=intervals(24,110))
                        xid=3
                        inx<-input$bp
                }
                if(input$variable=="skin"){
                        varvar$skin<-replace(varvar$skin,list=1:pts,values=intervals(7,100))
                        xid=4
                        inx<-input$skin
                }
                if(input$variable=="bmi"){
                        varvar$bmi<-replace(varvar$bmi,list=1:pts,values=intervals(15,68))
                        xid=5
                        inx<-input$bmi
                }
                if(input$variable=="ped"){
                        varvar$ped<-replace(varvar$ped,list=1:pts,values=intervals(0.05,2.5))
                        xid=6
                        inx<-input$ped
                }
                if(input$variable=="age"){
                        varvar$age<-replace(varvar$age,list=1:pts,values=intervals(15,100))
                        xid=7
                        inx<-input$age
                }
                
                preds<-predict(model,newdata=varvar,type="prob")
                var<-input$variable
                plot(x=varvar[,xid],y=preds[,2],ylab="Probability",xlab=input$variable,pch=19,ylim=c(0,1))
                points(x=inx,y=prob(),pch=15,col="red")
        })


  
})
