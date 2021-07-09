function ret = binary_dice_loss(y_true, y_pred)
% NOTE: sum(X,'all'): This syntax is valid for MATLAB® versions R2018b and later.
A = logical(y_true); B = logical(y_pred);
ret = 2 * sum(bsxfun(@times, A, B), 'all') / (sum(A+B, 'all'));
end