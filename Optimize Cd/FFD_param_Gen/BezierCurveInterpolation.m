formatSpec = '%f %f';
id = fopen('NACA0015.txt');
C = textscan(id,formatSpec);
fclose(id);
XB = C{:,1};
YB = C{:,2};
n = 10;
 xu= XB(1:length(XB)/2);
 xl = flip(XB(length(XB)/2+1:end));
 yu= YB(1:length(YB)/2);
 yl = flip(YB(length(YB)/2+1:end));
 N = length(xu);
%     n = 10; %number of point
U = ones(1,n+1);
D = -1*ones(1,n+1);
syms t
        A =  zeros(N,n+1);  %upper interpolation matrix
        B =  zeros(N,n+1); %lower interpolation matrix
for i = 1:N
A(i,1) = (1-xu(i))^n;
A(i,end) = xu(i)^n;
B(i,1) = (1-xl(i))^n;
B(i,end) = xl(i)^n;
for j = 1:n-1
    A(i,j+1) = nchoosek(n,j)*(1-xu(i))^(n-j)*xu(i)^j;
    B(i,j+1) = nchoosek(n,j)*(1-xl(i))^(n-j)*xl(i)^j;
end
end
p_up = linsolve(A,yu);
p_down = linsolve(B,yl);
%mapping to rectabular boundary
pupM =0.1-p_up;
pdnM = -0.1-p_down;
UP = (1-t)^n*p_up(1)+t^n*p_up(end);
DN = (1-t)^n*p_down(1)+t^n*p_down(end);
for  j  = 1:n-1
    UP = UP+nchoosek(n,j)*(1-t)^(n-j)*t^j*p_up(j+1);
    DN = DN+nchoosek(n,j)*(1-t)^(n-j)*t^j*p_down(j+1);
end
%Construct original mesh
U = 0.1*ones(1,length(p_up));
D = -1*0.1*ones(1,length(p_up));
%FFD
UPFFD = (1-t)^n*(U(1)-pupM(1))+t^n*(U(end)-pupM(end));
DNFFD = (1-t)^n*(D(1)-pdnM(1))+t^n*(D(end)-pdnM(end));
for  j  = 1:n-1
    UPFFD = UPFFD+nchoosek(n,j)*(1-t)^(n-j)*t^j*(U(j+1)-pupM(j+1));
    DNFFD = DNFFD+nchoosek(n,j)*(1-t)^(n-j)*t^j*(D(j+1)-pdnM(j+1));
end
% hold on
% fplot(t,UPFFD,[0,1],'r')
% fplot(t,DNFFD,[0,1],'r')
% % plot(xu,yu,'b')
% % plot(xl,yl,'b')
% scatter(linspace(0,1,n+1),U)
% scatter(linspace(0,1,n+1),D)
% hold off
l = flip(xl(2:end));
u = xu(1:end-1);
XB = [u;l];
Yu = double(subs(UPFFD,xu));
Yl = double(subs(DNFFD,xl));
YB = [Yu(1:end-1);flip(Yl(2:end))];