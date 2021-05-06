close all
clear all
parameters=[0.1*ones(1,20),-0.1*ones(1,20)];
Re = 3000000;
clst  = 0.3;
iter = 1500;
UB = [0.15*ones(1,20),-0.06*ones(1,20)];
LB = [0.06*ones(1,20),-0.15*ones(1,20)];
options = optimoptions(@fmincon, ...
    'Display','iter','Algorithm','sqp','SpecifyObjectiveGradient',true,...
    'PlotFcn', {@optimplotfval},'FunctionTolerance',1e-4);

[xopt,fopt] = fmincon('objectiveF',parameters,[],[],[],[],LB,UB,'nlcon',options);