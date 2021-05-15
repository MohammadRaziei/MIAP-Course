clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
hand_xray = im2double(imread(fullfile(Questions_folder,'hand_xray.jpg')));
brain_xray = im2double(imread(fullfile(Questions_folder,'brain_xray.jpg')));
x1 = hand_xray;     x2 = brain_xray;

X1 = fft2(x1);      X2 = fft2(x2);
abs1 = abs(X1);     abs2 = abs(X2);

Y1 = X1 ./ abs1 .* abs2; % phase(X1) and abs(X2) 
Y2 = X2 ./ abs2 .* abs1; % phase(X2) and abs(X1)
% or
% Y1 = abs(X2) ./ exp(1j*angle(X1)); % phase(X1) and abs(X2) 
% Y2 = abs(X1) ./ exp(1j*angle(X2));% phase(X2) and abs(X1)

y1 = real(ifft2(Y1));     y2 = real(ifft2(Y2));

fig = create_figure;
subplot(221); imshow(x1); title('X_1')
subplot(222); imshow(x2); title('X_2')
subplot(223); imshow(y1); title('phase(X2) and abs(X1)')
subplot(224); imshow(y2); title('phase(X1) and abs(X2)')
save_figure(fig, 'switch_phase-amp.png')

