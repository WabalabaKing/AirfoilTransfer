function [F,G] = objectiveF(p)
    Re = 5000000;
    clst  = .5;
    iter = 3000;
    increment = 0.1;
    
    [name,X,Y] = ffd_opt(p,'airfoil.txt');
    [CL,CD,CM,alpha,c] = callxfoilFCL(name,clst,iter,Re);
    F = 0.1*CD;
    [dcl,dcd,dcm] = gradient(Re,clst,iter,p,increment);
    G = zeros(1,length(p));
    for i = 1:length(p)
    G(i) = 0.1*dcd(i);
    end
end