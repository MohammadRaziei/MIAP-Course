function ret=calc_loss(method_fun, y_true, y_pred)
    ret = method_fun(y_true, y_pred);
end