clear 
warning('off')
addpath('tools');
dataset = load('./data/Number_v12345.mat'); islocal = 0;k = 15;  LA = 10;
% dataset = load('./data/C101_p1474.mat'); islocal = 1;k = 30;  LA = 1;
% dataset = load('./data/NH_p4660'); islocal = 1; k = 100; LA = 30;
GT = dataset.truth;
nc = length(unique(GT));
n = size(dataset.X_train{1},2);
nv = size(dataset.X_train,2);

W{nv} = [];
g = zeros(nv,1);
distX = zeros(n,n,nv);
alpha = ones(nv,1)./nv;
for iv = 1:nv
    dataset.X_train{iv} = dataset.X_train{iv}./(sum(sum(dataset.X_train{iv})));
    X = dataset.X_train{iv};
    distX(:,:,iv) = L2_distance_1(X,X);
end

%% initial 
S = updating_s(dataset.X_train,distX,W,alpha, nc, k, islocal,'ini');
D = diag(sum(S));
L = D - S;
J_old = 1; J_new = 10; EPS = 1e-3;
iter = 0;
while abs((J_new - J_old)/J_old) > EPS
    iter = iter +1;
    %% The First Step:    
    for iv = 1:nv
        X = dataset.X_train{iv};
        L(isnan(L)) = 0; D(isnan(D)) = 0;
        L(isinf(L)) = 0; D(isinf(D)) = 0;
        DP = X * D * X';
        LP = X * L * X';
        DP = (DP + DP') / 2;
        LP = (LP + LP') / 2;
        Tmp = DP\LP;
        Tmp(isinf(Tmp)) = 0;
        Tmp(isnan(Tmp)) = 0;
        W{iv} = eig1(Tmp,50,0);
        g(iv,1) = trace(W{iv}'*LP*W{iv});
    end
    clear Tmp
    %% The Second Step:
%     lambda = (max(g)+min(g)/2)*nv./2 - mean(g)/2;
    lambda = mean(g)*LA;
    alpha = EProjSimplex_new(-g./(2*lambda),1);
    %% The Third Step:
    [S,gamma] = updating_s(dataset.X_train,distX,W,alpha, nc, k, islocal,'y_u');
%     figure,imshow(S,[]),colormap jet
    %% Objective Function
    S = (S + S')/2;
    D = diag(sum(S));
    L = D - S;
    T = 0;
    for iv = 1:nv
        X = dataset.X_train{iv};
        w = W{iv};
        T = T + alpha(iv).*trace(w'*X*(L)*X'*w);
    end
    J_old = J_new;
    J_new = T + lambda.*alpha'*alpha + gamma*norm(S,'fro').^2;
end
[clusternum, label]=graphconncomp(sparse(S)); label = label';
label = bestMap(GT,label);
y0 = GT;
y = label;
amp = ClusteringMeasure(y0, y)
[F,P,R] = compute_f(y0,y);
display([P,R F]);
acc = amp(1);
nmi = amp(2);
pu  = amp(3);
% AR = RandIndex(y0,y)