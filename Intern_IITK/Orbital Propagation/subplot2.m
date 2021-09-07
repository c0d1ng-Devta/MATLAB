function subplot2(y,T)

subplot(2,1,1)

plot(T,y(:,1),'-k')
hold on
plot(T,y(:,2),'-b')
plot(T,y(:,3),'-r')
title('Distance')
hold off

subplot(2,1,2)
plot(T,y(:,4),'-y')
hold on
plot(T,y(:,5),'-c')
plot(T,y(:,6),'-g')
title('Velocity ')
hold off
end