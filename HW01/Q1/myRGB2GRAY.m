function gray = myRGB2GRAY(RGB, method)
    RGB = double(RGB);
    if nargin < 2
        gray = uint8(mean(RGB, 3));
    elseif isequal(method , 'matlab')
        R = RGB(:,:,1); G = RGB(:,:,2); B = RGB(:,:,3);
        gray = uint8(squeeze(0.2989 * R + 0.5870 * G + 0.1140 * B));
    end
end