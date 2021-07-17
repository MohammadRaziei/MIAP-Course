function n_neg = DisplacementFieldJacobianDeterminant(DDF)
    JD = jacobian_determinant(DDF);
    n_neg = sum(JD(JD < 0), 'all');
end