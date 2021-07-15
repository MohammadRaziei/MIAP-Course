clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results/niftishow');
%%
% [atlas, atlas_raw, atlas_info] = readData('atlas');
colors = distinguishable_colors(40,{'w','k'});
secondLine = '\newline\fontsize{8}';
labels = [];
%%
fig = create_figure('', [0.2 0.2 0.6 0.4]);
for subject_num = 1:21
    [seg3D, raw3D, info3D] = readData('subject', subject_num);
    [img3D, ind, l] = covert2img3D(seg3D, raw3D, colors);
    labels = union(labels, l(2:end));

    clf
    subplot(131)
    imshow(squeeze(img3D(ind(1), :, :, :)))
    subplot(132)
    imshow(squeeze(img3D(:, ind(2), :, :)))
    subplot(133)
    imshow(squeeze(img3D(:, :, ind(3), :)))
    sgtitle([sprintf('          for subject: %0.0f',subject_num) secondLine ...
        'PixelDimensions: [' regexprep(num2str(info3D(1).PixelDimensions),'\s+',', ') ']'], ...
        'Interpreter','tex');
    save_figure(fig, sprintf('results/niftishow/partA1-subject%0.0f.png', subject_num));
end
%%
[seg3D, raw3D, info3D] = readData('atlas');
[img3D, ind, l] = covert2img3D(seg3D, raw3D, colors);
labels = union(labels, l(2:end));

close(fig)
fig = create_figure('', [0.4 0.3 0.4 0.4]);

subplot(131)
imshow(squeeze(img3D(ind(1), :, :, :)))
subplot(132)
imshow(squeeze(img3D(:, ind(2), :, :)))
subplot(133)
imshow(squeeze(img3D(:, :, ind(3), :)))
sgtitle(['      for Atlas' secondLine ...
    'PixelDimensions: [' regexprep(num2str(info3D(1).PixelDimensions),'\s+',', ') ']'], ...
    'Interpreter','tex');
save_figure(fig, 'results/niftishow/partA1-atlas.png');
%%
save_csv('results/niftishow/partA1-labels.csv', [labels, colors(labels+8,:)], {'Labels','cR','cG', 'cB'})
% colors(labels+8,:)
%%
function [img3D, ind, labels] = covert2img3D(seg3D, raw3D, colors)
sz = size(seg3D);
center_index = centerofgravity(seg3D);
ind = round(sz/2 * 0.3 + 0.7*center_index);
alpha = 0.5*logical(seg3D);
newmap = zeros(256,3);
labels = unique(seg3D);
for l = 2:length(labels), newmap(labels(l)+1,:) = colors(labels(l)+8,:); end
seg3DColor = reshape(newmap(seg3D+1,:), [size(seg3D) 3]);
img3D = (1-alpha).*(raw3D)+(alpha).*seg3DColor;
end