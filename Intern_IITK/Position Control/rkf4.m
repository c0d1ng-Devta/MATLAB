function [tout, yout] = rkf4(ode_function, tspan, y0)
h=5;
a= [0 1/2 1/2 1];
b = [0 0 0;1/2 0 0;0 1/2 0;0 0 1];
c = [1/6 1/3 1/3 1/6];
t0 = tspan(1);
tf = tspan(2);
t = t0;
y = y0;
tout = t;
yout = y';
while t < tf
ti = t;
yi = y;

for i = 1:4
t_inner = ti + a(i)*h;
y_inner = yi;
for j = 1:i-1
y_inner = y_inner + h*b(i,j)*f(:,j);
end
f(:,i) = feval(ode_function, t_inner, y_inner);
end
h = min(h, tf-t);
t = t + h;
y = yi + h*f*c';
tout = [tout;t]; 
yout = [yout;y']; 
end
end

