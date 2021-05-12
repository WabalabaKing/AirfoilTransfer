function [F,G] = objectiveF(p)
Re =   1000000;
clst  = 0.25;
iter = 500;
h  =1e-2;
wri = 1;
a = 0;
viscous = 1;
name = '0012.txt'
NN = 160;
[XX,YY] = ffd_opt(p,name,wri);
[cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
F = (1-(cl/clst))^2*0.7e-1;
 try
[dcldx,dcmdx] = Grad(a,NN,Re,viscous,iter,h,x,m,p);
G = ((2*(1-cl/clst)*-1/clst).*dcldx)*0.7e-1;
 catch
    G = zeros(1,34);
 end
figure(2)
hold on
plot(XX,YY);
axis equal;
grid minor
hold off
end