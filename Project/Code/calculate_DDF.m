function DDF = calculate_DDF(movingRegPoints, movingPoints, sz)
if isa(movingRegPoints, 'pointCloud'),movingRegPoints = movingRegPoints.Location; end
if isa(movingPoints,    'pointCloud'),movingPoints    = movingPoints.Location;    end
if not(isvector(sz)), sz = size(sz); end

tform2 = movingRegPoints - movingPoints;
[xq,yq,zq] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3));
method = 'linear';
% DDF_T = struct;
% DDF_T.x = scatteredInterpolant(movingPoints, tform2(:,1), method);
% DDF_T.y = scatteredInterpolant(movingPoints, tform2(:,2), method);
% DDF_T.z = scatteredInterpolant(movingPoints, tform2(:,3), method);
DDF = zeros([sz,3]);zzzz;
for i = 1:3
    DDF(:,:,:,i) = griddata(movingPoints(:,1), movingPoints(:,2), movingPoints(:,3), ...
        tform2(:,i), xq,yq,zq, method);
end
end