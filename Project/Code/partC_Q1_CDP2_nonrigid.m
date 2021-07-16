clc; close all; clear;
addpath('../../CommonUtils')
create_folder('results');
initCDP2;
%%
subject_num = 2;
[seg3D, raw3D] = readData2('subject', subject_num, true);
atlas = readData2('atlas', true);
fixed = atlas; moving = seg3D;
%%
fixed_labels = unique(fixed); fixed_labels = fixed_labels(2:end);
moving_labels = unique(moving); moving_labels = moving_labels(2:end);
common_labels = sort(intersect(fixed_labels, moving_labels));
%%
p = 6000;
[~, fixed_ptCloud] = reducepatch(isosurface(ismember(fixed,common_labels)), p);
fixed_ptCloud = [fixed_ptCloud(:,2) fixed_ptCloud(:,1) fixed_ptCloud(:,3)];
[~, moving_ptCloud] = reducepatch(isosurface(ismember(moving,common_labels)), p);
moving_ptCloud = [moving_ptCloud(:,2) moving_ptCloud(:,1) moving_ptCloud(:,3)];
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
save_figure(fig, sprintf('results/partC1-pointCloud-before-registration-subject%.0f.png', subject_num))
%%
opt = struct; 
opt.method = 'nonrigid';
opt.max_it = 60;
create_figure
Transform = cpd_register(fixed_ptCloud.Location, moving_ptCloud.Location, opt);
tform = Transform2Tform(Transform);
movingReg_ptCloud = pctransform(moving_ptCloud, tform);
%%
% movingRegFixedSize = imwarp(moving,tform,'OutputView',imref3d(size(fixed)));
% movingReg = imwarp(moving, tform);
disp('Calculating DDF from points ... ')
tic
DDF = calculate_DDF_from_tform(tform, moving_ptCloud, size(moving), [], true);
toc
disp('DDF calculation is finished.')
%%
movingReg = imwarp(moving,DDF, 'nearest');
fixedC = logical(fixed)*10;
movingRegC = logical(movingReg)*30;
cmap = [1,1,1; 0,1,0; 0.5,0.5,0; 1,0,0];

DS = calc_loss(@binary_dice_loss, fixed, movingReg);
JS = calc_loss(@binary_jaccard_loss, fixed, movingReg);
SI = calc_intersection_spines(moving, DDF, common_labels, true);
ASD = calc_loss(@AverageSurfaceDist, fixed_ptCloud, movingReg_ptCloud);
HD  = calc_loss(@HausdorffDist, fixed_ptCloud.Location, movingReg_ptCloud.Location);

fig = create_figure('after nonrigid registeration', [0.2,0.3,0.6,0.5]);

subplot(121);
view(175,-5);
pan = uipanel(fig, 'Position', get(gca, 'Position').*[1,1,1,0.9], 'BorderType', 'none');
CameraPosition = get(gca, 'CameraPosition');
axis('off')
labelvolshow(movingRegC * 0.5 + fixedC * 0.5, 'LabelColor', cmap, 'Parent', pan, 'BackgroundColor', 'w', ...
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
save_figure(fig, sprintf('results/partC1-total-after-%s-registration-subject%.0f.png', opt.method, subject_num))
