clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
image_raw = imread(fullfile(Questions_folder,'heart_ct.jpg'));
image_raw = rgb2gray(image_raw);

img_n_gaus =@(s) imnoise(image_raw, 'gaussian', 0, s);
img_n_sp =@(d) imnoise(image_raw, 'salt & pepper', d);
% add noise with imnoise and plot
fig = create_figure('imnoise (gaussian, salt&pepper)', [0.05,0.2,.9,.6]);
subplot(211);
noisy_guas_images = {img_n_gaus(0), img_n_gaus(0.02), img_n_gaus(0.05), img_n_gaus(0.1),img_n_gaus(0.2), img_n_gaus(0.5), img_n_gaus(1)};
titles_guas_cell = {'gaussian(0,0)','gaussian(0,0.02)', 'gaussian(0,0.05)', 'gaussian(0,0.1)', 'gaussian(0,0.2)', 'gaussian(0,0.5)', 'gaussian(0,1)'};
montage_row(noisy_guas_images, titles_guas_cell)
subplot(212);
noisy_sp_images = {img_n_sp(0), img_n_sp(0.01), img_n_sp(0.02), img_n_sp(0.05), img_n_sp(0.1),img_n_sp(0.2), img_n_sp(0.4)};
titles_sp_cell = {'salt & pepper(0)','salt & pepper(0.01)', 'salt & pepper(0.02)', 'salt & pepper(0,0.05)', 'salt & pepper(0,0.1)', 'salt & pepper(0,0.2)', 'salt & pepper(0,0.4)'};
montage_row(noisy_sp_images, titles_sp_cell)
save_figure(fig,'imnoise (gaussian, salt&pepper).png')


% filter with averaging window and plot
filtering = @(img, n) uint8(imfilter(double(img), ones(n)/n/n)); 
filters = [3,5,7];
num_filters = length(filters);

fig = create_figure('imfilter (gaussian)', [0.05,0.05,.9,.9]);
subplot(num_filters+1,1,1); montage_row(noisy_guas_images, titles_guas_cell);
create_text('noisy images',[-0.02,0.5], 90)
images = cell(size(noisy_guas_images));
for k = 1:num_filters
    for i = 1:length(images), images{i}= filtering(noisy_guas_images{i}, filters(k)); end
    subplot(num_filters+1,1,k+1); montage_row(images, titles_guas_cell);
    create_text([num2str(filters(k)) 'x' num2str(filters(k))],[-0.02,0.5])
end
save_figure(fig,'imfilter (gaussian).png')

fig = create_figure('imfilter (salt&pepper)', [0.05,0.05,.9,.9]);
subplot(num_filters+1,1,1); montage_row(noisy_sp_images, titles_sp_cell);
create_text('noisy images',[-0.02,0.5], 90)
images = cell(size(noisy_sp_images));
for k = 1:num_filters
    for i = 1:length(images), images{i}= filtering(noisy_sp_images{i}, filters(k)); end
    subplot(num_filters+1,1,k+1); montage_row(images, titles_sp_cell);    
    create_text([num2str(filters(k)) 'x' num2str(filters(k))],[-0.02,0.5])
end
save_figure(fig,'imfilter (salt&pepper).png')


fig = create_figure('medfilt2 (salt&pepper)', [0.05,0.05,.9,.9]);
subplot(num_filters+1,1,1); montage_row(noisy_sp_images, titles_sp_cell);
create_text('noisy images',[-0.02,0.5], 90)
images = cell(size(noisy_sp_images));
for k = 1:num_filters
    for i = 1:length(images), images{i}= medfilt2(noisy_sp_images{i}, [filters(k), filters(k)]); end
    subplot(num_filters+1,1,k+1); montage_row(images, titles_sp_cell);    
    create_text([num2str(filters(k)) 'x' num2str(filters(k))],[-0.02,0.5])
end
save_figure(fig,'medfilt2 (salt&pepper).png')
