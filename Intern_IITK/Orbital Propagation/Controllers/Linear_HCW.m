function[y4,t] =Linear_HCW(init,tspan,y2,C,Omega20)
% Position Control of Chaser using Linearized HCW equations.
% Here w will be Changing for every time stamp so will implement it like
% Non Linear Model.
%% Implementing Time Varying Angular Velocity System.
[t,y4] = rkf4(@(t,sv)HCW_eq(t,sv,y2,tspan),[tspan(1),tspan(end)],init,tspan(2)-tspan(1));

 for k=1:length(y4)
 y4(k,1:3)=(C(:,:,k))\y4(k,1:3)';
 y4(k,4:6)=(C(:,:,k))\(y4(k,4:6)-cross(y4(k,1:3),Omega20(k,:)'))';
 end
end

function dydt= HCW_eq(t,sv,f,tspan)
% global i 
f=interp1(tspan,f,t);
% f=f(fix(i),:);
x=f(1); 
y=f(2);
z=f(3);
Vx=f(4);
Vy=f(5);
Vz=f(6);

% R20 = f(1:3);
% V20 = f(4:6);
% 
% R20_mag=norm(R20);
% Omega20=cross(R20,V20)/R20_mag^2;
% 
% exh=R20/norm(R20);%h is used for hills frame.
% ezh=cross(R20,V20)/norm(cross(R20,V20));
% eyh=cross(ezh,exh);
% C=[exh; eyh; ezh ];

r=norm([x y z]);
% Omega20=(mu/(r^3))^0.5;

Omega20o= (cross([x y z],[Vx Vy Vz])/r^2);
Omega20=norm(Omega20o);

A=[zeros(3), eye(3);
   3*Omega20^2 ,0, 0, 0, 2*Omega20, 0;
   0 ,0 ,0 ,-2*Omega20 ,0 ,0 ;
   0 ,0, -(Omega20^2), 0, 0, 0 ];

dydt = A*sv;
% i=i+0.25;
% dy = [Vx  Vy  Vz  ax  ay  az]'; 
end
