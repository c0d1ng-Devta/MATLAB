global J1 J2 J3 q1c q2c q3c q4c k c1 c2 c3 ue1 ue2 ue3 w1c w2c w3c;
clc;

% Time
t=0:.5:500;
% Moments of Inertia
J1=16;
J2=16;
J3=16;

% Controller Constants
k=1;
c1=4;
c2=4;
c3=4;
% Initial Quaternions
q1=-0.4;
q2=0.2;
q3=0.8;
q4=0.4;
% Initial Omegas
omega1=0;
omega2=0;
omega3=0;
%External torques
ue1=0;
ue2=0;
ue3=0;
% Controller 1, 2, 3, 4, 5, or 6
controller=1;
% Performs the calculations
y0=[q1 q2 q3 q4 omega1 omega2 omega3];
[T,y] = point(t,y0,controller);
