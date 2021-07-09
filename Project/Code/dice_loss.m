function ret = dice_loss(y_true, y_pred)
A = logical(y_true); B = logical(y_pred);
ret = 2 * sum(bsxfun(@times, y_true==y_pred, bsxfun(@times, A, B)), 'all') / (sum(A+B, 'all'));
end