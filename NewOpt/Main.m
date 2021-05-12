close all
clear all
parameters=[0.1*ones(1,17),-0.1*ones(1,17)];
Re = 1000000;
clst  = 0.25;
iter = 500;
% UB = [linspace(0.14,0.11,17),linspace(-0.07,-0.09,17)];
% LB = [lnspace(0.07,0.09,17),linspace(-0.14,-0.11,17)];
UB = [0.15*ones(1,17),-0.07*ones(1,17)];
LB = [0.08*ones(1,17),-0.15*ones(1,17)];
options = optimoptions(@fmincon, ...
    'Display','iter','Algorithm','interior-point','SpecifyObjectiveGradient',true,...
    'PlotFcn', {@optimplotfval},'FunctionTolerance',1e-4,'StepTolerance',1e-6);

[xopt,fopt] = fmincon('objectiveF',parameters,[],[],[],[],LB,UB,@nlcon,options);
%%
[X,Y] = ffd_opt(xopt,'optimized.txt',1);
a = 0;
NN = 160;
viscous = 1;
[cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(NN,a,Re,viscous,iter,'optimized.txt');
figure(3)
plot(x,y)
axis equal
title('optimized airfoil')