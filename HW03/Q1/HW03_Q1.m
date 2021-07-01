clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';  addpath(Questions_folder);

fig = create_figure();
image = phantom('Modified Shepp-Logan', 500);
image_noisy = imnoise(image, 'gaussian', 0, 0.05*var(image(:)));
imshowpair(image, image_noisy, 'montage')

% img = imnlmfilt(image_noisy);
sigma = 5; similarityWindow = 2; searchWindow = 3 * similarityWindow;
% image_filt=NonLocalMeansFilter(image_noisy,searchWindow,similarityWindow,sigma);
image_filt=NonLocalMeansFilter(image_noisy,searchWindow,similarityWindow,10);
%%
SNR = @(x, y) 20 * log10((norm(x(:))/(norm(x(:)-y(:)))));
snr_noisy = SNR(image, image_noisy);
snr_filt = SNR(image, image_filt);
epi_noisy = EPI(image, image_noisy);
epi_filt = EPI(image, image_filt);

fig = create_figure();
imshowpair(image, image_noisy, 'montage')
title(['raw-image' 32*ones(1,74) 'noisy-image'])
save_figure(fig, 'image_noisy.png')

fig = create_figure();
imshowpair(image_noisy, image_filt, 'montage')
title(['noisy-image (SNR:' num2str(snr_noisy,'%.2f') ', EPI:' num2str(epi_noisy,'%0.3f') ')' 32*ones(1,40)...
    'filtered-image (SNR:' num2str(snr_filt,'%.2f') ', EPI:' num2str(epi_filt,'%0.3f') ')'])
save_figure(fig, 'image_filt-NLM.png')

%%
image_filt_m = imnlmfilt(image_noisy, 'ComparisonWindowSize', 3, 'SearchWindowSize', 3*3);
SNR = @(x, y) 20 * log10((norm(x(:))/(norm(x(:)-y(:)))));
snr_noisy = SNR(image, image_noisy);
snr_filt = SNR(image, image_filt_m);
epi_noisy = EPI(image, image_noisy);
epi_filt = EPI(image, image_filt_m);

fig = create_figure();
imshowpair(image, image_noisy, 'montage')
title(['raw-image' 32*ones(1,74) 'noisy-image'])
save_figure(fig, 'image_noisy.png')

fig = create_figure();
imshowpair(image_noisy, image_filt_m, 'montage')
title(['noisy-image (SNR:' num2str(snr_noisy,'%.2f') ', EPI:' num2str(epi_noisy,'%0.3f') ')' 32*ones(1,40)...
    'filtered-image (SNR:' num2str(snr_filt,'%.2f') ', EPI:' num2str(epi_filt,'%0.3f') ')'])
save_figure(fig, 'image_filt-NLM-matlab.png')
