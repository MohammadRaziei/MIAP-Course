clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';

fig = create_figure();
image = phantom('Modified Shepp-Logan', 500);
image_noisy = imnoise(image, 'gaussian', 0, 0.05*var(image(:)));
imshowpair(image, image_noisy, 'montage')

