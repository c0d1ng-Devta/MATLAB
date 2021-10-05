%%Notations Used Below.
% 0- Origin(Earth Center)
% 1- Earth
% 2- Target Satellite
% 3- Chaser Satellite
% o- Intial


clc;
clear;
% close all;

global mu m1 m2 m3 G ;
%% Earth:
m1 = 5.974e24;
Re = 6378;
G = 6.6742e-20;
xo10=0;
yo10=0;
zo10=0;
Vxo10=0;
Vyo10=0;
Vzo10=0;
%% First Satellite(Target Satellite )(Hill's Frame is Associated)
m2 = 100;
%Intial Position and Velocity 
xo20=8000;
yo20=0;
zo20=6000;
Vxo20=0;
Vyo20=7;
Vzo20=0;

Ro20=[xo20 yo20 zo20]';
Vo20=[Vxo20 Vyo20 Vzo20]';
%% Second Satellite
m3= 200 ;
%Intial Position and Velocity wrt Inertial Frame(o) .
xo30=8000;
yo30=0;
zo30=7000;
Vxo30=0;
Vyo30=6;
Vzo30=0;
%% Intial Difference Between Satellites

Ro32=[xo30-xo20 yo30-yo20 zo30-zo20]';
Vo32=[Vxo30-Vxo20 Vyo30-Vyo20 Vzo30-Vzo20]';
%% Time and Other Constants 
hours =3600;
t0 = 0;
tf = 5*hours;
t= t0:5:tf;
mu = G*(m1 + m2);

fig_no=1;% To keep count of Figures
%% Calculating Orbital State Vector wrt time using Runge Kutta Method of Order-4.

%Considering Two Body System making each satellite Independent of Each
%Other.
p20=[xo20; yo20; zo20; Vxo20; Vyo20; Vzo20];
[T2,y2] = rkf4(@twobody,[t0,tf], p20);

p30=[xo30; yo30; zo30; Vxo30; Vyo30; Vzo30];
[T3,y3] = rkf4(@twobody,[t0,tf], p30);

% figure(fig_no)
% fig_no=fig_no+1;
% subplot2([y2(:,1) y2(:,2) y2(:,3) y2(:,4) y2(:,5) y2(:,6)],T2)

%Considering Three Body System
y00 = [xo10 yo10 zo10 xo20 yo20 zo20 xo30 yo30 zo30 Vxo10 Vyo10 Vzo10 Vxo20 ...
      Vyo20 Vzo20 Vxo30 Vyo30 Vzo30]';
[T1,y1] = rkf4(@threebody,[t0,tf], y00);
%% Planet Earth Position and Velocity
% plots Position and Velocity components of Planet-Earth wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure(fig_no)
fig_no=fig_no+1;
subplot2([y1(:,1) y1(:,2) y1(:,3) y1(:,10) y1(:,11) y1(:,12)],T1)
%% Planet-1 Position and Velocity
% plots Position and Velocity components of Planet-1 wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure(fig_no)
fig_no=fig_no+1;
subplot2([y1(:,4) y1(:,5) y1(:,6) y1(:,13) y1(:,14) y1(:,15)],T1)
%% Planet-2 Position and Velocity
% plots Position and Velocity components of Planet 2 wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure(fig_no)
fig_no=fig_no+1;
subplot2([y1(:,7) y1(:,8) y1(:,9) y1(:,16) y1(:,17) y1(:,18)],T1)
%% Difference of Planet-1 and Planet-2 Position and Velocity
% plots Position and Velocity components of Planet 2 wrt to Planet 1 wrt to
% Interial Frame of Reference at Space .
figure(fig_no)
fig_no=fig_no+1;
subplot2([y1(:,4)-y1(:,7) y1(:,5)-y1(:,8) y1(:,6)-y1(:,9) ...
         y1(:,13)-y1(:,16)  y1(:,14)-y1(:,17) y1(:,15)-y1(:,18)],T1)
%% Simulating Sat Motion around Earth.
% Draw the planet
figure(fig_no)
fig_no=fig_no+1;

r = 0.8; g = r; b = r;
map = [r g b;0 0 0; r g b];

[xx, yy, zz] = sphere(100);
surf(Re*xx, Re*yy, Re*zz)
colormap(map)
caxis([-Re/100 Re/100])
shading flat

% Draw and label the X, Y and Z axes
line([0 2*Re], [0 0], [0 0]); text(2*Re, 0, 0, 'X')
line( [0 0], [0 2*Re], [0 0]); text( 0, 2*Re, 0, 'Y')
line( [0 0], [0 0], [0 2*Re]); text( 0, 0, 2*Re, 'Z')

% Plot the orbit, draw a radial to the starting point
% and label the starting point (o) and the final point (f) for Planet-1
hold on
plot3( y1(:,4), y1(:,5), y1(:,6),'k')
line([0 xo20], [0 yo20], [0 zo20])
text( y1(1,4), y1(1,5), y1(1,6), 'o')
text( y1(end,4), y1(end,5), y1(end,6), 'f')
% Select a view direction (a vector directed outward from the origin)
view([1,1,.4])

% Plot the orbit, draw a radial to the starting point
% and label the starting point (o) and the final point (f) for Planet-2.
plot3( y1(:,7), y1(:,8), y1(:,9),'k')
line([0 xo30], [0 yo30], [0 zo30])
text( y1(1,7), y1(1,8), y1(1,9), 'o')
text( y1(end,7), y1(end,8), y1(end,9), 'f')

% Specify some properties of the graph
grid on
axis equal
xlabel('km')
ylabel('km')
zlabel('km')
%% Getting the relative value of Deputy(chaser) Sat-2 wrt to Leader(Target) Sat-1 in Hills frame
% and Plotting it 

[r32h, v32h] = getHills(y2, y3);

figure(fig_no)%6
fig_no=fig_no+1; 
subplot2([r32h(1,:)' r32h(2,:)' r32h(3,:)' v32h(1,:)' v32h(2,:)' v32h(3,:)'],T1)
%% Getting Relative Positions and W using Linearised HCW equations

initial32=[Ro32'  Vo32']';% Intial State Vector of Chaser Sat wrt Target Sat
L_HCW=Linear_HCW(initial32,t);

% Plotting the linear Simulation 
figure(fig_no)%7
fig_no=fig_no+1; 
subplot2([L_HCW(:,1) L_HCW(:,2) L_HCW(:,3) L_HCW(:,4) L_HCW(:,5) L_HCW(:,6)],t)
%% Getting Relative Positions and W using Non Linear Non Pertubated HCW equations

[~,NL_HCW]=rkf4(@Nonlinear_HCW,[t0,tf],initial32);

% In place of Nonlinear_HCW function nonlinear_HCW_matrix_diff_equ can be
% used.
% Plotting the Non-linear Simulation 
figure(fig_no)%8
fig_no=fig_no+1; 
subplot2([NL_HCW(:,1) NL_HCW(:,2) NL_HCW(:,3) NL_HCW(:,4) NL_HCW(:,5) NL_HCW(:,6)],t)
%% Applying Control Techniques to LInear LTV(w is varying)(HCW Equations) System.
Q=0.1*(eye(6));
R=eye(3);

lqr_LHCW=lqr_L_HCW(L_HCW,t);

figure(fig_no)%9
fig_no=fig_no+1; 
subplot2([lqr_LHCW(:,1) lqr_LHCW(:,2) lqr_LHCW(:,3) lqr_LHCW(:,4) lqr_LHCW(:,5) lqr_LHCW(:,6)],t)

%% Applying PID control Technique to Linear LTV(w is varying )(HCW equations ) System.
Kp=4342;
Ki=434;
Kd=4324;
lambda =1;
delta =1;
param_FPID=[Kp,Ki,Kd,lambda,delta];


pid_LHCW=PID_LHCW(L_HCW,t,param_FPID);




