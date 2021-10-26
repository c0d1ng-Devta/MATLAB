function L_HCW =Linear_HCW(init,t)
% Position Control of Chaser using Linearized HCW equations.
% Here w will be Changing for every time stamp so will implement it like
% Non Linear Model.

%% Implementing Time Varying Angular Velocity System.

[~,y4] = rkf4(@HCW_eq,[t(1),t(end)],init,t(2)-t(1));
L_HCW=y4;

end

function dy= HCW_eq(~,f)
x=f(1);
y=f(2);
z=f(3);
Vx=f(4);
Vy=f(5);
Vz=f(6);

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

dy = A*f;
% dy = [Vx  Vy  Vz  ax  ay  az]'; 
end
