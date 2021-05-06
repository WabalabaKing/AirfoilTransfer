function [c,ceq] = nlcon(p)

%define nonlinear constraints in the fasion that:
%c<=0;
%ceq==0;
[XB,YB] = ffd_opt(p,'dump.txt',1);
 xu= XB(1:length(XB)/2);
 xl = flip(XB(length(XB)/2+1:end));
 yu= YB(1:length(YB)/2);
 yl = flip(YB(length(YB)/2+1:end));
T = yu-yl;
c(1) = -max(T) + 0.012;
[cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(160,0,3000000,1,1500,'dump.txt');
c(2) = cd-0.006;
ceq = [];
end