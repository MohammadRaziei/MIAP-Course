function DDF = calculate_DDF_from_tform(tform2, movingPoints, sz, justInConvexHull, verbose)
if isa(movingPoints,    'pointCloud'),movingPoints    = movingPoints.Location;    end
if not(isvector(sz)), sz = size(sz); end
if nargin < 4 || isempty(justInConvexHull), justInConvexHull = false; end
if nargin < 5 || isempty(verbose), verbose = false; end

[xq,yq,zq] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3));
method = 'linear';
if justInConvexHull, ExtrapolationMethod = 'none'; else, ExtrapolationMethod = 'linear'; end

DDF_T = cell(3,1);
DDF_T{1} = scatteredInterpolant(movingPoints, tform2(:,1), method, ExtrapolationMethod);
DDF_T{2} = scatteredInterpolant(movingPoints, tform2(:,2), method, ExtrapolationMethod);
DDF_T{3} = scatteredInterpolant(movingPoints, tform2(:,3), method, ExtrapolationMethod);

DDF = zeros([sz,3]);
if verbose, fprintf('dx is calculating...\n'); end
DDF(:,:,:,1) = DDF_T{1}(xq,yq,zq);
if verbose, fprintf('dy is calculating...\n'); end
DDF(:,:,:,2) = DDF_T{2}(xq,yq,zq);
if verbose, fprintf('dz is calculating...\n'); end
DDF(:,:,:,3) = DDF_T{3}(xq,yq,zq);
%    
end