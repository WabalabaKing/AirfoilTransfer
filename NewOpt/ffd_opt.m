function [XX,YY] = ffd_opt(p,name,wri)
%formulate input
%constraint fix leading edge node
%constraint close geometry at trailing edge
p = [0.1,0.1,p(1:17),0.1*ones(1,1);-0.1,-0.1,p(18:34),-0.1*ones(1,1)];
%formulate FFD into symbolic expression spline
syms t
xu = p(1,:);
xl = p(2,:);
n = 20; %number of point
p_up =[0.0026693791104223;0.11837412578174;-0.377673942644822;1.99628275411997;-6.74532321130413;18.8219852124777;-41.3061533736232;74.1433067088848;-108.829023609802;132.315869997152;-133.125426774617;111.22160333879;-76.6111264273529;43.3842604261626;-19.8095101840905;7.25258528144861;-1.9986905802171;0.43828308640396;-0.0429712721065609;0.0126743325218791;0.00119605982459483];
p_down =[-0.00266936557388295;-0.118374629239519;0.377678509619046;-1.99629768126712;6.7453397807225;-18.8219282038591;41.305815582922;-74.1423514815611;108.827139286025;-132.313029356644;133.122038034795;-111.218360666964;76.6086316946872;-43.3827245199598;19.8087608848289;-7.25230024326936;1.99860823735994;-0.438265823075147;0.0429688603154428;-0.0126741486482857;-0.00119606247543706];
pupM =0.1-p_up;
pdnM = -0.1-p_down;
% initialize mapping vector for naca0012
%Construct original mesh
U = xu;
D = xl;
%FFD
UPFFD = (1-t)^n*(U(1)-pupM(1))+t^n*(U(end)-pupM(end));
DNFFD = (1-t)^n*(D(1)-pdnM(1))+t^n*(D(end)-pdnM(end));
for  j  = 1:n-1
    UPFFD = UPFFD+nchoosek(n,j)*(1-t)^(n-j)*t^j*(U(j+1)-pupM(j+1));
    DNFFD = DNFFD+nchoosek(n,j)*(1-t)^(n-j)*t^j*(D(j+1)-pdnM(j+1));
end
% xL = [sinspace(0.01,0.6,41,1.05),sinspace(0.615,1,40,0.9)]';
% xU = xL;

xL = linspace(0.001,1,81)';
xU = xL;
 %xL = [0.001;0.005;0.01;0.015;0.02;0.025;0.03;0.035;0.04;0.045;0.05;0.055;0.06;0.065;0.07;0.075;0.08;0.085;0.09;0.095;0.1;0.105;0.11;0.115;0.12;0.125;0.13;0.135;0.14;0.145;0.15;0.155;0.16;0.165;0.17;0.175;0.18;0.185;0.19;0.195;0.2;0.205;0.21;0.215;0.22;0.225;0.23;0.235;0.24;0.245;0.25;0.25625;0.2625;0.26875;0.275;0.28125;0.2875;0.29375;0.3;0.30625;0.3125;0.31875;0.325;0.33125;0.3375;0.34375;0.35;0.35625;0.3625;0.36875;0.375;0.38125;0.3875;0.39375;0.4;0.40625;0.4125;0.41875;0.425;0.43125;0.4375;0.44375;0.45;0.45625;0.4625;0.46875;0.475;0.48125;0.4875;0.49375;0.5;0.50625;0.5125;0.51875;0.525;0.53125;0.5375;0.54375;0.55;0.55625;0.5625;0.56875;0.575;0.58125;0.5875;0.59375;0.6;0.60625;0.6125;0.61875;0.625;0.63125;0.6375;0.64375;0.65;0.65625;0.6625;0.66875;0.675;0.68125;0.6875;0.69375;0.7;0.70625;0.7125;0.71875;0.725;0.73125;0.7375;0.74375;0.75;0.75625;0.7625;0.76875;0.775;0.78125;0.7875;0.79375;0.8;0.80625;0.8125;0.81875;0.825;0.83125;0.8375;0.84375;0.85;0.85625;0.8625;0.86875;0.875;0.88125;0.8875;0.89375;0.9;0.90625;0.9125;0.91875;0.925;0.93125;0.9375;0.94375;0.95;0.95625;0.9625;0.96875;0.975;0.98125;0.9875;0.99375;1];  
% xU = [0.001;0.005;0.01;0.015;0.02;0.025;0.03;0.035;0.04;0.045;0.05;0.055;0.06;0.065;0.07;0.075;0.08;0.085;0.09;0.095;0.1;0.105;0.11;0.115;0.12;0.125;0.13;0.135;0.14;0.145;0.15;0.155;0.16;0.165;0.17;0.175;0.18;0.185;0.19;0.195;0.2;0.205;0.21;0.215;0.22;0.225;0.23;0.235;0.24;0.245;0.25;0.25625;0.2625;0.26875;0.275;0.28125;0.2875;0.29375;0.3;0.30625;0.3125;0.31875;0.325;0.33125;0.3375;0.34375;0.35;0.35625;0.3625;0.36875;0.375;0.38125;0.3875;0.39375;0.4;0.40625;0.4125;0.41875;0.425;0.43125;0.4375;0.44375;0.45;0.45625;0.4625;0.46875;0.475;0.48125;0.4875;0.49375;0.5;0.50625;0.5125;0.51875;0.525;0.53125;0.5375;0.54375;0.55;0.55625;0.5625;0.56875;0.575;0.58125;0.5875;0.59375;0.6;0.60625;0.6125;0.61875;0.625;0.63125;0.6375;0.64375;0.65;0.65625;0.6625;0.66875;0.675;0.68125;0.6875;0.69375;0.7;0.70625;0.7125;0.71875;0.725;0.73125;0.7375;0.74375;0.75;0.75625;0.7625;0.76875;0.775;0.78125;0.7875;0.79375;0.8;0.80625;0.8125;0.81875;0.825;0.83125;0.8375;0.84375;0.85;0.85625;0.8625;0.86875;0.875;0.88125;0.8875;0.89375;0.9;0.90625;0.9125;0.91875;0.925;0.93125;0.9375;0.94375;0.95;0.95625;0.9625;0.96875;0.975;0.98125;0.9875;0.99375;1];
l = flip(xL(2:end));
u = xU(1:end-1);
XB = [u;l];
Yu = double(subs(UPFFD,xU));
Yl = double(subs(DNFFD,xL));
YB = [Yu(1:end-1);flip(Yl(2:end))];
%write airfoil into txt
X = XB;
Y = YB;
    XU = flip(X(1:end/2));
    YU = flip(Y(1:end/2));
    XL = flip(X(end/2+1:end));
    YL = flip(Y(end/2+1:end));
    XX = [XU;0;XL(1:end-1)];
    YY = [YU;0;YL(1:end-1)]; 
    XX = round(XX,4);
    YY = round (YY,4);
    
if wri ==1 
    WriteAirfoil(XX,YY,name);
end
end
