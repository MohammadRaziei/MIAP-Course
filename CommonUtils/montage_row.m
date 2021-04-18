function montage_row(images_cell, titles_cell)
msize = size(images_cell);
mlen = length(images_cell);

montage(images_cell, 'Size', msize)
if nargin == 2
    sp = 1/mlen;
    mlen = min(mlen, length(titles_cell));
    for i = 1:mlen
        text((i-0.5)*sp,1.05,titles_cell{i}, 'Units', 'normalized', 'HorizontalAlignment', 'center')
    end
end
end