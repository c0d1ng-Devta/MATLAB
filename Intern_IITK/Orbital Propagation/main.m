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

%% time
hours =3600;
t0 = 0;
tf = 5*hours;
t= t0:5:tf;
mu = G*(m1 + m2);
%% Calculating Orbital State Vector wrt time using Runge Kutta Method of Order-4.

p0=[xo20; yo20; zo20; Vxo20; Vyo20; Vzo20];

[T2,y2] = rkf4(@twobody,[t0,tf], p0);

p03=[xo30; yo30; zo30; Vxo30; Vyo30; Vzo30];

[T3,y3] = rkf4(@twobody,[t0,tf], p03);

figure(1)
subplot(2,1,1)

plot(T2,y2(:,1),'-k')
hold on
plot(T2,y2(:,2),'-b')
plot(T2,y2(:,3),'-r')
title('Distance')
hold off

subplot(2,1,2)
plot(T2,y2(:,4),'-y')
hold on
plot(T2,y2(:,5),'-c')
plot(T2,y2(:,6),'-g')
title('Velocity ')
hold off


y00 = [xo10 yo10 zo10 xo20 yo20 zo20 xo30 yo30 zo30 Vxo10 Vyo10 Vzo10 Vxo20 Vyo20 Vzo20 Vxo30 Vyo30 Vzo30]';
[T1,y1] = rkf4(@threebody,[t0,tf], y00);

%% Planet Earth Position and Velocity
% plots Position and Velocity components of Planet-Earth wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure (2)

subplot(2,1,1)
plot(T1,y1(:,1),'-k')
hold on
plot(T1,y1(:,2),'-b')
plot(T1,y1(:,3),'-r')
title('Distance')
hold off

subplot(2,1,2)
plot(T1,y1(:,10),'-y')
hold on
plot(T1,y1(:,11),'-c')
plot(T1,y1(:,12),'-g')
title('Velocity ')
hold off

%% Planet-1 Position and Velocity
% plots Position and Velocity components of Planet-1 wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
% figure(3)
% subplot(2,1,1)
% plot(T1,y1(:,4),'-k')
% hold on
% plot(T1,y1(:,5),'-b')
% plot(T1,y1(:,6),'-r')
% title('Distance')
% hold off
% 
% subplot(2,1,2)
% plot(T1,y1(:,13),'-y')
% hold on
% plot(T1,y1(:,14),'-c')
% plot(T1,y1(:,15),'-g')
% title('Velocity ')
% hold off


%% Planet-2 Position and Velocity
% plots Position and Velocity components of Planet 2 wrt to fixed Interial
% Frame of Reference at space (Approx to Earth Center).
figure (4)
subplot(2,1,1)
plot(T1,y1(:,7),'-k')
hold on
plot(T1,y1(:,8),'-b')
plot(T1,y1(:,9),'-r')
title('Distance')
hold off

subplot(2,1,2)
plot(T1,y1(:,16),'-y')
hold on
plot(T1,y1(:,17),'-c')
plot(T1,y1(:,18),'-g')
title('Velocity ')
hold off

%% Difference of Planet-1 and Planet-2 Position and Velocity
% plots Position and Velocity components of Planet 2 wrt to Planet 1 wrt to
% Interial Frame of Reference at Space .
figure (5)
subplot(2,1,1)
plot(T1,y1(:,4)-y1(:,7),'-k')
hold on
plot(T1,y1(:,5)-y1(:,8),'-b')
plot(T1,y1(:,6)-y1(:,9),'-r')
title('Distance')
hold off

subplot(2,1,2)
plot(T1,y1(:,13)-y1(:,16),'-y')
hold on
plot(T1,y1(:,14)-y1(:,17),'-c')
plot(T1,y1(:,15)-y1(:,18),'-g')
title('Velocity ')
hold off

%% Plot the results:
% Draw the planet
figure(6)

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

%% Getting the relative value of Deputy(chaser) Sat-2 wrt to Leader(Target) Sat-1 in Hills frame.

[r32h, v32h] = getHills(y2, y3);
%% Plotting the relative value of Deputy Sat-2 wrt to Leader Sat-1 in Hills frame.
figure (7)
subplot(2,1,1)
plot(T1,r32h(1,:),'-k')
hold on
plot(T1,r32h(2,:),'-b')
plot(T1,r32h(3,:),'-r')
title('Distance')
hold off

subplot(2,1,2)
plot(T1,v32h(1,:),'-y')
hold on
plot(T1,v32h(2,:),'-c')
plot(T1,v32h(3,:),'-g')
title('Velocity ')
hold off

%%
