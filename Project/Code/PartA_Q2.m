clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
data_dir = '../data/';
%%
subject_num = 20;
img_pack = double(niftiread(fullfile(data_dir, sprintf('S%02.0f/pat%.0f.nii', subject_num, subject_num))));
img_pack_label = double(niftiread(fullfile(data_dir, sprintf('S%02.0f/pat%.0f_label.nii', subject_num, subject_num))));

%%
max_img = double(max(img_pack(:)));
img_pack = double(img_pack) / max_img;

img = img_pack(:,:,32);
img_label = img_pack_label(:,:,32);
image_labels_uinque = unique(img_pack_label);
imshow(img_label);
%%
C_color = colororder;
C = @(ind) C_color(1 + mod(ind-1,size(C_color,1)),:);
xyzPoints = zeros(0,3);
colors = zeros(0,3);
img_pack_label_BW = bwperim3(img_pack_label);
% img_pack_label_BW = bsxfun(@times, BW, img_pack_label);
%%
for i = 2:length(image_labels_uinque)
[x,y,z] = ind2sub(size(img_pack_label_BW),find(img_pack_label_BW==image_labels_uinque(i)));
xyzPoints = [xyzPoints;[x,y,z]];
colors = [colors;repmat(C(i),size(x,1),1)];
end
num_points = size(xyzPoints,1);

p = 2.^-(0:6);
ptClouds = cell(length(p));
for i = 1:length(p)
    idx = get_random_index(num_points, p(i));
    ptClouds{i} = pointCloud(xyzPoints(idx,:), 'Color', colors(idx,:));
end

fig = create_figure('',[0,0,1,1]);
for i = 1:length(p)
    subplot(1,length(p),i)
    pcshow(ptClouds{i});
end
% set(fig, 'Color','w');


