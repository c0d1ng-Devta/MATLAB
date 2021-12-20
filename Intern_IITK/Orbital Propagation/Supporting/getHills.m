function [r32h, v32h,r32l,v32l,C,Omega20] = getHills(y2, y3)

s=length(y2);
r32h=zeros(3,s);
v32h=zeros(3,s);
r32l=zeros(3,s);
v32l=zeros(3,s);
C=zeros(3,3,length(y2));
Omega20=zeros(length(y2),3);

    for i= 1:length(y2)
        R20 = y2(i,1:3);
        V20 = y2(i,4:6);
%         coeo20 = coe_from_sv(R20,V20,mu);% Intial Classical Orbital Elements of Planet -1 wrt Interial Frame.
%         if coeo20(2)<1
%             T = 2*pi/sqrt(mu)*coeo20(7)^1.5;
%         end
%         Omega2o=2*pi/T;% w of planet-1 wrt to origin of interial frame.
        R20_mag=norm(R20);
        Omega20(i,:)=cross(R20,V20)/R20_mag^2;

        exh=R20/norm(R20);%h is used for hills frame.
        ezh=cross(R20,V20)/norm(cross(R20,V20));
        eyh=cross(ezh,exh);
        C(:,:,i)=[exh; eyh; ezh ];

        r32=[y3(i,1) - y2(i,1); y3(i,2) - y2(i,2); y3(i,3) - y2(i,3)];
        v32=[y3(i,4) - y2(i,4); y3(i,5) - y2(i,5); y3(i,6) - y2(i,6)];
        
        r32h(1:3,i)=C(:,:,i)*r32;
        r32l(1:3,i)=C(:,:,i)\r32h(1:3,i);
        v32h(1:3,i)=C(:,:,i)*v32+cross(r32h(1:3,i),Omega20(i,:)');
        v32l(1:3,i)=C(:,:,i)\(v32h(1:3,i)-cross(r32h(1:3,i),Omega20(i,:)'));
    end
end