function[dcl,dcd,dcm] = gradient(Re,clst,iter,p,increment)
    dcl = zeros(1,17);
    dcd = zeros(1,17);
    dcm = zeros(1,17);
    
    [nameb,Xb,Yb] = ffd_opt(p,'airfoil.txt');
    [cl_b,cd_b,cm_b,alpha,c] = callxfoilFCL(nameb,clst,iter,Re);
    named = strings([1,length(p)]);
    for i = 1:17
        named(i) = "airfoil"+string(i)+".txt";
    end
    for i = 1:17
        param = p;
        param(i) = p(i)+increment*(p(i)-0.05);
        [named(i),Xd,Yd] = ffd_opt(param,named(i));
        [cl_t,cd_t,cm_t,alpha,c] = callxfoilFCL(named(i),clst,iter,Re);
        if c==1
            dcl(i) = (cl_t-cl_b)/(increment*(p(i)-0.05));
            dcd(i) = (cd_t-cd_b)/(increment*(p(i)-0.05));
            dcm(i) = (cm_t-cm_b)/(increment*(p(i)-0.05));
        elseif c==0
            dcl(i) = 0;
            dcd(i) = 0;
            dcm(i) = 0;
        end
    end

end
