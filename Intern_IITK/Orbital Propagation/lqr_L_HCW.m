function [lqr_LHCW]=lqr_L_HCW(initial,t,y2)
Q=0.1*(eye(6));
R=eye(3);

init=initial;
svt=init;
lqr_LHCW=zeros(length(t),6);

for i = (1:length(t))
x=init(1);
y=init(2);
z=init(3);
Vx=init(4);
Vy=init(5);
Vz=init(6);

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
% C_Nbar=[1 0 0 0 0 0 ;0 1 0 0 0 0; 0 0 1 0 0 0];
C=eye(6);
% D=0;

k=lqr(A,B,Q,R);
% Nbar=-(inv(C_Nbar*((A-B*k)\B)));
% State=ss(A-B*k,B*Nbar,C,D,'InputName',{'ax','ay','az'},'OutputName'...
%     ,{'y'},'StateName',{'x','y','z','x*','y*','z*'});

ref=[-100;0;0;0;0;0];
% u=[-100*ones(size(t')) zeros(size(t')) zeros(size(t'))];
% init=[0;0;1000;0;-1;0];

% y1=lsim(State,u,t,init);

svt=A*svt -B*k*(svt-ref);
y1=C*[x;y;z;Vx;Vy;Vz];

lqr_LHCW(i,:)=[y1(1) y1(2) y1(3) y1(4) y1(5) y1(6)];
% lqr_LHCW(i,:)=[y1(i,1) y1(i,2) y1(i,3) y1(i,4) y1(i,5) y1(i,6)];
% init=lqr_LHCW(i,:)';
init =svt;

end

end  