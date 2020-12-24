function [cl,cd,cm] = callxfoilFA(name,alpha,iter,Re)
       outp = "Save_airfoil"+name;
       fid = fopen('xfoil_input.txt','w+');
%        fprintf(fid,'plop \n');
%        fprintf(fid,'G \n');
%        fprintf(fid,' \n');
       fprintf(fid,'load \n');
       fprintf(fid,'%s\n',name);
       fprintf(fid,'\n');
       fprintf(fid,'PPAR\n');
       fprintf(fid,'N\n');
       fprintf(fid,' 160 \n');
%        fprintf(fid,' XB \n');
%        fprintf(fid,' 0.9 \n');
%        fprintf(fid,' 1 \n');
%        fprintf(fid,' R \n');
%        fprintf(fid,' 0.1 \n');
       fprintf(fid,'\n');
       fprintf(fid,'\n');
%
       fprintf(fid,'PANE\n');
       fprintf(fid,'\n');       
%
       fprintf(fid,'OPER \n');
       fprintf(fid,'visc \n');
       fprintf(fid,'%i \n',Re);
       fprintf(fid,'iter \n');
       fprintf(fid,"%i\n",iter);
       fprintf(fid,'pacc \n');
       fprintf(fid,"%s\n",outp);
       fprintf(fid,'\n');
       fprintf(fid,'a \n');
       fprintf(fid,'%i \n',alpha);
       fclose(fid);
       cmd = 'xfoil.exe < xfoil_input.txt ';
       system(cmd);
       fidCP = fopen(outp);
       dataBuffer = textscan(fidCP,'%f %f %f %f %f','HeaderLines',12,...                 
                            'CollectOutput',1,...
                            'Delimiter','');
       fclose(fidCP); 
       AoA = dataBuffer{1,1}(:,1);
       cl  = dataBuffer{1,1}(:,2);
       cd  = dataBuffer{1,1}(:,3);
       cm  = dataBuffer{1,1}(:,5);
       cl = cl(1,1);
       cd = cd(1,1);
       cm = cm(1,1);
       
       delete(outp)
    end