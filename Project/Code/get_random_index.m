function out = get_random_index(n,p)
out = [];
for i = 1:n
    if rand <= p, out = [out;i]; end
end
end