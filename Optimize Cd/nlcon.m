function [c,ceq] = nlcon(p)

%define nonlinear constraints in the fasion that:
%c<=0;
%ceq==0;
[name,XB,YB] = ffd_opt(p,'dump');
 xu= XB(1:length(XB)/2);
 xl = flip(XB(length(XB)/2+1:end));
 yu= YB(1:length(YB)/2);
 yl = flip(YB(length(YB)/2+1:end));
T = yu-yl;
c = -max(T) + 0.012;
ceq = [];
end