clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
hand_xray = im2double(imread(fullfile(Questions_folder,'hand_xray.jpg')));
x = hand_xray;

fig = create_figure('Part A', [0.2,0.5,0.6,0.4]);
X = fft2(x);
subplot(121); imshow(x)
subplot(122); imagesc(log(abs(fftshift(X)))); colorbar; colormap('gray')
save_figure(fig, 'PartA.png')
%%
n = numel(x);
average = sum(x,'all') ; DC = X(1,1);
disp(['Summation: ' num2str(average) '    DC: ' num2str(DC) '  -->  Difference: ' num2str(abs(DC-average))])
disp(['Average: ' num2str(average/n) '    Normalized  DC: ' num2str(DC/n) '  -->  Difference: ' num2str(abs(DC-average)/n)])


