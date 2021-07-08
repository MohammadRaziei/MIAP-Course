function [img_pack_label, img_pack]=readData(method, varargin)
    validateattributes(method, {'char'}, {'nonempty', 'scalartext'})
    ToDouble = false;
    data_dir = '../data/';
    switch lower(method)
        case 'subject' 
            if nargin < 2, error('Not enough input arguments.'); end
            if nargin == 3, validateattributes(varargin{2}, {'logical'}, {'nonempty'});
                ToDouble = varargin{2}; end
            validateattributes(varargin{1}, {'numeric'}, {'nonempty', 'scalar'});
            subject_num = varargin{1};
            filename_raw = fullfile(data_dir, sprintf('S%02.0f/pat%.0f.nii', subject_num, subject_num));
            filename_label = fullfile(data_dir, sprintf('S%02.0f/pat%.0f_label.nii', subject_num, subject_num));
        case 'atlas'
            if nargin == 2, validateattributes(varargin{1}, {'logical'}, {'nonempty'});
                ToDouble = varargin{1}; end
            filename_raw = fullfile(data_dir, 'Healthy_sample/00.nii');
            filename_label = fullfile(data_dir, 'Healthy_sample/00_mask.nii');
        otherwise, error(''); 
    end
    
    img_pack = double(niftiread(filename_raw));
    img_pack_label = niftiread(filename_label);
    max_img = double(max(img_pack(:)));
    img_pack = double(img_pack) / max_img;
    if ToDouble == true, img_pack_label = double(img_pack_label); end

end