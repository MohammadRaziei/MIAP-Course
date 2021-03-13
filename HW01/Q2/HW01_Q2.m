clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
image_raw = imread(fullfile(Questions_folder,'Hist.tif'));
image_histeq = histeq(image_raw);
image_atapthisteq = adapthisteq(image_raw, 'NumTiles', [7 7]);


hist_image_raw = histogram(image_raw);
hist_image_histeq = histogram(image_histeq);
hist_image_atapthisteq = histogram(image_atapthisteq);

fig = figure('Color','white', 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'Q2');
subplot(231); imshow(image_raw);
subplot(232); imshow(image_histeq);
subplot(233); imshow(image_atapthisteq);
subplot(234); histogram(image_raw, 'Normalization', 'pdf'); title('Orginal Image')
subplot(235); histogram(image_histeq, 'Normalization', 'pdf'); title('Applying histeq')
subplot(236); histogram(image_atapthisteq, 'Normalization', 'pdf'); title('Applying adapthisteq')
save_figure(fig, 'Q2.png')



