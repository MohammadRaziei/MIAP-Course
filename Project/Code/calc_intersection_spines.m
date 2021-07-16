function ret = calc_intersection_spines(moving, DDF, common_labels, returnSum)
if nargin < 4, returnSum = true; end

spines = cell(size(common_labels));
for i = 1:length(common_labels)
    spines{i} = get_masked_spine(moving, DDF, common_labels(i));
end
arr = zeros(1, length(common_labels)-1);
for i = 1:length(arr)
    arr(i) = sum(bsxfun(@times, logical(spines{i}), logical(spines{i+1})), 'all');
end
if returnSum, ret = sum(arr); else, ret = arr; end
end