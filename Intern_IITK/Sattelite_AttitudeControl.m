
clc;

% Time
t=0:.3:20;


% Moments of Inertia
Ixx=15;
Iyy=14.5;
Izz=6;
Ixz=0;
Izx=0;
Ixy=0;
Iyx=0;
Iyz=0;
Izy=0;

% Controller Constants
Kp=eye(3);
Kpd=eye(3);% C 
Ky=[Kp Kpd];

% Initial Quaternions
% q1=-0.4;
% q2=0.2;CL
% q3=0.8;
% q4=0.4;

% Initial Omegas
w1=0;
w2=20;
w3=0;

init=[-0.4;.2;.8;0;0;0];
u=[zeros(size(t));sin(pi*t/32);zeros(size(t))];

Angular_Velocity=[w1; w2 ;w3];
Inertia=[Ixx Ixy Ixz; Iyx Iyy Iyz ;Izx Izy Izz];
Aww_1=[w2*Izx-w3*Iyx; -2*Izx*w1-Izy*w2-w3*Izz+w3*Ixx; Iyx*w1+w2*Iyy+Iyz*w3-w2*Ixx];
Aww_2=[Izx*w1+2*Izy*w2+w3*Izz-w3*Iyy; w3*Ixy-w1*Izy; -w1*Ixx-2*Ixy*w2-Ixz*w3+w1*Iyy];
Aww_3=[-Iyx*w1-w2*Iyy-2*Iyz*w3+w2*Izz; w1*Ixx+Ixy*w2+2*Ixz*w3-w1*Izz; w1*Iyz-w2*Ixz];
Aww=[Aww_1 Aww_2 Aww_3];
Awh=[0 w3 -w2;-w3 0 w1;w2 -w1 0];

A=[inv(Inertia)*Aww inv(Inertia)*Awh;...
   0.5*eye(3) zeros(3,3)];
B=[inv(Inertia);-eye(3)];
C=eye(6);
D=0;

% Wbw=0.2;
% Kp=[Ixx*Wbw*Wbw 0 0; 0 Iyy*Wbw*Wbw 0; 0 0 Izz*Wbw*Wbw];
% Kpd=Inertia*2*Wbw;
% k=[Kpd Kp];

Q=0.1*(C'*C);
R=eye(3);
k=lqr(A,B,Q,R)

Ac=A-B*k*C;
Bc=B*Kp;
Cc=[C];
Dc=[D];

 State=ss(A,B,C,D,'InputName',{'ax','ay','az'},'OutputName'...
    ,{'y'},'StateName',{'q1','q2','q3','x*','t','ggg'});
figure(9);

% Ixx=ureal('Ixx',15,'percent',2);
% Iyy=ureal('Iyy',14.5,'percent',4);
% Izz=ureal('Ixx',6,'percent',7);
% 
% Aww_11=[w2*Izx-w3*Iyx; -2*Izx*w1-Izy*w2-w3*Izz+w3*Ixx; Iyx*w1+w2*Iyy+Iyz*w3-w2*Ixx];
% Aww_21=[Izx*w1+2*Izy*w2+w3*Izz-w3*Iyy; w3*Ixy-w1*Izy; -w1*Ixx-2*Ixy*w2-Ixz*w3+w1*Iyy];
% Aww_31=[-Iyx*w1-w2*Iyy-2*Iyz*w3+w2*Izz; w1*Ixx+Ixy*w2+2*Ixz*w3-w1*Izz; w1*Iyz-w2*Ixz];
% Aww=[Aww_11 Aww_21 Aww_31];
% Awh=[0 w3 -w2;-w3 0 w1;w2 -w1 0];
% 
% A=[inv(Inertia)*Aww inv(Inertia)*Awh;...
%    0.5*eye(3) zeros(3,3)];
% Ac=A-B*k*C;
% Bc=B*Kp;
% Cc=[C];
% Dc=[D];


State1=ss(Ac,Bc,Cc,Dc,'InputName',{'ax','ay','az'},'OutputName'...
    ,{'y'},'StateName',{'q1','q2','q3','wx','wy','wz'});

 opt=robOptions('Display','on','Sensitivity','on');
[StabilityMargin,wcu]=robstab(State1,opt);
 lsim(State1,u,t,init);
set(findall(gcf,'type','line'),'linewidth',3);



W1 = makeweight(33,5,0.5);
W3 = makeweight(0.5,20,20);
figure(8);
bodemag(W1,W3)

grid on

ncont = 3; 
nmeas = 6;
W2 = [];
P = augw(State,W1,W2,W3);

% figure(6);
% lsim(usample(P,100),'b',P,t)
% title('Nominal "balanced" design')

[K,~,gamma] = mixsyn(State,W1,W2,W3);
[K1,CL,gam] = hinfsyn(P,nmeas,ncont);
% [Krob,rpMU] = musyn(State,nmeas,ncont);






