clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
%%
subject_num = 20;
[seg3D, raw3D] = readData('subject', subject_num, true);
[atlas_seg, atlas_raw] = readData('atlas', true);
%%
[ys,xs,zs] = size(atlas_raw);
[X,Y,Z]=meshgrid(1:xs,1:ys, 1:zs);
xslice = floor([xs*0.75]);
yslice = floor([ys*0.75]);
zslice = floor([zs*0.5]);
fig = create_figure('', [0, 0.2, 1, 0.4]);
sgtitle('for atlas', 'Color', 'w')

subplot(131);
slicegray(X,Y,Z,atlas_raw,xslice,yslice,zslice,'cubic');
colorAxes%(gca,0.1*ones(1,3))

subplot(132);
montage(atlas_raw)

subplot(133);
ptCloud = extractCloudPoints(atlas_seg, 1);
pcshow(ptCloud)
colorAxes%(gca,0.1*ones(1,3))
save_figure(fig, 'results/partA_Q1-showAtlas.png')
%%

for subject_num = [6 10 20]
[seg3D, raw3D] = readData('subject', subject_num, true);
title_text = sprintf('subject: %.0f', subject_num);
seg3D_labels = unique(seg3D);
newmap = create_new_map(seg3D_labels);
newmap(1,:) = 0.95*ones(1,3);

i = floor(size(raw3D, 3)*0.5);
img_label = seg3D(:,:,i);
alpha = 0.5*logical(img_label);
img_label = reshape(newmap(img_label+1,:), [size(img_label) 3]);
img_raw = raw3D(:,:,i);
img = (1-alpha).*(img_raw)+(alpha).*img_label;

fig = create_figure('', [0.2, 0.3, 0.6, 0.4]);

subplot(131); 
imshow(rot90(img_raw)); 
title([title_text, ' (raw)'])

subplot(132); 
imshow(uint8(rot90(seg3D(:,:,i))), 'Colormap', newmap); 
colorbar('ylim', [seg3D_labels(2) seg3D_labels(end)+1]-0.1, ...
        'XTick',0.4+(seg3D_labels(2):seg3D_labels(end)+1),...
        'XTickLabel',(seg3D_labels(2):seg3D_labels(end)+1));
title([title_text, ' (label)'])

subplot(133); 
imshow(rot90(img)); 
title([title_text, ' (raw+label)'])
save_figure(fig, sprintf('results/partA_Q1_showSubject%.0f.png', subject_num));
end

