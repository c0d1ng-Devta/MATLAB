
clc;
clear;
% close all;


% Position Control of Chaser using HCW equations.
% n=ureal('n',2*pi/(24*3600),'percent',2);%Data is of Geosynchronous Satellite
%% Constants and Data
n=2*pi/(24*3600);
t = 0:0.04:20;

%% A,B,C,D Matrices of State space model.
% A=[0 0 0 1 0 0; 0 0 0 0 1 0;0 0 0 0 0 1;0 0 0 0 0 -2*n ; 0 -n*n 0 0 0 0;0 0 3*n*n 2*n 0 0];
A=[0 0 0 1 0 0; 0 0 0 0 1 0;0 0 0 0 0 1;3*n*n 0 0 0 2*n 0;0 0 0 -2*n 0 0;0 0 -n*n 0 0 0];  %x and y in plane and z out of plan.
B=[0 0 0; 0 0 0; 0 0 0;1 0 0; 0 1 0; 0 0 1];
C_Nbar=[1 0 0 0 0 0 ;0 1 0 0 0 0; 0 0 1 0 0 0];
C=eye(6);
D=0;

%% Reference State and Intial State.
u=[-100*zeros(size(t));zeros(size(t));zeros(size(t))];
init=[0;0;1000;0;-1;0];

%ref=[-100;0;0;0;0;0];%First Hold Point.

%% Applying LQR Algorithm to get best k for Full State Feedback.
Q=0.1*(C'*C);
R=eye(3);
k=lqr(A,B,Q,R);

%% Creating State Space Model without State Feedback 
State=ss(A,B,C,D,'InputName',{'ax','ay','az'},'OutputName'...
    ,{'y'},'StateName',{'x','y','z','x*','y*','z*'});

%% Creating State Space Model with Full State Feedback
 Nbar=-(inv(C_Nbar*inv(A-B*k)*B));
 State1=ss(A-B*k,B*Nbar,C,D,'InputName',{'ax','ay','az'},'OutputName'...
    ,{'y'},'StateName',{'x','y','z','x*','y*','z*'});
% opt=robOptions('Display','on','Sensitivity','on');
% [StabilityMargin,wcu]=robstab(State1,opt);
figure(8)
step(State1,t)
y1=lsim(State1,u,t,init);%Getting the Values from Linear Approximation.

% set(findall(gcf,'type','line'),'linewidth',3);
%% Plotting the linear Simulation 

figure (9)

subplot(2,1,1)
plot(t,y1(:,1),'-k')
hold on
plot(t,y1(:,2),'-b')
plot(t,y1(:,3),'-r')
title('Distance')
hold off

subplot(2,1,2)
plot(t,y1(:,4),'-y')
hold on
plot(t,y1(:,5),'-c')
plot(t,y1(:,6),'-g')
title('Velocity ')
hold off

%% Making Robust
% %Weights
% Wa1=ss(1);
% Wa2=ss(2);
% wa3=ss(1);
% Wsv1=ss(1);
% Wsv2=ss(1);
% Wsv3=ss(1);
% Wsv4=ss(1);
% Wsv5=ss(1);
% Wsv6=ss(1);
% Wext=ss(0.11);
% 
% Wext.u='d';
% Wext.y='r';
% Wa1.u='u1';
% Wa1.y='e1';
% Wa2.u='u2';
% Wa2.y='e2';
% Wa3.u='u3';
% Wa3.y='e3';
% Wsv1.u='x';
% Wsv1.y='e4';
% Wsv2.y='e5';
% Wsv3.y='e6';
% Wsv4.y='e7';
% Wsv5.y='e8';
% Wsv6.y='e9';
% Wsv2.u='y';
% Wsv3.u='z';
% Wsv4.u='x.';
% Wsv5.u='y.';
% Wsv6.u='x.';
% 
% ICinputs={'d','u1','u2','u3'};
% ICoutputs={'e1','e2','e3','e4','e5','e6'};
% pos1=sumblk('y1=x');
% pos2=sumblk('y1=y');
% pos3=sumblk('y1=z');
% pos4=sumblk('y1=x.');
% pos5=sumblk('y1=y.');
% pos6=sumblk('y1=z.');
% satic=connect(State,Wext,Wa1,Wa2,Wa3,Wsv1,Wsv2,Wsv3,Wsv4,Wsv5,Wsv6,...
%     ICinputs,ICoutputs);
% 
% ncont=3;
% nmea=6;
% K=ss(zeros(ncont,nmea,3));
% gamma=zeros(3,1);
% for i=1:3
%     [K(:,:,i),~,gamma(i)]=hinfsyn(satic(:,:,i),nmea,ncont);
% end


