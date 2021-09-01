% Rough example of non-linear HCW
% rt_Vec, vt_Vec: Position and velocity vectors of target in Hill frame. Propagated separately
% rt and vT may be integrated along with this additional state variables
function dx = nonlinear_HCW_matrix_diff_equ(x, rt_Vec, vt_Vec)

    global mu h_t

    rt = norm(rt_Vec);

    rc_Vec = [rt+x(1);
              x(2);
              x(3)];
    rc = norm(rc_Vec);

    theta_dot = h_t/rt^2;
    rt_dot = vt_Vec(1);
    theta_dotdot = -2*rt_dot*theta_dot/rt;

    A = [zeros(3)                               eye(3);
         (-mu/rc^3 + theta_dot^2)   theta_dotdot                0           0               2*theta_dot     0;
         -theta_dotdot              (-mu/rc^3 + theta_dot^2)    0           -2*theta_dot    0               0;
         0                          0                           -mu/rc^3    0               0               0];

    B = [0;
         0;
         0;
         -mu*(rt_Vec(1)/rc^3) + (mu/rt^2);
         0;
         0];

dx = A*x + B;