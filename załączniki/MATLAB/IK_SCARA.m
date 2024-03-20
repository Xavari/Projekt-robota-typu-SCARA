clc; clear all; close all;
syms l0 l1 l2 q1 q2 q3 ik_x ik_y ik_z ikq1 ikq2 ikq3;
%Współrzędne docelowe:
ik_x=60/100;
ik_y=90/100;
ik_z=80/100;
%Stałe:
l0=70/100; l1=100/100; l2=80/100;
%Układ równań:
ik=[
    ik_x==l2*(cos(q1)*cos(q2) - sin(q1)*sin(q2)) + l1*cos(q1);
    ik_y==l2*(cos(q1)*sin(q2) + cos(q2)*sin(q1)) + l1*sin(q1);
    ik_z==l0 - q3;
];
%Funkcja Matlab'a rozwiązująca układy równań:
S=solve(ik, [q1 q2 q3]);
%przypisanie wartości poszczególnych zmiennych konfiguracyjnych do
%zmiennej oraz zamiana radianów na stopnie
ikq1=eval(subs(S.q1))*180/pi;
ikq2=eval(subs(S.q2))*180/pi;
ikq3=eval(subs(S.q3));
%Wyświetlenie rozwiązań q1
disp('q1:');
disp(ikq1);
%Wyświetlenie rozwiązań q2
disp('q2:');
disp(ikq2);
%Wyświetlenie rozwiązań q3
disp('q3:');
disp(ikq3(1,1));
%Rozwiązanie
Roz=1;
Q_1=ikq1(Roz,1);
Q_2=ikq2(Roz,1);
Q_3=ikq3(Roz,1);

%Wizualizacja
dhparams = [0   	0	    l0   	Q_1;
            l1	    0       0       Q_2;
            l2	    0       0       0;
            0	    0	    -Q_3    0];
double(subs(dhparams));

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
    if i == 1 % Add first body to base
        addBody(robot,bodies{i},"base")
    else % Add current body to previous body by name
        addBody(robot,bodies{i},bodies{i-1}.Name)
    end
end

showdetails(robot)
config = homeConfiguration(robot);
show(robot);
config(2).JointPosition =deg2rad(Q_1);
config(3).JointPosition =deg2rad(Q_2);
config(4).JointPosition =Q_3;
show(robot,config);

