clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
x = im2double(imread(fullfile(Questions_folder,'hand_xray.jpg')));

fig = create_figure;
X = fft2(x);
X2 = conj(X);
x2 = real(ifft2(X2));
imshowpair(x, x2, 'montage')
save_figure(fig, 'image rotatation.png')