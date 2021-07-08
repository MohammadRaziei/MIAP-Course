function varargout = extractCloudPoints(img, p)
if nargin < 2, p = 0.1; end

C_color = colororder;
C = @(ind) C_color(1 + mod(ind-1,size(C_color,1)),:);

img_unique = unique(img);
xyzPoints = zeros(0,3);
colors = zeros(0,3);
labels = zeros(0,1);
for i = 2:length(img_unique)
    [~, xyz] = reducepatch(isosurface(img==img_unique(i),0), p);
    xyzPoints = [xyzPoints; xyz];
    colors = [colors; repmat(C(i),size(xyz,1),1)];
    labels = [labels; img_unique(i)*ones(size(xyz,1),1)];
end
ptCloud = pointCloud(xyzPoints, 'Color', colors);

switch nargout
   case 1, varargout = {ptCloud}; 
   case 2, varargout = {ptCloud, labels}; 
   case 3, varargout = {xyzPoints, labels, ptCloud}; 
   case 4, varargout = {xyzPoints, labels, colors, ptCloud}; 
   otherwise
       error('too much output');
end
   
end

