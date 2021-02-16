function [cl,cd,cm,alpha,c] = callxfoilFCL(name,clst,iter,Re)
       outp = "Save_airfoil"+name;
       fid = fopen('xfoil_input.txt','w+');
       fprintf(fid,'plop \n');
       fprintf(fid,'G \n');
       fprintf(fid,' \n');
       fprintf(fid,'load \n');
       fprintf(fid,'%s\n',name);
       fprintf(fid,'\n');
       fprintf(fid,' GDES \n');
       fprintf(fid,' CADD \n');
       fprintf(fid,' 25 \n');
       fprintf(fid,' \n');
       fprintf(fid,' \n');
       fprintf(fid,' \n');
       fprintf(fid,' XB \n');
       fprintf(fid,' 0.9 \n');
       fprintf(fid,' 1 \n');
       fprintf(fid,' R \n');
       fprintf(fid,' 0.1 \n');
       fprintf(fid,'\n');
       fprintf(fid,'\n');
%
       fprintf(fid,'PANE\n');
       fprintf(fid,'\n');       
%
       fprintf(fid,'OPER \n');
       fprintf(fid,'v \n');
       fprintf(fid,'%i \n',Re);
       fprintf(fid,'iter \n');
       fprintf(fid,"%i\n",iter);
       fprintf(fid,'pacc \n');
       fprintf(fid,"%s\n",outp);
       fprintf(fid,'\n');
       fprintf(fid,'cl \n');
       fprintf(fid,'%i \n',clst);
       fclose(fid);
       cmd = 'xfoil.exe < xfoil_input.txt ';
       system(cmd);
       pause(0.1);
       try
       fidCP = fopen(outp);
       dataBuffer = textscan(fidCP,'%f %f %f %f %f','HeaderLines',12,...                 
                            'CollectOutput',1,...
                            'Delimiter','');
       fclose(fidCP); 
       alpha = dataBuffer{1,1}(:,1);
       cl  = dataBuffer{1,1}(:,2);
       cd  = dataBuffer{1,1}(:,3);
       cm  = dataBuffer{1,1}(:,5);
       alpha = alpha(1,1);
       cl = cl(1,1);
       cd = cd(1,1);
       cm = cm(1,1);
       c = 1;   %solver converged
       catch
       c = 0;    %solver not converged
       end
       delete(outp)
    end