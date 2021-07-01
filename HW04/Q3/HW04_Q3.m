clc; clear; close all; addpath('../../CommonUtils', '../Questions')
Questions_folder = '../Questions/';  addpath('../Questions/ARKFCM_demo/ARKFCM_demo/ARKFCM_demo')

load('noise.mat')
% run demo

fig = create_figure;
subplot(131); imshow(no720_100A,[]); title('no720\_100A')       
subplot(132); imshow(no720_100S,[]); title('no720\_100S')
subplot(133); imshow(rice10_91A,[]); title('rice10\_91A')

img=no720_100A;
fig = create_figure;
imagesc(reshape(kmeans(img(:), 6), size(img)));






