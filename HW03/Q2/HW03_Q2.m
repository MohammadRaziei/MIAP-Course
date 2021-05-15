clc; clear; close all; addpath('../../CommonUtils', '../Questions')
Questions_folder = '../Questions/';

image = phantom('Modified Shepp-Logan', 500);
image_noisy = imnoise(image, 'gaussian', 0, 0.05*var(image(:)));
%%
hx = 10; hg = 0.01;
image_filt = BilateralFilter(image_noisy, hx, hg);
%%
clc; close all
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
save_figure(fig, ['image_filt-hx' num2str(hx) '-hg' num2str(hg) '.png'])

EPI(image, image_filt)

disp(['The SNR before bilateral-filter : ' num2str(snr_noisy)])
disp(['The SNR after bilateral-filter  : ' num2str(snr_filt)])

