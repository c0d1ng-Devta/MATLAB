function uc=NFOC(e, K0, Ts, Kp, Ti, Td, lambda, delta, k)
%Non-Linear Fractional Order PID Controller.
% function uc = NFOC(e, K0, Ts, Kp, Ti, Td, lambda, delta, k)
% Digital Nonlinear Fractional Order PID Controller of the form: 
% u(t)=f(e(t))*(Kp*e(t) + Ti*D^-lambda e(t) + Td*D^delta e(t)), 
% where f(e(t)) is nonlinearity and Ts (sec) is sampling period.
% Approximation method is based on Grunwald-Letnikov definition.
%
% Input parameters:     
% e:    vector of control errors
% K0:   parameter of nonlinear function f(e(t))=K0+(1-K0)*|e(t)|
% Ts:   sampling period in (sec)
% Kp:   (P)roportional constant
% Ti:   (I)ntegration constant
% Td:   (D)erivative constant
% lambda:  order of fractional integral
% delta:   order of fractional derivative
% k:       actual position in time sequence
%
% Output parameter:
% uc : control action (single value) applicable for the actuator
%
% Example:  u = NFOC(error, 1, 0.1, 20, 100, 3.5, 1.2, 0.8, i);
%
% Note:     If K0=1 then we obtain a linear fractional controller.
%
% Copyright (c), 2015. Author: Ivo Petras (ivo.petras@tuke.sk)
%
bc=cumprod([1,1-((-lambda+1)./[1:k])]); 
bd=cumprod([1,1-((delta+1)./[1:k])]); 
%
uc = (K0+(1-K0)*abs(e(k)))*(Kp*e(k) + Ti*Ts^(lambda)*memo(e, bc, k) + Td*Ts^(-delta)*memo(e, bd, k));
% memo() function is external function for calculation the sums