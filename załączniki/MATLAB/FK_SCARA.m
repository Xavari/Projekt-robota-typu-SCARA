clc; clear all; close all;
syms l0 l1 l2 q1 q2 q3;
%Wprowadzanie stałych:
l0=70/100; l1=100/100; l2=80/100;
%Wprowadzanie danych konfiguracyjnych:
q1=deg2rad(101.2989); q2=deg2rad(-107.0826); q3=-10/100;

a0 = 0; alpha0 = 0; d1 = l0; theta1 = q1;
a1 = l1; alpha1 = 0; d2 = 0; theta2 = q2;
a2 = l2; alpha2 = 0; d3 = -q3; theta3 = 0;
T_0_1 = DH(a0, alpha0, d1, theta1)
T_1_2 = DH(a1, alpha1, d2, theta2)
T_2_3 = DH(a2, alpha2, d3, theta3)
T_0_3 = T_0_1 * T_1_2 * T_2_3
x=T_0_3(1,4);
y=T_0_3(2,4);
z=T_0_3(3,4);
fprintf('x=%f\n', x);
fprintf('y=%f\n', y);
fprintf('z=%f\n', z);
kat=(asin(T_0_3(1,1)))*180/pi;
fprintf('Obrót wokół osi Z = %f stopni\n', kat);

%Wizualizacja
dhparams = [0   	0	    l0   	q1;
            l1	    0       0       q2;
            l2	    0       0       0;
            0	    0	    -q3	    0];


robot = rigidBodyTree;

bodies = cell(4,1);
joints = cell(4,1);
for i = 1:4
    bodies{i} = rigidBody(['body' num2str(i)]);
    if i== 4
         joints{i} = rigidBodyJoint(['jnt' num2str(i)],"prismatic");   
    else
        joints{i} = rigidBodyJoint(['jnt' num2str(i)],"revolute");
    end
    setFixedTransform(joints{i},dhparams(i,:),"dh");
    bodies{i}.Joint = joints{i};
    if i == 1 % Pierwszy element jako baza
        addBody(robot,bodies{i},"base")
    else
        addBody(robot,bodies{i},bodies{i-1}.Name)
    end
end
showdetails(robot)
config = homeConfiguration(robot);
show(robot);
config(2).JointPosition =q1;
config(3).JointPosition =q2;
config(4).JointPosition =q3;
show(robot,config);

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
