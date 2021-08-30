function [df]=Nonlinear_HCW(~,f)
global mu ax ay az;

x=f(1);
y=f(2);
z=f(3);
Vx=f(4);
Vy=f(5);
Vz=f(6);

r20=[x y z]';

r=norm([x y z]);
Omega20=(mu/(r^3))^0.5;
z=norm([r+x y z]);

a20=[ax ay az]';

alpha=cross(r20,a20)/r^2;


ax=2*Omega20*Vy+(alpha(3))*y+ (Omega20^2)*x+mu/(r^2)-mu*(r+x)/z^3;
ay=-2*Omega20*Vx -(alpha(3))*x +(Omega20^2)*y -mu*y/z^3;
az=-mu*z/z^3;




df = [Vx  Vy  Vz  ax  ay  az]'; 
end
