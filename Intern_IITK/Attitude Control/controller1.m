function dy = controller1(t,y)
global u1 u2 u3 ue1 ue2 ue3 J1 J2 J3 q1c q2c q3c q4c k c1 c2 c3 w1c w2c w3c;
dy = zeros(7,1); % a column Output vector
% Quaternions
 dy(1)=((y(7)*y(2)-y(6)*y(3)+y(5)*y(4))*.5);

 dy(2)=((-y(7)*y(1)+y(5)*y(3)+y(6)*y(4))*.5);

 dy(3)=((y(6)*y(1)-y(5)*y(2)+y(7)*y(4))*.5);

 dy(4)=((-y(5)*y(1)-y(6)*y(2)-y(7)*y(3))*.5);

% Omegas

 dy(5)=(u1+ue1+(J2-J3)*y(6)*y(7))/J1;

 dy(6)=(u2+ue2+(J3-J1)*y(7)*y(5))/J2;

 dy(7)=(u3+ue3+(J1-J2)*y(5)*y(6))/J3;
 

% Error Quaternions
 
 q1c=0;
 q2c=sin(pi*t/32);
 q3c=0;
 q4c=cos(pi*t/32);
 
 qe1=(q4c*y(1)+q3c*y(2)-q2c*y(3)-q1c*y(4));

 qe2=(-q3c*y(1)+q4c*y(2)+q1c*y(3)-q2c*y(4));

 qe3=(q2c*y(1)-q1c*y(2)+q4c*y(3)-q3c*y(4));

% Control Torques
 u1=-k*qe1-c1*y(5);

 u2=-k*qe2-c2*y(6);

 u3=-k*qe3-c3*y(7);
