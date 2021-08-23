function dy = threebody(~,y)
global m1 m2 m3 G;

X1 = y( 1);
Y1 = y( 2);
Z1 = y(3);
X2 = y( 4);
Y2 = y( 5);
Z2 = y(6);
X3 = y( 7);
Y3 = y( 8);
Z3 = y(9);
VX1 = y( 10);
VY1 = y( 11);
VZ1 = y( 12);
VX2 = y(13);
VY2 = y(14);
VZ2 = y(15);
VX3 = y(16);
VY3 = y(17);
VZ3 = y(18);


%...Equations C.8:
R12 =norm([X2 - X1, Y2 - Y1,Z2-Z1])^3; 
R13 = norm([X3 - X1, Y3 - Y1,Z3-Z1])^3;
R23 =norm([X3 - X2, Y3 - Y2,Z3-Z2])^3 ;

%...Equations C.9:
AX1 = G*m2*(X2 - X1)/R12 + G*m3*(X3 - X1)/R13;
AY1 = G*m2*(Y2 - Y1)/R12 + G*m3*(Y3 - Y1)/R13;
AZ1 = G*m2*(Z2 - Z1)/R12 + G*m3*(Z3 - Z1)/R13;
AX2 = G*m1*(X1 - X2)/R12 + G*m3*(X3 - X2)/R23;
AY2 = G*m1*(Y1 - Y2)/R12 + G*m3*(Y3 - Y2)/R23;
AZ2 = G*m1*(Z1 - Z2)/R12 + G*m3*(Z3 - Z2)/R23;
AX3 = G*m1*(X1 - X3)/R13 + G*m2*(X2 - X3)/R23;
AY3 = G*m1*(Y1 - Y3)/R13 + G*m2*(Y2 - Y3)/R23;
AZ3 = G*m1*(Z1 - Z3)/R13 + G*m2*(Z2 - Z3)/R23;

AX21=AX2-AX1;
AY21=AY2-AY1;
AZ21=AZ2-AZ1;
AX31=AX3-AX1;
AY31=AY3-AY1;
AZ31=AZ3-AZ1;

dy= [VX1 VY1 VZ1 VX2 VY2 VZ2 VX3 VY3 VZ3 AX1 AY1 AZ1 AX21 AY21 AZ21 AX31 AY31 AZ31]';
