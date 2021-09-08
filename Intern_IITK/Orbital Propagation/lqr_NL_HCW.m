function []=lqr_NL_HCW(NL_HCW,t)
Q=0.1*(eye(6));
R=eye(3);
to=t(1);
tf=t(end);
ti =to;

    
for i = t0:5:tf 
x=NL_HCW(i,1);
y=NL_HCW(i,2);
z=NL_HCW(i,3);
Vx=NL_HCW(i,4);
Vy=NL_HCW(i,5);
Vz=NL_HCW(i,6);

r20=[x y z]';
v20=[Vx Vy Vz]';

rt=norm([x y z]);
Omega20=(mu/(rt^3))^0.5;
rc=norm([rt+x y z]);

alpha=-2*Vx*Omega20/rt;

A = [zeros(3)                ,               eye(3);...
    (-mu/rc^3 + Omega20^2)  , alpha       ,        0   ,        0          ,     2*Omega20  ,  0;...
     -alpha      ,       (-mu/rc^3 + Omega20^2)  ,  0     ,      -2*Omega20 ,   0         ,      0;...
     0           ,               0     ,                      -mu/rc^3  ,  0            ,   0          ,     0];

B = [0;
     0;
     0;
     -mu*(x/rc^3) + (mu/rt^2);
     0;
     0];
k=lqr(A,B,Q,R);
Nbar=-(inv(C_Nbar*(A-B*k)\B));



end

    