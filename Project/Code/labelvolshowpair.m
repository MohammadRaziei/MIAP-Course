function labelvolshowpair(fixed, moving, varargin)
    [compareC, cmap] = prepare_for_labelvolshow(fixed, moving);
    labelvolshow(compareC, 'LabelColor', cmap, varargin{:});
end