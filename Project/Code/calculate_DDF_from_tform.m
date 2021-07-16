function DDF = calculate_DDF_from_tform(tform2, movingPoints, sz, justInConvexHull, verbose)
if isa(movingPoints,    'pointCloud'),movingPoints    = movingPoints.Location;    end
if not(isvector(sz)), sz = size(sz); end
if nargin < 4 || isempty(justInConvexHull), justInConvexHull = false; end
if nargin < 5 || isempty(verbose), verbose = false; end

[xq,yq,zq] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3));
method = 'linear';
if justInConvexHull, ExtrapolationMethod = 'none'; else, ExtrapolationMethod = method; end

DDF_T = cell(3,1);
for i = 1:3
    DDF_T{i} = scatteredInterpolant(movingPoints, tform2(:,i), method, ExtrapolationMethod);
end
DDF = zeros([size(xq),3]);
for i = 1:3
    if verbose, fprintf('calc for i = %.0f\n', i); end
    DDF(:,:,:,i) = DDF_T{i}(xq,yq,zq);
    %     DDF(:,:,:,i) = griddata(movingPoints(:,1), movingPoints(:,2), movingPoints(:,3), ...
    %         tform2(:,i), xq,yq,zq, method);
end
end