function BW = bwperim3(im3, isGray)
if nargin < 2, isGray = ~islogical(im3); end
BW = zeros(size(im3));
for i = 1 : size(im3,3)
    BW(:,:,i) = bwperim(logical(im3(:,:,i)));
end
BW = bsxfun(@times, imdilate(BW,strel('cube',1)), im3);
if not(isGray)
    BW = logical(BW);
end
end