%Define the problem
name = '0012b.txt';
tic
a = 8;
NN = 160;
Re = 3000000;
viscous = 1;
iter = 5000;
h = 1e-3;

p=[0.1*ones(1,10),-0.1*ones(1,10)];

[XX,YY] = ffd_opt(p,name,1);
% [cl,cd,cm,CY,CD,x,y,CP] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
% gam = load("GAMA.DAT");
[AIC,b,gam,DCP] = getAIC(a,XX,YY,1);


% % hold on
% % plot(XX,DCP)
% % scatter(x,CP(1:end-1))
% % ylim([-3,1])


dRdx = dResdx(XX,YY,a,p,h,gam,b,AIC);

[dclA,dcmA] = finderiv(a,XX,YY,gam,DCP);
% Analytical

APr = AIC(1:end,1:end);
dcldx = (-(APr^-1)'*dclA)'*dRdx(1:end,:);
dcmdx = (-(APr^-1)'*dcmA)'*dRdx(1:end,:);
anat = toc;
%% Finite Difference
tic 
[cl,cd,cm,CY,CD,x,y,CP] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
name2 = "0012i.txt";
dcldxD = dcldx;
dcmdxD = dcldx;
for i = 1:length(p)
    piter = p;
    piter(i) = p(i)+h;
    [XX,YY] = ffd_opt(piter,name2,1);
    [cli,cdi,cmi,CYi,CDi,xi,yi,CP] = XFOILINTERFACE(NN,a,Re,viscous,iter,name2);
    dcldxD(i) = (cli-cl)/h;
    dcmdxD(i) = (cmi-cm)/h;
end
FD = toc;


%%
figure(1)
hold on

plot(linspace(1,length(p),length(p)),dcldx)
scatter(linspace(1,length(p),length(p)),dcldxD)
legend ('a','XfoilFD')
anat = ['analytical time = ', num2str(anat)];
FD = ['FD time = ', num2str(FD)];
hold off
figure(2)
hold on
plot(linspace(1,length(p),length(p)),dcmdx)
scatter(linspace(1,length(p),length(p)),dcmdxD)
legend ('a','XfoilFD')
anat = ['analytical time = ', num2str(anat)];
FD = ['FD time = ', num2str(FD)];
disp(anat);
disp(FD);
