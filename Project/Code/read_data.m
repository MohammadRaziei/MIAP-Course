function [seg3D, raw3D, fileInfo] = read_data(filename_raw, filename_label,ToDouble )
raw3D = double(niftiread(filename_raw));
seg3D = niftiread(filename_label);
max_img = double(max(raw3D(:)));
raw3D = double(raw3D) / max_img;
if ToDouble == true, seg3D = double(seg3D); end
if nargout == 3, fileInfo = [niftiinfo(filename_label), niftiinfo(filename_raw)]; end
end