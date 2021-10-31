function[y4,t] =Linear_HCW(init,tspan,y2)
% Position Control of Chaser using Linearized HCW equations.
% Here w will be Changing for every time stamp so will implement it like
% Non Linear Model.

%% Implementing Time Varying Angular Velocity System.

[t,y4] = rkf4(@(t,y)HCW_eq(t,y2,tspan),[tspan(1),tspan(end)],init,tspan(2)-tspan(1));

end

function dydt= HCW_eq(t,f,tspan)
f=interp1(tspan,f,t);
x=f(1);
y=f(2);
z=f(3);
Vx=f(4);
Vy=f(5);
Vz=f(6);
size(f);

r=norm([x y z]);
% Omega20=(mu/(r^3))^0.5;

Omega20= norm (cross([x y z],[Vx Vy Vz])/r^2);
% ax=2*Omega20*Vy+ 3*Omega20*Omega20*x;
% ay=-2*Omega20*Vx;
% az=-Omega20^2*z;

A=[zeros(3), eye(3);
   3*Omega20^2 ,0, 0, 0, 2*Omega20, 0;
   0 ,0 ,0 ,-2*Omega20 ,0 ,0 ;
   0 ,0, -(Omega20^2), 0, 0, 0 ];

dydt = A*f';
% dy = [Vx  Vy  Vz  ax  ay  az]'; 
end
