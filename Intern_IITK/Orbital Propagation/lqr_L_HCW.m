function [lqr_LHCW]=lqr_L_HCW(initial,t)
Q=0.1*(eye(6));
R=eye(3);

init=initial;
lqr_LHCW=zeros(length(t),6);

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
C_Nbar=[1 0 0 0 0 0 ;0 1 0 0 0 0; 0 0 1 0 0 0];
C=eye(6);
D=0;

k=lqr(A,B,Q,R);
Nbar=-(inv(C_Nbar*((A-B*k)\B)));
State=ss(A-B*k,B*Nbar,C,D,'InputName',{'ax','ay','az'},'OutputName'...
    ,{'y'},'StateName',{'x','y','z','x*','y*','z*'});

u=[-100*zeros(size(t));zeros(size(t));zeros(size(t))];
init=[0;0;1000;0;-1;0];


y1=lsim(State,u,t,init);

lqr_LHCW(i,:)=[y1(i,1) y1(i,2) y1(i,3) y1(i,4) y1(i,5) y1(i,6)];
init=lqr_LHCW(i,:)';

end

end  