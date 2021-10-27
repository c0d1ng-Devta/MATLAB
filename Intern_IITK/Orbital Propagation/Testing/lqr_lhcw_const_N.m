clear, clc

n=2*pi/(24*3600);%Data is of Geosynchronous Satellite
m=6000;
r=45000000;

A=[0 0 0 1 0 0; 
   0 0 0 0 1 0;
   0 0 0 0 0 1;
   3*n*n 0 0 0 2*n 0;
   0 0 0 -2*n 0 0;
   0 0 -n*n 0 0 0];
B=[0 0 0;
   0 0 0;
   0 0 0;
   1 0 0;
   0 1 0;
   0 0 1];

%%  Design LQR controller
Q = 1.*eye(6);
R = eye(3);

K = lqr(A,B,Q,R);

%% Simulate closed-loop system
tspan = 0:.01:8;
x0 = [-1000;-200;-4000;30;40;50];   % initial condition 
xdes = [0; -100; 0; 0; 0; 0];       % reference position
u=@(x)-K*(x - xdes);                % control law

[t,x] = ode45(@(t,x)diff_equ(x,u(x),n),tspan,x0);

desired = repmat(xdes',length(t),1);
x = x';
desired = desired';
subplot2(x',t');
% figure(1)
% subplot(3,2,1)
% plot(tspan,x(1,:),tspan,desired(1,:))
% xlabel('Time (s)')
% ylabel('x (m)')
% 
% subplot(3,2,3)
% plot(tspan,x(2,:),tspan,desired(2,:))
% xlabel('Time (s)')
% ylabel('y (m)')
% 
% subplot(3,2,5)
% plot(tspan,x(3,:),tspan,desired(3,:))
% xlabel('Time (s)')
% ylabel('z (m)')
% 
% subplot(3,2,2)
% plot(tspan,x(4,:),tspan,desired(4,:))
% xlabel('Time (s)')
% ylabel('vx (m/s)')
% 
% subplot(3,2,4)
% plot(tspan,x(5,:),tspan,desired(5,:))
% xlabel('Time (s)')
% ylabel('vy (m/s)')
% 
% subplot(3,2,6)
% plot(tspan,x(6,:),tspan,desired(6,:))
% xlabel('Time (s)')
% ylabel('vz (m/s)')