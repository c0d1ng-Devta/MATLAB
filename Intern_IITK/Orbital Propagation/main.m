%%Notations Used Below.
% 0- Origin(Earth Center)
% 1- Earth
% 2- Target Satellite
% 3- Chaser Satellite
% o- Intial

clc;
clear;
% close all;

global mu m1 m2 m3 G Re ;
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

Ro30=[xo30 yo30 zo30]';
%% Intial Difference Between Satellites

Ro32=[xo30-xo20 yo30-yo20 zo30-zo20]';
Vo32=[Vxo30-Vxo20 Vyo30-Vyo20 Vzo30-Vzo20]';
%% Time and Other Constants 
hours =3600;
t0 = 0;
tf = 1*hours;
st=.25;
t= t0:st:tf;
mu = G*(m1 + m2);

n=2*pi/(24*3600);%Data is of Geosynchronous Satellite (Omega of Target satellite)

r_tol=1e-7;%Tolerence value for Minimum distance between T and C.
fig_no=1;% To keep count of Figures
%% Calculating Orbital State Vector wrt time using Runge Kutta Method of Order-4.

%Considering Two Body System making each satellite Independent of Each
%Other.
p20=[xo20; yo20; zo20; Vxo20; Vyo20; Vzo20];
[T2,y2] = rkf4(@twobody,[t0,tf], p20 ,st);

p30=[xo30; yo30; zo30; Vxo30; Vyo30; Vzo30];
[T3,y3] = rkf4(@twobody,[t0,tf], p30,st);

% figure(fig_no)
% fig_no=fig_no+1;
% subplot2([y2(:,1) y2(:,2) y2(:,3) y2(:,4) y2(:,5) y2(:,6)],T2)

%Considering Three Body System
y00 = [xo10 yo10 zo10 xo20 yo20 zo20 xo30 yo30 zo30 Vxo10 Vyo10 Vzo10 Vxo20 ...
      Vyo20 Vzo20 Vxo30 Vyo30 Vzo30]';
[T1,y1] = rkf4(@threebody,[t0,tf], y00,st);
%% Planet Earth Position and Velocity
% plots Position and Velocity components of Planet-Earth wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure(fig_no)%1
fig_no=fig_no+1;
subplot2([y1(:,1) y1(:,2) y1(:,3) y1(:,10) y1(:,11) y1(:,12)],T1)
%% Planet-1 Position and Velocity
% plots Position and Velocity components of Planet-1 wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure(fig_no)%2
fig_no=fig_no+1;
subplot2([y1(:,4) y1(:,5) y1(:,6) y1(:,13) y1(:,14) y1(:,15)],T1)
%% Planet-2 Position and Velocity
% plots Position and Velocity components of Planet 2 wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure(fig_no)%3
fig_no=fig_no+1;
subplot2([y1(:,7) y1(:,8) y1(:,9) y1(:,16) y1(:,17) y1(:,18)],T1)
%% Difference of Planet-1 and Planet-2 Position and Velocity
% plots Position and Velocity components of Planet 2 wrt to Planet 1 wrt to
% Interial Frame of Reference at Space .
figure(fig_no)%4
fig_no=fig_no+1;
subplot2([y1(:,4)-y1(:,7) y1(:,5)-y1(:,8) y1(:,6)-y1(:,9) ...
         y1(:,13)-y1(:,16)  y1(:,14)-y1(:,17) y1(:,15)-y1(:,18)],T1)
%% Simulating Sat Motion around Earth.
% Draw the planet

figure(fig_no)%5
fig_no=fig_no+1;
Earthplot([y1(:,4), y1(:,5), y1(:,6)],Ro20,[y1(:,7),y1(:,8),y1(:,9)],Ro30);
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

[~,NL_HCW]=rkf4(@Nonlinear_HCW,[t0,t(end)],initial32,st);

% In place of Nonlinear_HCW function nonlinear_HCW_matrix_diff_equ can be
% used.
% Plotting the Non-linear Simulation 
figure(fig_no)%8
fig_no=fig_no+1; 
subplot2([NL_HCW(:,1) NL_HCW(:,2) NL_HCW(:,3) NL_HCW(:,4) NL_HCW(:,5) NL_HCW(:,6)],t)
%% Applying Lqr Control Technique to LHCW equations with constant Omega of Target Sattelite 
[lqr_LHCW_n,t_lqr_nLHCW]=lqr_lhcw_const_N(initial32,t);

figure(fig_no)%9
fig_no=fig_no+1; 
subplot2(lqr_LHCW_n,t_lqr_nLHCW');

figure(fig_no)%9
fig_no=fig_no+1; 
Earthplot([y1(:,4), y1(:,5), y1(:,6)],Ro20,[lqr_LHCW_n(1,:),lqr_LHCW_n(2,:),lqr_LHCW_n(3,:)],Ro30);
%% Applying Control Techniques to LInear LTV(w is varying)(HCW Equations) System.
Q=0.1*(eye(6));
R=eye(3);

lqr_LHCW=lqr_L_HCW(initial32,t,y2);

figure(fig_no)%10
fig_no=fig_no+1; 
subplot2([lqr_LHCW(:,1) lqr_LHCW(:,2) lqr_LHCW(:,3) lqr_LHCW(:,4) lqr_LHCW(:,5) lqr_LHCW(:,6)],t)
%{
%% Applying PID Using Autotuning control Technique to Linear LTV(w is varying )(HCW equations) System.
% Kp=2;
% Ki=4;
% Kd=4;
% lambda =1;
% delta =1;B=[0 0 0; 0 0 0; 0 0 0;1 0 0; 0 1 0; 0 0 1];

param_FPID=[Kp,Ki,Kd,lambda,delta];
pid_LHCW_pidtune=PID_LHCW_PIDTUNE(initial32,t,y2);

figure(fig_no)%10
fig_no=fig_no+1; 
subplot2([pid_LHCW_pidtune(:,1) pid_LHCW_pidtune(:,2) pid_LHCW_pidtune(:,3) pid_LHCW_pidtune(:,4) pid_LHCW_pidtune(:,5) pid_LHCW_pidtune(:,6)],t)
%% Applying PID control Technique to Linear LTV(w is varying )(HCW equations) System with all Params Constant.
Kp=2;
Ki=4;
Kd=4;
lambda =1;
delta =1;

param_pid=[Kp,Ki,Kd,lambda,delta];

pid_LHCW=PID_LHCW(initial32,t,y2,param_pid);
%}