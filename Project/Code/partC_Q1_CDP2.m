clc; close all; clear;
addpath('../../CommonUtils')
create_folder('results');
initCDP2;
%%
subject_num = 6;
[seg3D, raw3D] = readData2('subject', subject_num, true);
atlas = readData2('atlas', true);
fixed = atlas; moving = seg3D;
%%
fixed_labels = unique(fixed); fixed_labels = fixed_labels(2:end);
moving_labels = unique(moving); moving_labels = moving_labels(2:end);
common_labels = sort(intersect(fixed_labels, moving_labels));
%%
p = 6000;
[~, fixed_ptCloud] = reducepatch(isosurface(ismember(fixed,[common_labels(1:end)])), p);
[~, moving_ptCloud] = reducepatch(isosurface(ismember(moving,[common_labels(1:end)])), p);
fixed_ptCloud = pointCloud(fixed_ptCloud);
moving_ptCloud = pointCloud(moving_ptCloud);

%%
fig = create_figure('before registeration', [0.4,0.2,0.4,0.55]);
pcshowpair(moving_ptCloud, fixed_ptCloud, 'MarkerSize',50); view(75,-5)
colorAxes
xlabel('X');ylabel('Y');zlabel('Z')
title(sprintf('Point clouds before registration for subject %.0f as the moving one', subject_num), 'Color','k');
legend({sprintf('Moving point cloud (%.0f points)', moving_ptCloud.Count), ...
    sprintf('Fixed point cloud (%.0f points)', fixed_ptCloud.Count)}, ...
    'TextColor','k', 'Location','southoutside')
save_figure(fig, sprintf('results/partC1-chosen-pointCloud-before-registration-subject%.0f.png', subject_num))
%%
opt = struct; 
opt.method = 'affine'; opt.max_it = 70; opt.outlier = 0; opt.tol = 1e-8;
Transform = cpd_register(fixed_ptCloud.Location, moving_ptCloud.Location, opt);
movingReg0_ptCloud = pointCloud(Transform.Y);
tform0 = Transform2Tform(Transform);
% [tform, movingReg_ptCloud] = pcregistercpd(movingReg_ptCloud, fixed_ptCloud, 'Transform', 'rigid');
figure('Color','w');
pcshowpair(movingReg0_ptCloud, fixed_ptCloud, 'MarkerSize', 50); view(75,-5); colorAxes

%%
opt = struct; 
opt.method = 'nonrigid'; opt.max_it = 50; opt.outlier = 0.05; opt.tol = 1e-6; opt.normalize = 0;
Transform = cpd_register(fixed_ptCloud.Location, movingReg0_ptCloud.Location, opt);
tform = Transform2Tform(Transform);
movingReg_ptCloud = pointCloud(Transform.Y);
figure('Color','w');
pcshowpair(movingReg_ptCloud, fixed_ptCloud, 'MarkerSize', 50); view(75,-5); colorAxes
%%
DDF0 = calculate_DDF_from_tform2(tform0, moving);
DDF1 = calculate_DDF_from_tform(tform, movingReg0_ptCloud, size(moving), true, true); DDF1(isnan(DDF1)) = 0;
DDF = bsxfun(@plus, DDF0, DDF1);
%%
movingReg = imwarp(moving,DDF, 'nearest');
fixed_points = fixed_ptCloud.Location;
movingReg_points = movingReg_ptCloud.Location;
% [~, fixed_points] = reducepatch(isosurface(ismember(fixed,common_labels)), 0.1);
% fixed_points = fixed_points(:,[2 1 3]);
% [~, movingReg_points] = reducepatch(isosurface(ismember(movingReg,common_labels)), 0.1);
% movingReg_points = movingReg_points(:,[2 1 3]);

fixedC = logical(fixed)*4;
movingRegC = logical(movingReg)*6;
color_fixed = [0,1,0];
color_movingReg = [1,0,0];
compareC = 0.5 * fixedC + 0.5 * movingRegC;
compareC_unique = unique(compareC);
cmap = zeros(6,3); cmap(1,:) = [0 0 1];% dummy
cmap(3,:) = color_fixed; cmap(4,:) = color_movingReg; cmap(6,:) = 0.5*color_movingReg + 0.5 * color_fixed;
cmap = cmap(compareC_unique+1,:);

DS = calc_loss(@binary_dice_loss, fixed, movingReg);
JS = calc_loss(@binary_jaccard_loss, fixed, movingReg);
SI = calc_intersection_spines(moving, DDF, common_labels, true);
HD  = calc_loss(@HausdorffDist, fixed_points, movingReg_points);
ASD = calc_loss(@AverageSurfaceDist, fixed_points, movingReg_points);
%
fig = create_figure('after nonrigid registeration', [0.2,0.3,0.6,0.5]);

subplot(121);
view(175,-5);
pan = uipanel(fig, 'Position', get(gca, 'Position').*[1,1,1,0.9], 'BorderType', 'none');
CameraPosition = get(gca, 'CameraPosition');
axis('off')
labelvolshow(compareC, 'LabelColor', cmap, 'Parent', pan, 'BackgroundColor', 'w', ...
        'CameraPosition', CameraPosition * 0.6, 'CameraTarget', [0, 0, -0.1], 'CameraViewAngle', 10); 

subplot(122);
pcshowpair(movingReg_ptCloud, fixed_ptCloud, 'MarkerSize', 50); view(75,-5); colorAxes
xlabel('X');ylabel('Y');zlabel('Z')
legend({sprintf('Moving point cloud (%.0f points)', moving_ptCloud.Count);
    sprintf('Fixed point cloud (%.0f points)', fixed_ptCloud.Count)},...
    'TextColor','k', 'Location','southoutside')

sgtitle({sprintf('Point clouds after ''%s'' registration for subject %.0f as the moving one', opt.method, subject_num);
        sprintf('Dice Score: %.2f,     Jaccard Score: %.2f,     Spines Intersection: %.0f', DS, JS, SI);
        sprintf('Hausdorff Distance: %.2f,     Average Surface Distance: %.2f', HD, ASD)}, ...
        'Color','k', 'FontSize', 10);
save_figure(fig, sprintf('results/partC1-chosen-total-after-%s-registration-subject%.0f.png', opt.method, subject_num))
