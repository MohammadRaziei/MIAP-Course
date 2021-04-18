clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';
city_noise = im2double(imread(fullfile(Questions_folder,'city_noise.jpg')));
city_orig  = im2double(imread(fullfile(Questions_folder,'city_orig.jpg' )));

montage_row({city_orig, city_noise}, {'original', 'noisy'})


SNR = @(x,y) 20*log10(norm(x,'fro')/ norm(x-y,'fro'));
snr_total = SNR(city_orig, city_noise);

[x11,x12,x21,x22] = split_image(city_orig);
[y11,y12,y21,y22] = split_image(city_noise);

snr1 = SNR(x11,y11);
snr2 = SNR(x12,y12);
snr3 = SNR(x21,y21);
snr4 = SNR(x22,y22);
%%
MovingAverageFilter = @(x,k) filter2(ones(k,k)/(k*k),x, 'same');
MeidanFilter = @(x,k) medfilt2(x,[k,k]);
GuassianFilter = @(x,sigma) imgaussfilt(x,sigma);

ma_p = 7; m_p = 3; g_p = 2;
funcs = {@(x)MovingAverageFilter(x,ma_p), @(x)MeidanFilter(x,m_p), @(x)GuassianFilter(x,g_p)};
X = {x11,x12,x21,x22};
Y = {y11,y12,y21,y22};
xlabels = {['GuassianFilter(x,' num2str(ma_p) ')'], ['MeidanFilter(x,' num2str(m_p) ')'], ['GuassianFilter(x,' num2str(g_p) ')']};
ylabels = {'up-left', 'up-right', 'down-left', 'down-right'};
fig = create_figure('figure', [0 0 1 1]);
for i = 1:4
    for f = 1:3
        y_denoise = funcs{f}(Y{i});
        ax = subplot(4,3,f+(i-1)*3); set ( ax, 'visible', 'off')
        imshowpair(Y{i},y_denoise, 'montage'); 
        title(['from ' num2str(SNR(X{i},Y{i}), '%.2f') ' to ' num2str(SNR(X{i}, y_denoise), '%.2f')])
        if i == 4, xlabel(xlabels{f}); end
        if f == 1, ylabel(ylabels{i}); end
    end
end
