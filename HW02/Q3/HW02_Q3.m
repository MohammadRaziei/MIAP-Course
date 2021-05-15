clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
chessboard = im2double(imread(fullfile(Questions_folder,'chessboard.jpg')));
image = rgb2gray(chessboard);

filters = {[1,-1], [1,0], [1,0,-1],transpose([1,0,-1]), [-1,-1,-1;-1,8,-1;-1,-1,-1]};

fig = create_figure('filters effects',[0.15 0.1 0.7 0.8]);
subplot(231); imagesc(image); colormap('gray'); xticklabels([]); yticklabels([])
xlabel('Raw image');
for i = 2:6
    subplot(2,3,i)
    imagescgray(filter2(filters{i-1}, image, 'same'));
    xlabel({'Filtered by: ' num2str(filters{i-1})});
end

save_figure(fig, 'partA - filters effects.png')


%% Part b

methods = {'Canny', 'Sobel', 'log'};
methods_str = {'Canny', 'Sobel', 'Laplacian of Gaussian'};

fig = create_figure('filters effects',[0.05 0.5 0.9 0.35]);
subplot(141); imagescgray(image); title('Raw image')
for i = 1:3
    subplot(1,4,i+1)
    image_edges = edge(image,methods{i});
    imagescgray(image_edges); title(methods_str{i})
end
save_figure(fig, 'partB.png')