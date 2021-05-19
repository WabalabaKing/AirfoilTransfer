function [F,G] = objectiveF(p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if use adjoint aproach to calculate gradient, FD = 1;
% if use finite differencing to calculate gradient, FD = 0;
FD = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Re =   1000000;
clst  = 0.25;
iter = 50;
h  =1e-2;
wri = 1;
a = 0;
viscous = 1;
name = '0012.txt';
NN = 160;
[XX,YY] = ffd_opt(p,name,wri);
[cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
F = (1-(cl/clst))^2*1e-2;
if abs(cl-clst)>=0.001
if FD ==1
 try
[dcldx,dcmdx] = Grad(a,NN,Re,viscous,iter,h,x,m,p);
G = ((2*(1-cl/clst)*-1/clst).*dcldx)*0.7e-1;
 catch
    G = zeros(1,34);
 end
elseif FD ==0
    G = zeros(1,length(p));
    for i = 1:length(p)
        piter = p;
        piter(i) = p(i)+0.01;
        [XXi,YYi] = ffd_opt(piter,'FD.txt',1);
        try
        [dcl,dcd,dcm,CY,CD,x,y,CP,dm] = XFOILINTERFACE(NN,a,Re,viscous,iter,'FD.txt');
        G(i) = ((2*(1-cl/clst)*-1/clst)*((dcl-cl)/0.01))*1e-2;
        catch
            G(i) = 0;
        end
        
    end
end
else
    G = zeros(1,length(p));
    
end
figure(2)
hold on
plot(XX,YY);
axis equal;
grid minor
hold off
end