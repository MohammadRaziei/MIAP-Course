function tform = Transform2Tfrom(Transform, varargin)
switch Transform.method
   case {'affine', 'rigid'}
       tform = affine3d([[Transform.s * Transform.R';Transform.t'] [zeros(size(Transform.R,1),1);1]]);
   case {'nonrigid', 'nonrigid_lowrank'}
        % Yn = (Transform.Yorig - Transform.normal.yd) / Transform.normal.yscale;
        % G  = cpd_G(Yn, Yn, Transform.beta);
        % T  = (Yn + G * Transform.W) * Transform.normal.xscale + Transform.normal.xd;
        if isempty(varargin), Yorig = Transform.Yorig;
        else
            Yorig = varargin{1};
            if isa(Yorig, 'pointCloud'), Yorig = Yorig.Location; end
        end
        tform = Transform.Y - Yorig;
   otherwise
      error('use ''CDP2 Transform''!');
end
end