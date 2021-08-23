function [r32h, v32h] = getHills(y2, y3)

global mu

    for i= 1:length(y2)
        Ro20 = y2(i,1:3);
        Vo20 = y2(i,4:6);
        coeo20 = coe_from_sv(Ro20,Vo20,mu);% Intial Classical Orbital Elements of Planet -1 wrt Interial Frame.
        if coeo20(2)<1
            T = 2*pi/sqrt(mu)*coeo20(7)^1.5;
        end
        Omega2o=2*pi/T;% w of planet-1 wrt to origin of interial frame.

        exh=Ro20/norm(Ro20);%h is used for hills frame.
        ezh=cross(Ro20,Vo20)/norm(cross(Ro20,Vo20));
        eyh=cross(ezh,exh);
        C=[exh; eyh; ezh ];

        r32=[y3(i,1) - y2(i,1); y3(i,2) - y2(i,2); y3(i,3) - y2(i,3)];
        v32=[y3(i,4) - y2(i,4); y3(i,5) - y2(i,5); y3(i,6) - y2(i,6)];

        r32h(i,1:3)=[C*r32];
        v32h(i,1:3)=C*v32+r32h(i,1:3)'*Omega2o;
    end

end