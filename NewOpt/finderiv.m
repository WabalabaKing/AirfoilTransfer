function [dclA,dcmA] = finderiv(a,x,y,gam,DCP)
%analytical
NN = length(x);
dx = zeros(NN,1);
dy = zeros(NN,1);
x = [x;x(1)];
y = [y;y(1)];
theta = zeros(NN,1);
for i = 1:NN              %find x projection of each panel
   dx(i) = (x(i+1)-x(i))*cosd(a)+(y(i+1)-y(i))*sind(a);
   dy(i) = -(x(i+1)-x(i))*sind(a)+(y(i+1)-y(i))*cosd(a);
   theta(i) = atan2(y(i)-y(i+1),x(i)-x(i+1));
end
% dx = [dx];
% dy = [dy];
  
dclA = zeros(NN,1);

                               % actually calculating dcldgam
for i = 1:NN
    dcp = mean([DCP(:,i),[DCP(2:end,i);DCP(1,i)]],2);
    dclA(i) =dx'*dcp;
end

%finite difference for dcm/dgam
% % dcmdgamD = load("DCMDG.DAT");
%analytical for dcm/dgam
dcmA = zeros(NN,1);
xR = mean([x,[x(2:end);x(1)]],2)-0.25;
yR = mean([y,[y(2:end);y(1)]],2);
xR = xR(1:end-1);
yR = yR(1:end-1);
for i = 1:NN
    dcp = mean([DCP(:,i),[DCP(2:end,i);DCP(1,i)]],2);
    dcmA(i) = -(dx.*dcp)'*xR+(dy.*dcp)'*yR;
end
end