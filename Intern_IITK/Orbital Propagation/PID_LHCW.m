function [pid_LHCW]=PID_LHCW(initial,t,param_FPID)
pid_LHCW=zeros(length(t),6);
Kp=param_FPID(1);
Ki=param_FPID(2);
Kd=param_FPID(3);
lambda=param_FPID(4);
delta=param_FPID(5);
init=initial;

for i = (1:length(t))
x=init(1);
y=init(2);
z=init(3);
Vx=init(4);
Vy=init(5);
Vz=init(6);

r=norm([x y z]);
% Omega20=(mu/(r^3))^0.5;

if r<=0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
Omega20=0;
else
Omega20= norm (cross([x y z],[Vx Vy Vz])/r^2);
end

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
u=[-100*ones(size(t')) zeros(size(t')) zeros(size(t'))];
%u is INPUT signal u(t).It is not reference signal.

%i=Input Number
%j=Output Number
System = feedback(C.*TF,eye(3,6));
y=lsim(System,u,t',init);

pid_LHCW(i,:)=[y(i,1),y(i,2),y(i,3),y(i,4),y(i,5),y(i,6)];
init=pid_LHCW(i,:)';
end


