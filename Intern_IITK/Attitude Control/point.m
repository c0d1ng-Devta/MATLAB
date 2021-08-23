function [T,y] = point(t,y0,controller)
global u1 u2 u3 J1 J2 J3;
% Initial Control Torques
u1=0;
u2=0;
u3=0;
% Calls one of the controller functions
options = odeset('RelTol',1e-5,'AbsTol',1e-5);
if controller==6
 [T,y] = ode45(@controller6,t,y0,options);
elseif controller==5
 [T,y] = ode45(@controller5,t,y0,options);
elseif controller==4
 [T,y] = ode45(@controller4,t,y0,options);
elseif controller==3
 [T,y] = ode45(@controller3,t,y0,options);
elseif controller==2
 [T,y] = ode45(@controller2,t,y0,options);
else
 [T,y] = ode45(@controller1,t,y0,options);
end
% Plots Euler Angles
figure(1)
hold off
plot(T,y(:,1),'-black')
hold on
figure(1)
plot(T,y(:,2),'-red')
hold on
figure(1)
plot(T,y(:,3),'-blue')
hold on
figure(1)
plot(T,y(:,4),'-green')
hold on
grid
xlabel('time, seconds')
ylabel('q1 (black), q2 (red), q3 (blue), q4 (green)')
title('Quaternion Plots')

% Plots Euler Angles
figure(4)
hold off
plot(T,y(:,5),'-black')
hold on
figure(4)
plot(T,y(:,6),'-red')
hold on
figure(4)
plot(T,y(:,7),'-blue')
hold on
grid
xlabel('time, seconds')
ylabel('w1 (black), w2 (red), w3 (blue))')
title('Angular Velocities Plots')
% % Defines identity matrix
% i1=[1 0 0]';
% i2=[0 1 0]';
% i3=[0 0 1]';
% % Ellipsoid ***********************************
% E1(1)=((J2+J3-J1)/2)^.5;
% E1(2)=((J1-J2+J3)/2)^.5;
% E1(3)=((J1+J2-J3)/2)^.5;
% E2=E1(1);
% if E2<E1(2)
%  E2=E1(2);
% end
% if E2<E1(3)
%  E2=E1(3);
% end
% E2=1/(E2*1.25);
% E1=E2*E1;
% edef=25;
% edef2=edef+1;
% [xe1, ye1, ze1] = ellipsoid(0,0,0,E1(1),E1(2),E1(3),edef);
% % End Ellipsoid *******************************
% % For loop runs MatLab movie
% for ii=1:length(t)
%  % Defines Rotation Matrix
%  R(:,:,ii)=[1-2*(y(ii,2)^2+y(ii,3)^2) 2*(y(ii,1)*y(ii,2)+y(ii,3)*y(ii,4))...
% 2*(y(ii,1)*y(ii,3)-y(ii,2)*y(ii,4)) ; 2*(y(ii,2)*y(ii,1)-y(ii,3)*y(ii,4)) 1-...
% 2*(y(ii,1)^2+y(ii,3)^2) 2*(y(ii,2)*y(ii,3)+y(ii,1)*y(ii,4)) ;...
% 2*(y(ii,3)*y(ii,1)+y(ii,2)*y(ii,4)) 2*(y(ii,3)*y(ii,2)-y(ii,1)*y(ii,4)) 1-...
% 2*(y(ii,1)^2+y(ii,2)^2)];
% 
%  % Defines body fixed axis
%  b1=R(:,:,ii)*i1;
%  b2=R(:,:,ii)*i2;
%  b3=R(:,:,ii)*i3;
% 
%  % Rotates the ellipsoid ************************
%  xe2=zeros(edef2,edef2);
%  ye2=zeros(edef2,edef2);
%  ze2=zeros(edef2,edef2);
%  for jj=1:edef2
%  for kk=1:edef2
%  ll=[xe1(jj,kk) ye1(jj,kk) ze1(jj,kk)]';
%  mm=R(:,:,ii)*ll;
%  xe2(jj,kk)=mm(1);
%  ye2(jj,kk)=mm(2);
%  ze2(jj,kk)=mm(3);
%  end
%  end
%  % End ellipsoid rotation ***********************
% 
%  % Plots MatLab movie
%  figure(3)
%  plot3([0 i1(1)],[0 i1(2)],[0 i1(3)],'-black','LineWidth',2)
%  hold on
%  plot3([0 i2(1)],[0 i2(2)],[0 i2(3)],'-black','LineWidth',2)
%  hold on
%  plot3([0 i3(1)],[0 i3(2)],[0 i3(3)],'-black','LineWidth',2)
%  hold on
%  plot3([0 -i1(1)],[0 -i1(2)],[0 -i1(3)],'-yellow','LineWidth',2)
%  hold on
%  plot3([0 -i2(1)],[0 -i2(2)],[0 -i2(3)],'-yellow','LineWidth',2)
%  hold on
%  plot3([0 -i3(1)],[0 -i3(2)],[0 -i3(3)],'-yellow','LineWidth',2)
%  hold on
%  plot3([0 b1(1)],[0 b1(2)],[0 b1(3)],'-r','LineWidth',2)
%  hold on
%  plot3([0 b2(1)],[0 b2(2)],[0 b2(3)],'-g','LineWidth',2)
%  hold on
%  plot3([0 b3(1)],[0 b3(2)],[0 b3(3)],'-b','LineWidth',2)
%  hold on
%  grid
%  xlabel('i_1')
%  ylabel('i_2')
%  zlabel('i_3')
%  az = 135;
%  el = 45;
%  view(az, el);
%  surfl(xe2, ye2, ze2)
%  colormap copper
%  hold off
%  axis equal
%  length(t)
% end