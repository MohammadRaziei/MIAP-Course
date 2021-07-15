function [seg3D, raw3D, fileInfo]=readData2(method, varargin)
% [seg3D, raw3D, info_list] = readData2('atlas');
% [___] = readData('subject', num)
% [___] = readData(___, toDouble) % convert segment labels to double from uint8 (default:true)
%
validateattributes(method, {'char'}, {'nonempty', 'scalartext'})
ToDouble = true;
data_dir = '../data2/';
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

raw3D = double(niftiread(filename_raw));
seg3D = niftiread(filename_label);
max_img = double(max(raw3D(:)));
raw3D = double(raw3D) / max_img;
if ToDouble == true, seg3D = double(seg3D); end
if nargout == 3, fileInfo = [niftiinfo(filename_label), niftiinfo(filename_raw)]; end
end