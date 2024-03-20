clc; clear all; close all;
syms l0 l1 l2 q1 q2 q3;
%Stałe:
l0=70; l1=50; l2=50;
%Dane konfiguracyjne:
%q1=30; q2=45; q3=30;

a0 = 0; alpha0 = 0; d1 = l0; theta1 = q1;
a1 = l1; alpha1 = 0; d2 = 0; theta2 = q2;
a2 = l2; alpha2 = 0; d3 = -q3; theta3 = 0;
T_0_1 = DH(a0, alpha0, d1, theta1)
T_1_2 = DH(a1, alpha1, d2, theta2)
T_2_3 = DH(a2, alpha2, d3, theta3)
T_0_3 = T_0_1 * T_1_2 * T_2_3
%x=T_0_3(1,4);
%y=T_0_3(2,4);
%z=T_0_3(3,4);
%fprintf('x=%f\n', x);
%fprintf('y=%f\n', y);
%fprintf('z=%f\n', z);
%kat=(asin(T_0_3(1,1)))*180/pi;
%fprintf('kąt obrotu=%f\n', kat);
syms ik_x ik_y ik_z ikq1 ikq2 ikq3;
ik_x=100;
ik_y=0;
ik_z=30;
ik=[
    ik_x==l2*(cos(q1)*cos(q2) - sin(q1)*sin(q2)) + l1*cos(q1);
    ik_y==l2*(cos(q1)*sin(q2) + cos(q2)*sin(q1)) + l1*sin(q1);
    ik_z==l0 - q3;
];
S=solve(ik, [q1 q2 q3]);
ikq1=eval(subs(S.q1));
ikq2=eval(subs(S.q2));
ikq3=eval(subs(S.q3));
%fprintf('q1=%f\n', ikq1);
%fprintf('q2=%f\n', ikq2);
%fprintf('q3=%f\n', ikq3);
disp('q1:');
disp(ikq1*180/pi);

disp('q2:');
disp(ikq2*180/pi);

disp('q3:');
disp(ikq3);


function T = TwistX(a, alpha)
 ca = cos(alpha);
 sa = sin(alpha);
 T = [
 1 0 0 a
 0 ca -sa 0
 0 sa ca 0
 0 0 0 1
 ];
end
function T = TwistZ(d, theta)
 ct = cos(theta);
 st = sin(theta);
 T = [
 ct -st 0 0
 st ct 0 0
 0 0 1 d
 0 0 0 1
 ];
end
function T = DH(a, alpha, d, theta)
 T = TwistX(a, alpha) * TwistZ(d, theta);
end
