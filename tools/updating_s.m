function [A, r] = updating_s(X_train,dX,W,alpha, c, k, islocal,p)
NITER = 30;
num = size(X_train{1},2);
nv = length(alpha);
distv = zeros(num,num,nv);
distV = zeros(num,num,nv);
for iv = 1:nv
    if strcmp(p,'ini')
        distV(:,:,iv) = alpha(iv).*dX(:,:,iv);
    else
        X = W{iv}'*X_train{iv};
        distv(:,:,iv) = alpha(iv).*L2_distance_1(X,X);
        distV(:,:,iv) = alpha(iv).*dX(:,:,iv);
    end
end
distX = sum(distV,3);
if strcmp(p,'ini')
    distx = distX;
else
    distx = sum(distv,3);
end
[distX1, idx] = sort(distX,2);
clear distv distV dX W X_train distX
A = zeros(num);
rr = zeros(num,1);
for i = 1:num
    di = distX1(i,2:k+2);
    rr(i) = 0.5*(k*di(k+1)-sum(di(1:k)));
    id = idx(i,2:k+2);
    A(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps);
end;


r = mean(rr);
lambda = r;
A0 = (A+A')/2;
D0 = diag(sum(A0));
L0 = D0 - A0;
[F, ~, evs]=eig1(L0, c, 0);
for iter = 1:NITER
    distf = L2_distance_1(F',F');    
    A = zeros(num);
    for i=1:num
        if islocal == 1
            idxa0 = idx(i,2:k+1);
        else
            idxa0 = 1:num;
        end;
        dfi = distf(i,idxa0);
        dxi = distx(i,idxa0);
        ad = -(dxi+lambda*dfi)/(2*r);
        A(i,idxa0) = EProjSimplex_new(ad);
    end;

    A = (A+A')/2;
    D = diag(sum(A));
    L = D-A;
    
    F_old = F;
    [F, ~, ev]=eig1(L, c, 0);
    evs(:,iter+1) = ev;

    fn1 = sum(ev(1:c));
    fn2 = sum(ev(1:c+1));
    if fn1 > 0.000000001
        lambda = 2*lambda;
    elseif fn2 < 0.00000000001
        lambda = lambda/2;  F = F_old;
    else
        break;
    end;

end