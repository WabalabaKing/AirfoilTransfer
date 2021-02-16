function [F,G] = objectiveF(p)
    Re = 10000000;
    a  = 0;
    iter = 1500;
    increment = 0.01;
    clst = 0.5;
    cdst = 0.003;
    [name,X,Y] = ffd_opt(p,'airfoil.txt');
    [CL,CD,CM,c] = callxfoilFA(name,a,iter,Re);
    F = 10^-4*(1-CL/clst)^2+10^-4*(1-cdst/CD)^2;
    [dcl,dcd,dcm] = gradient(Re,a,iter,p,increment);
    G = zeros(1,length(p));
    for i = 1:length(p)
        if dcd~=0
            G(i) = 10^-5*2*(1-CL/clst)*(-1/(clst))*dcl(i)+10^-5*2*(1-cdst/CD)*(cdst)*dcd(i)^-2;
        else
            G(i) = 10^-5*2*(1-CL/clst)*(-1/(clst))*dcl(i)+0;
        end
    end
end