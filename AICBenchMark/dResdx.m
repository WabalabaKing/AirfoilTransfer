function dRdx = dResdx(XX,YY,a,p,h,gam,b,AIC)
%p is the FFD param variable,
%h is the perturb step size,
p_pert_mat = p;
for k = 2:length(p)
p_pert_mat = [p_pert_mat;p];
end
p_pert_mat = p_pert_mat+diag([-h*ones(1,length(p)/2),h*ones(1,length(p)/2)]);
per = [-h*ones(1,length(p)/2),h*ones(1,length(p)/2)];
 Residual_unpert = AIC(1:end,1:end)*gam(1:end)-b(1:end);
 
 for i = 1:length(p)
    dRdx(:,i) = (Residual_pert(XX,YY,p_pert_mat(i,:),gam,a,b)-Residual_unpert)/per(i);
 end
 
    function Rper = Residual_pert(XX,YY,pe,gam,a,b)
       [XXn,YYn] = ffd_opt(pe,'sth',0);
       [AICnew,bnew,gnew,z] = getAIC(a,XXn,YYn,0);
       Rper = AICnew(1:end,1:end)*gam(1:end)-bnew(1:end);
%        check  = AICnew(2:end,2:end)*gnew(2:end)-bnew(2:end);
    end
end