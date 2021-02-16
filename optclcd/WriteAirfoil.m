function WriteAirfoil(X,Y,name)
    fid = fopen(name,'w+');
    XU = flip(X(1:end/2));
    YU = flip(Y(1:end/2));
    XL = flip(X(end/2+1:end));
    YL = flip(Y(end/2+1:end));
    XX = [XU;0;XL(1:end-1)];
    YY = [YU;0;YL(1:end-1)];
    XX = XX(1:2:end);
    XX(1) = 1;
    XX(end) = 1;
    YY = YY(1:2:end);
    YY(end) = YY(1)-0.01; 
    for i = 1:length(XX)
        fprintf(fid,'%f %f \n',XX(i),YY(i));
    end
   fclose(fid);
end