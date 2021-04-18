function [x11,x12,x21,x22] = split_image(x)
    [m,n] = size(x);
    m2 = floor(m/2); n2 = ceil(n/2);
    x11 = x(1:m2,1:n2); x12 = x(1:m2,n2+1:end);
    x21 = x(m2+1:end,1:n2); x22 = x(m2+1:end,n2+1:end);
end