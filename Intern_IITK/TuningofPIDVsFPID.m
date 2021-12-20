function TuningofPIDVsFPID()
clc;
clear all;
close all;
warning off all;
addpath(genpath(pwd));

id=2;  % 1 for pid 2 fpid
s = tf('s');       
G=1/(s*(s+1)+1)
t = (0:.01:2);
flag='b';

   if(id==2)% Fractional
       Kp=1;
       Ki=1;
       Kd=1;
       lamda=1;
       mu=1;
       [C,CTRLTYPE] = fracpid(Kp, Ki, lamda, Kd, mu)
       T = feedback(C*G,1)
       [y,time]=step(T,t)
       stepinfo(y,time)
       numberOfVariables = 5;
       lb=[0 0 0 0 0];
       ub=[100 100 100 1 1];
%      ub=[1e-6 1 1e-6 1 1];
   else   % Normal PID
       Kp=1;
       Ki=1;
       Kd=1;
       C = pid(Kp, Ki,Kd)
       T = feedback(C*G,1)
        
       [y,time]=step(T,t)
       stepinfo(y,time)
       numberOfVariables = 3;
       lb=[0 0 0];
       ub=[100 100 100];

   end  
%% Optimization
MaxIter=100;
ik=1;
minFit=inf;
figure,
subplot(212)
xlabel('Iteration')
ylabel('Fitness')
tic
while(ik<MaxIter)
   if(id==1) 
   x=lb+(ub-lb).*rand(1,3);
   else
   x=lb+(ub-lb).*rand(1,5);    
   end
     subplot(211)
   fit=fitnessPID(x,G,t,id,flag);
   if(fit<=minFit)
       minFit=fit;
       optimalX=x;
   end
   
   minfitH(ik)=minFit;
   fitH(ik)=fit;
   subplot(212)
   semilogy(ik,minFit,'-*r')
   xlabel('Iteration')
   ylabel('Fitness')
   hold on
   plot(ik,fit,'-*b')
   
   ik=ik+1; 
   pause(0.001)
end
tp=toc
fprintf('Optimal Value\n ')
minfitH(end)
fprintf('Optimal Variable\n ')
optimalX

hold on
flag='r';
subplot(211)
fitnessPID(optimalX,G,t,id,flag)

end

function fit=fitnessPID(x,G,t,id,flag)

    if(id==1)
       Kp=x(1);Ki=x(2);Kd=x(3); 
       C = pid(Kp, Ki,Kd);
       T = feedback(C*G,1);
       [y,time]=step(T,t);
        %stepinfo(y,time)
        
      
        plot(time,y,flag)
        xlabel('PID Method')
        title(['Kp-->' num2str(Kp) ' ; ' 'Ki-->' num2str(Ki) ' ; ' 'Kd-->' num2str(Kd) ' ; '])
        
    else
       Kp=x(1);Ki=x(2);Kd=x(3);lamda=x(4);mu=x(5); 
       [C,CTRLTYPE] = fracpid(Kp, Ki, lamda, Kd, mu);
       T = feedback(C*G,1);
       [y,time]=step(T,t); 
      
       
        plot(time,y,flag)
       xlabel('FPID Method')
       title(['Kp-->' num2str(Kp) ' ; ' 'Ki-->' num2str(Ki) ' ; ' 'Kd-->' num2str(Kd) ' ; ' 'lamda-->' num2str(lamda) ' ; ' 'mu-->' num2str(mu) ' ; '])
        
        
    end
      fit=sum(abs(1-y).^2)
      
      if(flag=='r')
          stepinfo(y,time)
      end


end