function BW = bwperim3(im3, isGray)
if nargin < 2, isGray = ~islogical(im3); end
BW = zeros(size(im3));
for i = 1 : size(im3,3)
    bw = bwperim(logical(im3(:,:,i)));
    if isGray
       BW(:,:,i) = im3(:,:,i).*bw;
    else
       BW(:,:,i) = bw;
    end
end
end