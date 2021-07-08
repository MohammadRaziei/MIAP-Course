function [Vs,Ds] = eigsorted(A)
[V,D] = eig(A, 'nobalance');
[~,ind] = sort(diag(D));
Ds = D(ind,ind);
Vs = V(:,ind);
end