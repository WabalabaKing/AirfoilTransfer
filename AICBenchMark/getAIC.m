function [AIC,b,gAm,DCP,CP] = getAIC(al,X,Y,marker,h)
N = length(X)-1;
X = flip(X);
Y = flip(Y);
%calculate mid poiNt of paNels aNd aNgles
Vinf = 1;
Qinf = Vinf*[cosd(al) sind(al)];
theta = zeros(N,1);
AIC = zeros(N+1,N+1);
B = AIC;
b = zeros(N+1,1);
bi = zeros(N+1,1);
norms = zeros(N,2);
tans = zeros(N,2);
gam =flip(load('GAMA.DAT'));
for i = 1:N
    xi = X(i);
    xii = X(i+1);
    yi = Y(i);
    yii = Y(i+1);
    xc = mean([xi,xii]);
    yc = mean([yi,yii]);
    theta(i) = atan2(yii-yi,xii-xi);
    u2 = 0;
    v2 = 0;
    norms(i,:) = [-sin(theta(i)),cos(theta(i))];
    tans(i,:) = [cos(theta(i)),sin(theta(i))];
    
    for j = 1:N
       xj  = X(j);
       xjj = X(j+1);
       yj = Y(j);
       yjj = Y(j+1);
       u2_o = u2;
       v2_o = v2;
       [u1,v1,u2,v2] = getVi(1,1,xc,yc,xj,yj,xjj,yjj,j==i);
       if j==1
            AIC(i,1) = dot([u1 v1],norms(i,:));
            B(i,1) = dot([u1 v1],tans(i,:));
        elseif j==N
            AIC(i,N) = dot([u1 v1] + [u2_o v2_o],norms(i,:));
            AIC(i,N+1) = dot([u2 v2],norms(i,:));
            B(i,N) = dot([u1 v1] + [u2_o v2_o],tans(i,:));
            B(i,N+1) = dot([u2 v2],tans(i,:));
        else
            AIC(i,j) = dot([u1 v1] + [u2_o v2_o],norms(i,:));
            B(i,j) = dot([u1 v1] + [u2_o v2_o],tans(i,:));
        end
    end
        b(i) = dot(-Qinf,norms(i,:));
    
end

    AIC(N+1,1) = 1;
    AIC(N+1,N+1) = 1;
    b(N+1) = 0;
    theta = [theta;atan2(Y(1)-Y(N+1),X(1)-X(N+1))];
    bi =b;
%     gam = load("GAMA.DAT");
%     gam = [gam;-gam(1)];
temp =  atan2(Y(1)-Y(N+1),X(1)-X(N+1));
tans = [tans;[cos(temp),sin(temp)]];
    gAm = zeros(N+1,1);
if marker ==1
gAm = AIC\bi;
Cp = zeros(N+1,1);
vtan = zeros(N+1,1);
for i=1:N+1
    for j=1:N+1
        vtan(i) = vtan(i) + B(i,j)*gAm(j);
    end
    vtan(i) = vtan(i) + dot(Qinf,tans(i,:));
    Cp(i) = 1-(vtan(i)/Vinf)^2;
end
%%
CP = Cp;
dCp = Cp;
DCP = zeros(length(Cp));
for k = 1:length(gAm)
    gami = gAm;
    gami(k) = gAm(k)+h;
    vtan = zeros(N,1);
    for i=1:N
    for j=1:N+1
        vtan(i) = vtan(i) + B(i,j)*gami(j);
    end
    vtan(i) = vtan(i) + dot(Qinf,tans(i,:));
    dCp(i) = 1-(vtan(i)/Vinf)^2;
    end
    DCP(:,k) = (dCp-Cp)/h;
    
end

else
    DCP = 0;
end
    gAm = flip(gAm);
    b = flip(b);
    AIC = flip(flip(AIC,2),1);
    DCP = flip(flip(DCP,2),1);
% 

    
    
function [u1,v1,u2,v2] = getVi(gj,gjj,x,y,xj,yj,xjj,yjj,same)
    a = atan2(yjj-yj,xjj-xj);
    A = [cos(a) sin(a);-sin(a),cos(a)];
    tmp = A*[x-xj;y-yj];
    xp = tmp(1);
    yp = tmp(2);
    S = (xjj-xj)*cos(a) + (yjj-yj)*sin(a);
    
    rj = sqrt(xp^2 + yp^2);
    rjj = sqrt((xp-S)^2 + yp^2);
    
    tj = atan2(yp,xp);
    tjj = atan2(yp,xp-S);
    if same
        u1 = (-0.5*(xp-S)/S)*gj;
        u2 = (0.5*xp/S)*gjj;
        v1 = (-1/2/pi)*gj;
        v2 = (1/2/pi)*gjj;
    else
        u1 = (-(yp*log(rjj/rj) + xp*(tjj-tj) - S*(tjj-tj))/(2*pi*S))*gj;
        u2 = ((yp*log(rjj/rj) + xp*(tjj-tj))/(2*pi*S))*gjj;
        v1 = (-((S-yp*(tjj-tj)) - xp*log(rj/rjj) + S*log(rj/rjj))/(2*pi*S))*gj;
        v2 = (((S-yp*(tjj-tj)) - xp*log(rj/rjj))/(2*pi*S))*gjj;
    end
        tmp = A'*[u1;v1];
    u1 = tmp(1);
    v1 = tmp(2);

    tmp = A'*[u2;v2];
    u2 = tmp(1);
    v2 = tmp(2);
end
end