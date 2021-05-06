%Define the problem
name = '0012b.txt';
tic
a = 5;
NN = 340;
Re = 3000000;
viscous = 1;
iter = 5000;
h = 0.01;

p=[0.1*ones(1,20),-0.1*ones(1,20)];

[XX,YY] = ffd_opt(p,name,1);
 [cl,cd,cm,CY,CD,x,y,CP,m] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
m = [m(1:NN);m(1)];
x = [x(1:NN);x(1)];
dmdx  = zeros(NN,1);
for i = 1:NN
    dmdx(i) = (m(i+1)-m(i))/(abs(x(i+1)-x(i)));
end
dmdx = [dmdx(1:NN-1);dmdx(1)].*[-1*ones(NN/2,1);1*ones(NN/2,1)];
[AIC,b,gam,DCP,cp] = getAIC(a,XX,YY,1,h,dmdx);

dRdx = dResdx(XX,YY,a,p,h,gam,b,AIC,dmdx);

[dclA,dcmA] = finderiv(a,XX,YY,gam,DCP);
% Analytical
NN  =160;
APr = AIC(1:end,1:end);
dcldx = (-(APr^-1)'*dclA)'*dRdx(1:end,:);
dcmdx = (-(APr^-1)'*dcmA)'*dRdx(1:end,:);
anat = toc;
%% Finite Difference
tic 
[cl,cd,cm,CY,CD,x,y,CP,~] = XFOILINTERFACE(NN,a,Re,viscous,iter,name);
name2 = "0012i.txt";
dcldxD = dcldx;
dcmdxD = dcldx;
for i = 1:length(p)
    piter = p;
    piter(i) = p(i)+h;
    [XX,YY] = ffd_opt(piter,name2,1);
    [cli,cdi,cmi,CYi,CDi,xi,yi,CP,~] = XFOILINTERFACE(NN,a,Re,viscous,iter,name2);
    dcldxD(i) = (cli-cl)/h;
    dcmdxD(i) = (cmi-cm)/h;
end
FD = toc;


%%
figure(1)
hold on

plot(linspace(1,length(p),length(p)),dcldx)
scatter(linspace(1,length(p),length(p)),dcldxD)
ylim ([-3,3]);
legend ('a','XfoilFD')
anat = ['analytical time = ', num2str(anat)];
FD = ['FD time = ', num2str(FD)];
hold off
figure(2)
hold on
plot(linspace(1,length(p),length(p)),dcmdx)
scatter(linspace(1,length(p),length(p)),dcmdxD)
ylim ([-3,3]);
legend ('a','XfoilFD')
anat = ['analytical time = ', num2str(anat)];
FD = ['FD time = ', num2str(FD)];
disp(anat);
disp(FD);
