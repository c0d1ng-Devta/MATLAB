function [pid_LHCW]=PID_LHCW(L_HCW,t,param_FPID)
lqr_LHCW=zeros(3601,6);
Kp=param_FPID(1);
Ki=param_FPID(2);
Kd=param_FPID(3);
lambda=param_FPID(4);
delta=param_FPID(5);


for i = (1:3601)
x=L_HCW(i,1);
y=L_HCW(i,2);
z=L_HCW(i,3);
Vx=L_HCW(i,4);
Vy=L_HCW(i,5);
Vz=L_HCW(i,6);

r=norm([x y z]);
% Omega20=(mu/(r^3))^0.5;

Omega20= norm (cross([x y z],[Vx Vy Vz])/r^2);

A=[zeros(3), eye(3);
   3*Omega20^2 ,0, 0, 0, 2*Omega20, 0;
   0 ,0 ,0 ,-2*Omega20 ,0 ,0 ;
   0 ,0, -(Omega20^2), 0, 0, 0 ];
B=[0 0 0; 0 0 0; 0 0 0;1 0 0; 0 1 0; 0 0 1];
%C_Nbar=[1 0 0 0 0 0 ;0 1 0 0 0 0; 0 0 1 0 0 0];
C=eye(6);
D=0;

SSM=ss(A,B,C,D);
TF=tf(SSM);

s=tf('s');
C=Kp+Ki*(s^-(lambda)) + Kd*(s^(delta));
init=[0;0;1000;0;-1;0];
u=[-100*ones(size(t')) zeros(size(t')) zeros(size(t'))];
%u is INPUT signal u(t).It is not reference signal.

%i=Input Number
%j=Output Number
System = feedback(C.*TF,eye(3,6));
y=lsim(System,u,t',init);

end


