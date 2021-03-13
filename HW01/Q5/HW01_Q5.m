clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
image_raw = imread(fullfile(Questions_folder,'retina.png'));

sigmoid =@(x,a) 1./(1+exp(a*x));
L = 255;

image = double(image_raw)/L; 
image = adapthisteq(image);
image = 1-sigmoid(image,10);
image = adapthisteq(image);
image = (image > 0.95);
image = uint8(image*L);
fig = create_figure('Q5');
montage_row({image_raw, image})
save_figure(fig, 'Q5.png')

