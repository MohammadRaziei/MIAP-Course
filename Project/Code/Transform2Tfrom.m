function tform = Transform2Tfrom(Transform)
switch Transform.method
   case {'affine', 'rigid'}
       tform = affine3d([[Transform.s * Transform.R';Transform.t'] [zeros(size(Transform.R,1),1);1]]);
   case {'nonrigid', 'nonrigid_lowrank'}
        % Yn = (Transform.Yorig - Transform.normal.yd) / Transform.normal.yscale;
        % G  = cpd_G(Yn, Yn, Transform.beta);
        % T  = (Yn + G * Transform.W) * Transform.normal.xscale + Transform.normal.xd;
        tform = Transform.Y - Transform.Yorig;
   otherwise
      error('use ''CDP2 Transform''!');
end
end