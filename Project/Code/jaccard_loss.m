function ret = jaccard_loss(y_true, y_pred)
% NOTE: sum(X,'all'): This syntax is valid for MATLAB® versions R2018b and later.
A = logical(y_true); B = logical(y_pred);
ret = sum(bsxfun(@times, y_true==y_pred, bsxfun(@times, A, B)), 'all') / (sum(logical(A+B), 'all'));
end