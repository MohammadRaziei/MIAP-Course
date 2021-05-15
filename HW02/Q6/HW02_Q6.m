clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
input_image = rgb2gray(im2double(imread(fullfile(Questions_folder,'wall.jpg'))));


 
% Saving the size of the input_image in pixels-
% M : no of rows (height of the image)
% N : no of columns (width of the image)
[M, N] = size(input_image);
  
% Getting Fourier Transform of the input_image
% using MATLAB library function fft2 (2D fast fourier transform)  
FT_img = fft2(double(input_image));

fig = create_figure('figure', [0.3,0.5,0.4,0.3]);
subplot(121); imagescgray(input_image);
subplot(122); imagescgray(log(abs(fftshift(FT_img))));
save_figure(fig, 'partA.png')

% Assign Cut-off Frequency  
D0 = 40; % one can change this value accordingly
  
% Designing filter
u = 0:(M-1);
idx = find(u>M/2);
u(idx) = u(idx)-M;
v = 0:(N-1);
idy = find(v>N/2);
v(idy) = v(idy)-N;
  
% MATLAB library function meshgrid(v, u) returns
% 2D grid which contains the coordinates of vectors
% v and u. Matrix V with each row is a copy 
% of v, and matrix U with each column is a copy of u
[V, U] = meshgrid(v, u);
  
% Calculating Euclidean Distance
D = sqrt(U.^2+V.^2);
  
% Comparing with the cut-off frequency and 
% determining the filtering mask
H = double(D <= D0);
  
% Convolution between the Fourier Transformed
% image and the mask
G = H.*FT_img;
  
% Getting the resultant image by Inverse Fourier Transform
% of the convoluted image using MATLAB library function 
% ifft2 (2D inverse fast fourier transform)  
output_image = real(ifft2(double(G)));
  
% Displaying Input Image and Output Image
fig = create_figure('figure', [0.2,0.5,0.6,0.3]);
subplot(1, 3, 1), imagescgray(input_image); title('input image')
subplot(1, 3, 2), imagescgray(fftshift(H)); title('filter response')
subplot(1, 3, 3), imagescgray(output_image); title('output image')
save_figure(fig, 'ideal low-pass-filtering.png')

H2 = 1 - H;
G = H2.*FT_img;
output_image = real(ifft2(double(G)));
% Displaying Input Image and Output Image
fig = create_figure('figure', [0.2,0.5,0.6,0.3]);
subplot(1, 3, 1), imagescgray(input_image); title('input image')
subplot(1, 3, 2), imagescgray(fftshift(H2)); title('filter response')
subplot(1, 3, 3), imagescgray(output_image); title('output image')
save_figure(fig, 'ideal high-pass-filtering.png')
%%
fig = create_figure('figure', [0.2,0.5,0.6,0.3]);
funcs = {@(x)imgaussfilt(x), @(x)butterworthlpf(x), @(x)imfilter(x, [-1,-1,-1; -1,8,-1; -1,-1,-1]) };
funcstr = {'Gaussian', 'Butter-worth', 'Laplacian'};
N = numel(funcs);
for i = 1:N
    subplot(1,N,i); 
    imshow(funcs{i}(input_image),[]);
    title(funcstr{i})
end
save_figure(fig, 'filtering.png')

