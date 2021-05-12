function [c,ceq] = nlcon(p)

%define nonlinear constraints in the fasion that:
%c<=0;
%ceq==0;
c = [0,0];
[XB,YB] = ffd_opt(p,'dump.txt',1);
 xu= XB(1:length(XB)/2);
 xl = flip(XB(length(XB)/2+1:end));
 yu= YB(1:length(YB)/2);
 yl = flip(YB(length(YB)/2+1:end));
T = yu-yl;
try
[cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(200,0,1000000,1,500,'dump.txt');
catch
    cd = 0.005;
end
c = [-max(T) + 0.115, cd-0.015]
ceq = [];
end