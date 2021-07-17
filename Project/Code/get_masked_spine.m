function ret = get_masked_spine(moving, DDF, moving_label)
mask = double(moving == moving_label);
mving_mask = bsxfun(@times, mask, moving);
% DDF_mask = bsxfun(@times, mask, DDF);
if isa(DDF, 'affine3d')
    ret = imwarp(mving_mask, DDF, 'nearest', 'OutputView', imref3d(size(moving)));
else 
    ret = imwarp(mving_mask, DDF, 'nearest');
end
end


