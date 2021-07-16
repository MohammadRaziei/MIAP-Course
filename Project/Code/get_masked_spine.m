function ret = get_masked_spine(moving, DDF, moving_label)
mask = double(moving == moving_label);
mving_mask = bsxfun(@times, mask, moving);
DDF_mask = bsxfun(@times, mask, DDF);
ret = imwarp(mving_mask, DDF_mask, 'nearest');
end



