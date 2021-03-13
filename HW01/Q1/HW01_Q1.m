clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
image_raw = imread(fullfile(Questions_folder,'Brain_MRI.png'));
image = rgb2gray(image_raw);

fig = figure('Color','white', 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'show images');
ah1 = axes('Parent',fig,'Units','normalized','Position',[0.08 0.05 0.4 0.95]);
ah2 = axes('Parent',fig,'Units','normalized','Position',[0.52 0.05 0.4 0.95]);
imshow(image_raw,'Parent',ah1); title('Raw image', 'Parent',ah1)
imshow(image,'Parent',ah2); title('Gray image', 'Parent',ah2)
save_figure(fig, 'Part I - show images.png')

fig = figure('Color','white', 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'montage images');
montage({image_raw, image})
save_figure(fig, 'Part I - montage images.png')

image_gray = myRGB2GRAY(image_raw);
image_gray2 = myRGB2GRAY(image_raw, 'matlab');
fig = figure('Color','white', 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'compare gray images');
montage({image, image_gray, image-image_gray, image, image_gray , image-image_gray2}, 'Size', [2 3])
text(150,-20,'matlab rgb2gray')
text(700,-20,'myRGB2GRAY')
text(1200,-20,'difference')
text(-20,400,'simple averaging','Rotation',90);
text(-20,1000,'weighted method','Rotation',90);
save_figure(fig, 'Part II - compare gray images.png')

imwrite(image_gray, 'Part III - image_gray simple.png')
imwrite(image_gray, 'Part III - image_gray weighted.png')







