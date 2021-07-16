function ret = get_label(labels, pos)
n = length(pos);
ret = zeros(n, 1);
for i = 1:n
    ret(i) = labels(round(pos(i,1)), round(pos(i,2)), round(pos(i,3)));
end
end