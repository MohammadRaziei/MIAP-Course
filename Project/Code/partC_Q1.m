clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
data_dir = '../data/';
%%
subject_num = 6;
[img_pack_label, img_pack] = readData('subject', subject_num, true);

atlas = readData('atlas', true);


p = 0.05;
[moving_xyzPoints, moving_labels, moving_ptCloud] = extractCloudPoints(img_pack_label, p);
[fixed_xyzPoints, fixed_labels, fixed_ptCloud] = extractCloudPoints(atlas, p);

moving_ptCloud.Color = uint8([]); fixed_ptCloud.Color = uint8([]);

pcshowpair(moving_ptCloud,fixed_ptCloud,'MarkerSize',50)
xlabel('X');ylabel('Y');zlabel('Z')
title('Point clouds before registration')
legend({'Moving point cloud','Fixed point cloud'},'TextColor','w', 'Location','southoutside')

%%
if false
% % Init full set of options %%%%%%%%%%
opt.method='nonrigid'; % use nonrigid registration
% opt.beta=2;            % the width of Gaussian kernel (smoothness)
% opt.lambda=3;          % regularization weight

% opt.viz=1;              % show every iteration
opt.outliers=0.;       % noise weight
opt.fgt=0;              % do not use FGT (default)
opt.normalize=1;        % normalize to unit variance and zero mean before registering (default)
opt.corresp=0;          % compute correspondence vector at the end of registration (not being estimated by default)

opt.max_it=20 ;         % max number of iterations
% opt.tol=1e-10;          % tolerance
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
[Transform, C]=cpd_register(fixed_xyzPoints,moving_xyzPoints, opt);
end
%%
tic
% [tform2,movingReg, rmse] = pcregistercpd(moving_ptCloud, fixed_ptCloud, 'Transform', 'rigid');
[tform2,movingReg, rmse] = pcregistercpd(moving_ptCloud, fixed_ptCloud, 'Verbose', true);
toc
% movingReg = pctransform(movingDownsampled,tform);
%%
pcshowpair(movingReg,fixed_ptCloud,'MarkerSize',50)
xlabel('X');ylabel('Y');zlabel('Z')
title('Point clouds after registration')
legend({'Moving point cloud','Fixed point cloud'},'TextColor','w', 'Location','southoutside')
%%
clc
[xq,yq,zq] = meshgridas(img_pack_label);
method = 'linear';
[m,n,p] = size(img_pack_label);
DDF=zeros(m,n,p,3);
DDF_T = struct;
DDF_T.x = scatteredInterpolant(moving_xyzPoints, tform2(:,1), method);
DDF_T.y = scatteredInterpolant(moving_xyzPoints, tform2(:,2), method);
DDF_T.z = scatteredInterpolant(moving_xyzPoints, tform2(:,3), method);
DDF(:,:,:,1)= DDF_T.x(xq,yq,zq);
DDF(:,:,:,2)= DDF_T.y(xq,yq,zq);
DDF(:,:,:,3)= DDF_T.z(xq,yq,zq);
% %%
% DDF(:,:,:,1) = griddata(moving_xyzPoints(:,1), moving_xyzPoints(:,2), moving_xyzPoints(:,3), tform2(:,1), xq, yq, zq, method);
% DDF(:,:,:,2) = griddata(moving_xyzPoints(:,1), moving_xyzPoints(:,2), moving_xyzPoints(:,3), tform2(:,2), xq, yq, zq, method);
% DDF(:,:,:,3) = griddata(moving_xyzPoints(:,1), moving_xyzPoints(:,2), moving_xyzPoints(:,3), tform2(:,3), xq, yq, zq, method);

%%
reg_label = imwarp(img_pack_label,DDF);
% reg_label = round(reg_label);
volshow(round(reg_label), 'Colormap', colormap('hot'))
% movingReg = pctransform(moving_ptCloud,tform); 