function [F,G] = objectiveF(p)
Re = 3000000;
clst  = 0.3;
iter = 1500;
h  =1e-2;
wri = 1;
a = 0;
viscous = 1;
name = '0012.txt'
NN = 160;
[XX,YY] = ffd_opt(p,name,wri);
[cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
F = (1-cl/clst)^2*1e-4;
[dcldx,dcmdx] = Grad(a,NN,Re,viscous,iter,h,x,m,p);
G = -2.*dcldx./clst*1e-4;
G(1) = 0;
G(21) = 0;
G(20) = 0;
G(40) = 0;
figure(2)
hold on
plot(XX,YY);
axis equal;
grid minor
hold off
end