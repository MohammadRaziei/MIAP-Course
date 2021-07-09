function save_csv(csv_filename, csv_data, csv_header)
if nargin > 3, error('too much arguments!'); end
validateattributes(csv_filename,{'char'},{'nonempty'},mfilename,'csv_filename',1);
if size(size(csv_data))> 2, error('''csv_data''must be atmost 2 dimentional'); end
if nargin == 3 && not(isempty(csv_header))
    if size(size(csv_data))==1, ncol = size(csv_data); else, ncol = size(csv_data,2); end
    if ncol ~= numel(csv_header), error('incompatible size with data'); end
    textHeader = strjoin(csv_header, ','); %cHeader in text with commas
    %write header to file
    fid = fopen(csv_filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
end
%write data to end of file
dlmwrite(csv_filename,csv_data,'-append');
end