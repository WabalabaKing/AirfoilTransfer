close all
clear all
parameters=[0.1*ones(1,17),-0.1*ones(1,17)];
Re = 1000000;
clst  = 0.25;
iter = 500;
% UB = [linspace(0.14,0.11,17),linspace(-0.07,-0.09,17)];
% LB = [lnspace(0.07,0.09,17),linspace(-0.14,-0.11,17)];
p = parameters;
bo =  0.2*p(1);
UB = [(p(1)+bo)*ones(1,17),(-p(1)+bo)*ones(1,17)];
LB = [(p(1)-bo)*ones(1,17),(-p(1)-bo)*ones(1,17)];
options = optimoptions(@fmincon, ...
    'Display','iter','Algorithm','sqp','SpecifyObjectiveGradient',true,...
    'PlotFcn', {@optimplotfval},'FunctionTolerance',1e-4,'StepTolerance',1e-4);
diary optlog.txt
[xopt,fopt] = fmincon('objectiveF',parameters,[],[],[],[],LB,UB,@nlcon,options);
diary off

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