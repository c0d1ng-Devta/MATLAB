function [df]=Nonlinear_HCW(ti,sv,f,tspan,Omega20)
global mu ;
f=interp1(tspan,f',ti);
x=f(1);
y=f(2);
z=f(3);
Vx=f(4);
Vy=f(5);
Vz=f(6);

rt=norm([x y z]);
Omega20o= (cross([x y z],[Vx Vy Vz])/rt^2);
Omega20=norm(Omega20o);

% Omega20=(mu/(rt^3))^0.5;
rc=norm([rt+sv(1) sv(2) sv(3)]);

% alpha=cross(r20,a20)/r^2;
alpha=-2*Vx*Omega20/rt;

% ax=2*Omega20*Vy+(alpha(3))*y+ (Omega20^2)*x+mu/(r^2)-mu*(r+x)/z^3;
% ay=-2*Omega20*Vx -(alpha(3))*x +(Omega20^2)*y -mu*y/z^3;
% az=-mu*z/z^3;

A = [zeros(3)                ,               eye(3);...
         (-mu/rc^3 + Omega20^2)  , alpha       ,        0   ,        0          ,     2*Omega20  ,  0;...
         -alpha      ,       (-mu/rc^3 + Omega20^2)  ,  0     ,      -2*Omega20 ,   0         ,      0;...
         0           ,               0     ,                      -mu/rc^3  ,  0            ,   0          ,     0];

    B = [0;
         0;
         0;
         -mu*(rt/rc^3) + (mu/rt^2);
         0;
         0];

df = A*f' + B;

% df = [Vx  Vy  Vz  ax  ay  az]'; 
end
