function [lqr_LHCW]=lqr_L_HCW(L_HCW,t)
Q=0.1*(eye(6));
R=eye(3);

to=t(1);
tf=t(end);
ti =to;

lqr_LHCW=zeros(3601,6);

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
C_Nbar=[1 0 0 0 0 0 ;0 1 0 0 0 0; 0 0 1 0 0 0];
C=eye(6);
D=0;

k=lqr(A,B,Q,R);
Nbar=-(inv(C_Nbar*inv(A-B*k)*B));
State=ss(A-B*k,B*Nbar,C,D,'InputName',{'ax','ay','az'},'OutputName'...
    ,{'y'},'StateName',{'x','y','z','x*','y*','z*'});

u=[-100*zeros(size(t));zeros(size(t));zeros(size(t))];
init=[0;0;1000;0;-1;0];


y1=lsim(State,u,t,init);

lqr_LHCW(i,:)=[y1(i,1) y1(i,2) y1(i,3) y1(i,4) y1(i,5) y1(i,6)];

end

end  