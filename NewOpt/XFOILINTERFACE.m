function [cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(NN,a,Re,viscous,iter,name)
%try to run xfoil 
%first specify some input
outp = "OUTPUT.txt"   ;   %this is where xfoil dumps CL,CD,CM etc;
CFDump = "DUMPCF.txt" ;   %this is where xfoil dumps Cf
CPDump = "DUMPCP.txt" ;   %this is where xfoil dumps Cp data 
%write batch for xfoil
fid = fopen('xfoil_input.txt','w+');
       fprintf(fid,'plop \n');
       fprintf(fid,'G \n');
       fprintf(fid,' \n');
       fprintf(fid,'load \n');
       fprintf(fid,'%s\n',name);
       fprintf(fid,'\n');
       fprintf(fid,'PPAR\n');
       fprintf(fid,'t\n');
       fprintf(fid,'0.5 \n');
       fprintf(fid,'\n');
       fprintf(fid,'\n');
       fprintf(fid,'PANE');
       fprintf(fid,'\n');
       fprintf(fid,'\n');
       fprintf(fid,'PSAVE\n');
       fprintf(fid,'tempAir.txt\n');
       fprintf(fid,'\n');
       fprintf(fid,'\n');
       fprintf(fid,'OPER \n');
       fprintf(fid,'a \n');
       fprintf(fid,'%i \n',a);
       fprintf(fid,'\n');
       
%
       fprintf(fid,'OPER \n');
       if viscous ==1
            fprintf(fid,'visc \n');
            fprintf(fid,'%i \n',Re);
       end
       fprintf(fid,'iter \n');
       fprintf(fid,"%i\n",iter);
       fprintf(fid,'pacc \n');
       fprintf(fid,"%s\n",outp);
       fprintf(fid,'\n');
       fprintf(fid,'a \n');
       fprintf(fid,'%i \n',a);

       fprintf(fid,'CPWR \n');
       fprintf(fid,'%s \n',CPDump);
       if viscous ==1
            fprintf(fid,'DUMP \n');
            fprintf(fid,'%s \n',CFDump);   
       end
       fclose(fid);
       comand = 'xfoil.exe< xfoil_input.txt ';
       system(comand);
%%Now xfoil finished running, retreive useful data

%This gives conventional aerodynamic properties
fidC = fopen(outp);
       dataBuffer = textscan(fidC,'%f %f %f %f %f','HeaderLines',12,...                 
                            'CollectOutput',1,...
                            'Delimiter','');
fclose(fidC); 
alpha = dataBuffer{1,1}(:,1);
cl  = dataBuffer{1,1}(:,2);
cd  = dataBuffer{1,1}(:,3);
cm  = dataBuffer{1,1}(:,5);
alpha = alpha(1,1);
cl = cl(1,1);
cd = cd(1,1);
cm = cm(1,1);
delete('OUTPUT.txt');
%This Gives more panel based force/load property
fidCP = fopen(CPDump);
       dBCp = textscan(fidCP,'%f %f %f','HeaderLines',3,...                 
                            'CollectOutput',1,...
                            'Delimiter','');
fclose(fidCP);
if viscous ==1       
fidCF = fopen(CFDump);
       dBCf = textscan(fidCF,'%f %f %f %f %f %f %f %f','HeaderLines',1,...                 
                            'CollectOutput',1,...
                            'Delimiter','');
fclose(fidCF); 
end
%start to load useful data;
CP = dBCp{1,1}(:,3);
fidA = fopen('tempAir.txt');
 Coord = textscan(fidA,'%f %f ','HeaderLines',0,...                 
                            'CollectOutput',1,...
                            'Delimiter','');
fclose(fidA);
X = Coord{1,1}(:,1);
Y = Coord{1,1}(:,2);
if viscous ==1
CF = dBCf{1,1}(:,7);
S = dBCf{1,1}(:,1);
ThetaBL = dBCf{1:1}(:,6);
Dstar = dBCf{1:1}(:,5);
Ue = dBCf{1:1}(:,4);
m = Ue.*Dstar;
end
x = X;
% start calculating normal and tangential forces at each panel
%%
x = [X;X(1)];
y = [Y;Y(1)];
n = length(x)-1;
DX = zeros(1,n);
DY = zeros(1,n);
CY = zeros(1,n);
CDP = zeros(1,n);
CDf = zeros(1,n);
CP = [CP;CP(1)];
for i = 1:n
DX(i) = (x(i+1)-x(i))*cosd(a)+(y(i+1)-y(i))*sind(a);
DY(i) = -(x(i+1)-x(i))*sind(a)+(y(i+1)-y(i))*cosd(a);
CY(i) = 0.5*(CP(i)+CP(i+1))*DX(i);
CDP(i) = -0.5*(CP(i)+CP(i+1))*DY(i);
if viscous ==1
CDf(i) =  abs((CF(i))*DX(i));
end
end
x = x(1:end-1);
y = y(1:end-1);
CD = CDP+CDf;
%Check total number to see if correct
Lift = sum(CY)
DragP = sum(CDP)
DragF = sum(CDf)
