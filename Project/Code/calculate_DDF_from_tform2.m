function DDF = calculate_DDF_from_tform2(tform2, moving)
sz = size(moving);
[yq,xq,zq] = meshgrid(1:sz(1), 1:sz(2), 1:sz(3));
moving_ptCloud = [xq(:), yq(:), zq(:)];
movingReg_ptCloud = pctransform(pointCloud(moving_ptCloud(:,:)), tform2);
movingReg_ptCloud = movingReg_ptCloud.Location;
DDF = zeros([sz 3]);
N = size(moving_ptCloud,1);
for i = 1:N
DDF(moving_ptCloud(i,2), moving_ptCloud(i,1), moving_ptCloud(i,3), :) = ...
   - movingReg_ptCloud(i,:) + moving_ptCloud(i,:);
end
end