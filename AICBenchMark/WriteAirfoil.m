function WriteAirfoil(X,Y,name)
    fid = fopen(name,'w+');
    for i = 1:length(X)
        fprintf(fid,'%f %f \n',X(i),Y(i));
    end
   fclose(fid);
end