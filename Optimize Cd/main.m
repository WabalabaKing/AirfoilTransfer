close all
clear all
parameters=[0.1*ones(1,9),-0.1*ones(1,8)];
Re = 3000000;
clst  = 0.5;
iter = 1500;
UB = [0.3*ones(1,9),0.05*ones(1,8)];
LB = [0*ones(1,9),-0.2*ones(1,8)];
options = optimoptions(@fmincon, ...
    'Display','iter','Algorithm','sqp','SpecifyObjectiveGradient',true,...
    'PlotFcn', {@optimplotfval},'FunctionTolerance',1e-5);

[xopt,fopt] = fmincon('objectiveF',parameters,[],[],[],[],LB,UB,'nlcon',options);
%%
formatSpec = '%f %f';
id = fopen('NACA0015.txt');
C = textscan(id,formatSpec);
XB = C{:,1};
YB = C{:,2};
fclose(id);
id = fopen('airfoil.txt');
C = textscan(id,formatSpec);
XO = C{:,1};
YO = C{:,2};
fclose(id);
figure(3)
hold on
plot(XB,YB);
plot(XO,YO);
axis equal
legend('base 0015','optimized')






