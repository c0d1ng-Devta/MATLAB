function [pid_LHCW]=PID_LHCW_PIDTUNE(initial,t,y2)
%Used pidtune Function to Find best Possible Parameters for Individual TF
%of Transfer Matrix.

pid_LHCW=zeros(length(t),6);

init=initial;
y_um=zeros(6,3,length(t));
y_u=zeros(6,length(t));

for i = (1:length(t))
% x=init(1);
% y=init(2);
% z=init(3);
% Vx=init(4);
% Vy=init(5);
% Vz=init(6);

x20=y2(i,1);
y20=y2(i,2);
z20=y2(i,3);
Vx20=y2(i,4);
Vy20=y2(i,5);
Vz20=y2(i,6);
r=norm([x20 y20 z20]);
% Omega20=(mu/(r^3))^0.5;

Omega20= norm (cross([x20 y20 z20],[Vx20 Vy20 Vz20])/r^2);


A=[zeros(3), eye(3);
   3*Omega20^2 ,0, 0, 0, 2*Omega20, 0;
   0 ,0 ,0 ,-2*Omega20 ,0 ,0 ;
   0 ,0, -(Omega20^2), 0, 0, 0 ];
B=[0 0 0; 0 0 0; 0 0 0;1 0 0; 0 1 0; 0 0 1];
%C_Nbar=[1 0 0 0 0 0 ;0 1 0 0 0 0; 0 0 1 0 0 0];
C=eye(6);
D=0;

u=[-100*ones(size(t')) zeros(size(t')) zeros(size(t'))];
%u is INPUT signal u(t).It is not reference signal.

SSM=ss(A,B,C,D);
TF=tf(SSM);                      %TF(output,input)

% s=tf('s');
%C=Kp+Ki*(s^-(lambda)) + Kd*(s^(delta));
for j =1:6
    for k= 1:3
C_pid=pidtune(TF(j,k),'PID');
%k=Input Number
%j=Output State Number
System = feedback(C_pid*TF(j,k),1);
y_um(j,k,:)=lsim(System,u(:,k),t',init(j));
    end 
y_u=sum(y_um,2);
end

pid_LHCW(i,:)=[y_u(1,1,i),y_u(2,1,i),y_u(3,1,i),y_u(4,1,i),y_u(5,1,i),y_u(6,1,i)];
init=pid_LHCW(i,:)';
fprintf("%d\n",i);
end


