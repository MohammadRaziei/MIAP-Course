function ret = centerofgravity(im)
ind = cell(size(size(im)));    
[ind{:}] = ind2sub(size(im), find(logical(im)));
ret = round(mean(cat(2,ind{:})));
end