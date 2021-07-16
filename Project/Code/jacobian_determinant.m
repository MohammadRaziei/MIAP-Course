function ret = jacobian_determinant(dispFiled)
% jacobian determinant of a displacement field.
% NB: to compute the spatial gradients, we use np.gradient.
% Parameters:
%     disp: 2D or 3D displacement field of size [*vol_shape, nb_dims],
%           where vol_shape is of len nb_dims
% Returns:
%     jacobian determinant (scalar)

% check inputs
nb_dims = length(size(dispFiled))-1;
% assert len(volshape) in (2, 3), 'flow has to be 2D or 3D'

% compute grid
[ys, xs, zs, ~] = size(dispFiled);
[X,Y,Z] = meshgrid(1:xs,1:ys,1:zs);
mgrid = cat(4,X,Y,Z);
% grid = np.stack(grid_lst, len(volshape))

% compute gradients
J = gradient(dispFiled + mgrid);

% 3D glow
if nb_dims == 3
    [dx, dy, dz] = gradient(dispFiled + mgrid);

    % compute jacobian components
    Jdet0 = dx(:,:,:,1) .* (dy(:,:,:,2) .* dz(:,:,:,3) - dy(:,:,:,3) .* dz(:,:,:,2));
    Jdet1 = dx(:,:,:,2) .* (dy(:,:,:,1) .* dz(:,:,:,3) - dy(:,:,:,3) .* dz(:,:,:,1));
    Jdet2 = dx(:,:,:,3) .* (dy(:,:,:,1) .* dz(:,:,:,2) - dy(:,:,:,2) .* dz(:,:,:,1));

    ret = Jdet0 - Jdet1 + Jdet2;

else  % must be 2
    error('NOT COMPLETED');
%     dfdx = J[0]
%     dfdy = J[1]
%     ret = dfdx[..., 0] * dfdy[..., 1] - dfdy[..., 0] * dfdx[..., 1]
end

end