clc; clear; close all; addpath('../../CommonUtils');
Questions_folder = '../Questions/';  addpath(Questions_folder);

read_mri_image = @(number) im2double(imread(['MRI' num2str(number) '.bmp']));
numMriImages = 5;
mri_images = arrayfun(read_mri_image, 1:numMriImages, 'UniformOutput', false);

%% I
fig = create_figure();
montage_row(mri_images);
save_figure(fig, '1-all.png')

fig = create_figure();
subplot(121); imshow(cat(3, mri_images{[3,4,5]})); title('[3,4,5]');
subplot(122); imshow(cat(3, mri_images{[2,4,5]})); title('[2,4,5]');
save_figure(fig, '1-show3d.png')

%% II
image = mri_images{4};

Nc = 4;
image_size = size(image);
image_size_prod =  prod(image_size); 
X = reshape(image ,image_size_prod,[]);
X = bsxfun(@minus, X, mean(X));
X = bsxfun(@rdivide, X, std(X));

fix_image = @(im) reshape(im,image_size);
compute_for = @(U) arrayfun(@(c) fix_image(U(c,:)), 1:Nc, 'UniformOutput', false);

q = [1.4, 5, 1.04];
fig = create_figure([],[0,0.3,1,0.4]);
len_q = length(q);
U_save = zeros(len_q,image_size_prod);
U_hard_save = zeros(len_q, image_size_prod);
for i = 1:len_q
    rng(2*i)
    U = initfcm(Nc, image_size_prod);
    [~,U] = fcm2(X ,Nc,[q(i), NaN, NaN, false], U);
    U_hard = bsxfun(@eq, U, max(U));
    U_save(i, :) = (1:Nc) * U; U_hard_save(i, :) = (1:Nc) * U_hard;
    subplot(1,len_q,i); 
    title_name = sprintf('for q=%.2g',q(i));
    montage_row([compute_for(U); compute_for(U_hard)]);
    title(title_name)
end
save_figure(fig,'2-fcm.png');
%%
fig = create_figure();
for i = 1:len_q
    subplot(2,len_q, i); set(gca,'YDir','reverse'); axis off; 
    imagesc(fix_image(U_save(i,:)));
    title(sprintf('for q=%.2g',q(i)))
    if i==1, ylabel('Soft'); end
    subplot(2,len_q,i+length(q)); set(gca,'YDir','reverse'); axis off; 
    imagesc(fix_image(U_hard_save(i,:)));
    if i==1, ylabel('Hard'); end
end
save_figure(fig,'2-fcm-imagesc.png');


%% III
rng(1)
Nc = 4;
[U_Kmeans, centers] = kmeans(X, Nc);
fig = create_figure('kmeans', [0.2,0.4,0.3,0.5]);
hold on; axis off; set(gca,'YDir','reverse')
xlim([1 image_size(1)]); ylim([1 image_size(2)]);
imagesc(fix_image(U_Kmeans));
save_figure(fig,'3.1-kmeans.png')
% viscircles([100 100;200,200,], 1,'Color','red');

U_kmeans = bsxfun(@eq, U_Kmeans.', unique(U_Kmeans));
fig = create_figure([],[0,0.3,1,0.5]);
for i = 1:len_q
    rng(2*i)
    [~,U] = fcm2(X,Nc,[q(i), NaN, NaN, false], U_kmeans);
    U_hard = bsxfun(@eq, U, max(U));
    U_save(i, :) = (1:Nc) * U; U_hard_save(i, :) = (1:Nc) * U_hard;
    subplot(1,len_q,i); 
    title_name = sprintf('for q=%.2g',q(i));
    montage_row([compute_for(U); compute_for(U_hard)]);
    title(title_name)
end
save_figure(fig,'3-fcm.png');
%%
fig = create_figure();
for i = 1:len_q
    subplot(2,len_q, i); 
    imagesc(fix_image(U_save(i,:)));
    axis off; set(gca,'YDir','reverse')
    if i==1, ylabel('Soft'); end
    title(sprintf('for q=%.2g',q(i)))
    subplot(2,len_q,i+length(q));
    imagesc(fix_image(U_hard_save(i,:)));
     axis off; set(gca,'YDir','reverse')
    if i==1, ylabel('Hard'); end
end
save_figure(fig,'3-fcm-imagesc.png');

%% IV
rng(3);clc
% k = 3; % Number of GMM components
% X = (1:image_size_prod).'; Y = X;
for i = 1:len_q
    options = statset('MaxIter',1000);
    [~,U] = fcm2(X, Nc,[q(i),NaN,NaN,0],U_kmeans);
    [~,U_hard] = max(U);
    gm = fitgmdist(X,Nc,'Options',options,'Start', U_hard);
    % pdf(gm, [1;2])
    U_save(i,:) = cluster(gm, X);
end
fig = create_figure('4-gmm-imagesc',[0.1,0.4,0.8,0.3]);
for i = 1:len_q
    subplot(1,len_q, i); 
    imagesc(fix_image(U_save(i,:)));
    title(sprintf('for q=%0.2g',q(i)))
    axis off; set(gca,'YDir','reverse')
end
save_figure(fig,'4-gmm-imagesc.png');
%%
% x = 1:image_size(1); y = 1:image_size(2);
% [x,y] = meshgrid(x,y);
% x = x(:); y = y(:);
% x = linspace(0,1,image_size_prod);
p = gm.ComponentProportion;
gmm_dists = arrayfun(@(c) makedist('normal',gm.mu(c),sqrt(gm.Sigma(c))), 1:Nc, 'UniformOutput', false);
gmm_parts = arrayfun(@(c) p(c)*pdf(gmm_dists{c},X), 1:Nc, 'UniformOutput', false);

fig = create_figure('4-gmm-parts',[0.1,0.4,0.8,0.3]);
for i = 1:Nc
    subplot(1,Nc, i); 
    imshow(fix_image(gmm_parts{i}),[],'Border','tight');
end
save_figure(fig, '4-gmm-parts.png')