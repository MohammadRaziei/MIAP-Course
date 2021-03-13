clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
image_raw = imread(fullfile(Questions_folder,'retina.png'));

L = 256;
log_transform = @(r) uint8((L-1)* log(1+double(r))/log(L)); 
fig = figure('Color','white', 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'Q2');
subplot(121); imshow(image_raw)
subplot(122); imshow(log_transform(image_raw))
save_figure(fig, 'log_transform.png')

power_law = @(r,p) uint8((L-1)* (double(r)/(L-1)).^p); 
fig = figure('Color','white', 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'Q2');
subplot(121); imshow(image_raw)
subplot(122); imshow(power_law(image_raw,0.75))
save_figure(fig, 'power_law-0.75.png')


