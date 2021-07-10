clc; close all; clear;
addpath('../../CommonUtils')
create_folder('results');
initCDP2;
%%
subject_num = 1;
[seg3D, raw3D] = readData('subject', subject_num, true);
atlas = readData('atlas', true);

fixed = atlas; moving = seg3D;
%%
fixed_labels = unique(fixed); fixed_labels = fixed_labels(2:end);
moving_labels = unique(moving); moving_labels = moving_labels(2:end);
common_labels = sort(intersect(fixed_labels, moving_labels));
%%
p = 0.05;
[~, fixed_ptCloud] = reducepatch(isosurface(ismember(fixed,[common_labels(1) common_labels(end)])), p);
fixed_ptCloud = pointCloud(fixed_ptCloud);
[~, moving_ptCloud] = reducepatch(isosurface(ismember(moving,[common_labels(1) common_labels(end)])), p);
moving_ptCloud = pointCloud(moving_ptCloud);
moving_ptCloud.Color = uint8([]); fixed_ptCloud.Color = uint8([]);
pcshowpair(fixed_ptCloud, moving_ptCloud);colorAxes

%%
p = 0.05;
moving_ptCloud = extractCloudPoints(moving, p);
fixed_ptCloud  = extractCloudPoints(fixed, p);
moving_ptCloud.Color = uint8([]); fixed_ptCloud.Color = uint8([]);
%%
fig = create_figure('before registeration', [0.4,0.2,0.4,0.55]);
pcshowpair(moving_ptCloud, fixed_ptCloud, 'MarkerSize',50); view(-60,30)
colorAxes
xlabel('X');ylabel('Y');zlabel('Z')
title(sprintf('Point clouds before registration for subject %.0f as the moving one', subject_num), 'Color','k');
legend({sprintf('Moving point cloud (%.0f points)', moving_ptCloud.Count), ...
    sprintf('Fixed point cloud (%.0f points)', fixed_ptCloud.Count)}, ...
    'TextColor','k', 'Location','southoutside')
% save_figure(fig, sprintf('results/partC1-pointCloud-before-registration-subject%.0f.png', subject_num))
%%
opt = struct; 
opt.method = 'affine'; opt.max_it = 40; opt.outlier = 0; opt.tol = 1e-8;
Transform = cpd_register(fixed_ptCloud.Location, moving_ptCloud.Location, opt);
% movingReg_ptCloud = pointCloud(Transform.Y);
tform = Transform2Tfrom(Transform);
% [tform, movingReg_ptCloud] = pcregistercpd(movingReg_ptCloud, fixed_ptCloud, 'Transform', 'rigid');
%%
p = 3000;
[~, fixed_ptCloud] = reducepatch(isosurface(fixed), p);
fixed_ptCloud = pointCloud(fixed_ptCloud);
[~, moving_ptCloud] = reducepatch(isosurface(moving), p);
moving_ptCloud = pointCloud(moving_ptCloud);
moving_ptCloud = pctransform(moving_ptCloud, tform);
pcshowpair(moving_ptCloud, fixed_ptCloud, 'MarkerSize', 50); view(-60,30); colorAxes
%%
opt = struct; 
opt.method = 'nonrigid'; opt.max_it = 100; opt.outlier = 0.05; opt.tol = 1e-8; opt.normalize = 0;
Transform = cpd_register(fixed_ptCloud.Location, moving_ptCloud.Location, opt);
movingReg_ptCloud = pointCloud(Transform.Y);
pcshowpair(moving_ptCloud, fixed_ptCloud, 'MarkerSize', 50); view(-60,30); colorAxes

%%
fig = create_figure(['after ' opt.method ' registeration'], [0.3,0.2,0.6,0.55]);
pcshowpair(movingReg_ptCloud, fixed_ptCloud, 'MarkerSize', 50); view(-60,30); colorAxes
xlabel('X');ylabel('Y');zlabel('Z')
title({sprintf('Point clouds after ''%s'' registration for subject %.0f as the moving one', opt.method, subject_num), ...
        sprintf('Dice score: %.3f,    Jaccard Index: %.3f,    Hausdorff Distance: %.2f,     Average Surface Distance: %.2f', DS, JS, HD, ASD)},'Color','k');
legend({'Moving point cloud','Fixed point cloud'},'TextColor','k', 'Location','southoutside')
% save_figure(fig, sprintf('results/partC1-pointCloud-after-%s-registration-subject%.0f.png', opt.method, subject_num))
%%
% movingReg = imwarp(moving, tform);
% disp('Calculating DDF from points ... ')
% DDF = calculate_DDF(movingReg_ptCloud, moving_ptCloud, size(moving));
% disp('DDF calculation is finished.')
%%

