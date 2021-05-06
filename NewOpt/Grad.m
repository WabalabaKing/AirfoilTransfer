function [dcldx,dcmdx] = Grad(a,NN,Re,viscous,iter,h,x,m,p)
%Define the problem

name = 'tempAir.txt';

[cl,cd,cm,CY,CD,XX,YY,CP,m] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
m = [m(1:NN);m(1)];
x = [x(1:NN);x(1)];
dmdx  = zeros(NN,1);
for i = 1:NN
    dmdx(i) = (m(i+1)-m(i))/(abs(x(i+1)-x(i)));
end
dmdx = [dmdx(1:NN-1);dmdx(1)].*[-1*ones(NN/2,1);1*ones(NN/2,1)];
[AIC,b,gam,DCP,cp] = getAIC(a,XX,YY,1,h,dmdx);

dRdx = dResdx(XX,YY,a,p,h,gam,b,AIC,dmdx);

[dclA,dcmA] = finderiv(a,XX,YY,gam,DCP);
% Analytical
APr = AIC(1:end,1:end);
dcldx = (-(APr^-1)'*dclA)'*dRdx(1:end,:);
dcmdx = (-(APr^-1)'*dcmA)'*dRdx(1:end,:);
end