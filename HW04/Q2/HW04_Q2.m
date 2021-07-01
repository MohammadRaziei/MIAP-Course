clc; clear; close all; addpath('../../CommonUtils', '../Questions')
Questions_folder = '../Questions/'; 
addpath(fullfile(Questions_folder,'activeContoursSnakesDemo/activeContoursDemo'))
addpath(fullfile(Questions_folder,'snake_demo/snake'))

Blur1 = im2double(imread(fullfile(Questions_folder,'Blur1.png')));
Blur2 = im2double(imread(fullfile(Questions_folder,'Blur2.png')));


% imshowpair(Blur1, Blur2, 'montage')
fig = create_figure();
subplot(121); imshow(Blur1); title('Blur1')
subplot(122); imshow(Blur2); title('Blur2')
save_figure(fig, '1-imshow.png')

%%
% snk;
use_gvf(Blur1,0.6, 50, '1-Blur1');

%%
use_gvf(Blur2,0.6,50, '1-Blur2');

%%
fig = create_figure
read_mri_image = @(number) im2double(imread(['MRI' num2str(number) '.bmp']));
numMriImages = 5;
mri_images = arrayfun(read_mri_image, 1:numMriImages, 'UniformOutput', false);
for i = 1:numMriImages
image = mri_images{i}; 
rng(1)
Nc = 4;
image_size = size(image);
image_size_prod =  prod(image_size); 
X = reshape(image ,image_size_prod,[]);
X = bsxfun(@minus, X, mean(X));
X = bsxfun(@rdivide, X, std(X));

fix_image = @(im) reshape(im,image_size);
[~,U] = fcm(X,Nc,[2, NaN, NaN, false]);
U_hard = bsxfun(@eq, U, max(U));
subplot(1,5,i); imagesc(fix_image((1:Nc) * U_hard)); 
axis off; set(gca,'YDir','reverse')
title(sprintf('MRI%.0f.bmp',i))
end

% save_figure(fig,'3.1-kmeans.png')
