clc; close all; clear;
addpath('../../CommonUtils')
create_folder('results');
initCDP2;
%%
subject_num = 1;
[seg3D, raw3D] = readData('subject', subject_num, true);
atlas = readData('atlas', true);

fixed = atlas; moving = seg3D;
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
save_figure(fig, sprintf('results/partC1-pointCloud-before-registration-subject%.0f.png', subject_num))
%%
opt = struct; 
opt.method = 'nonrigid';
opt.max_it = 60;
Transform = cpd_register(fixed_ptCloud.Location, moving_ptCloud.Location, opt);
tform = Transform2Tfrom(Transform);
movingReg_ptCloud = pctransform(moving_ptCloud, tform);
%%
% movingRegFixedSize = imwarp(moving,tform,'OutputView',imref3d(size(fixed)));

% DS  = calc_loss(@binary_dice_loss, fixed, movingRegFixedSize);
% JS  = calc_loss(@binary_jaccard_loss, fixed, movingRegFixedSize);
ASD = calc_loss(@AverageSurfaceDist, fixed_ptCloud, movingReg_ptCloud);
HD  = calc_loss(@HausdorffDist, fixed_ptCloud.Location, movingReg_ptCloud.Location);
%%
fig = create_figure('after nonrigid registeration', [0.3,0.2,0.6,0.55]);
pcshowpair(movingReg_ptCloud, fixed_ptCloud, 'MarkerSize', 50); view(-60,30); colorAxes
xlabel('X');ylabel('Y');zlabel('Z')
title({sprintf('Point clouds after ''%s'' registration for subject %.0f as the moving one', opt.method, subject_num), ...
        sprintf('Hausdorff Distance: %.2f,     Average Surface Distance: %.2f', HD, ASD)},'Color','k');
legend({'Moving point cloud','Fixed point cloud'},'TextColor','k', 'Location','southoutside')
save_figure(fig, sprintf('results/partC1-pointCloud-after-%s-registration-subject%.0f.png', opt.method, subject_num))
%%
% movingReg = imwarp(moving, tform);
% disp('Calculating DDF from points ... ')
% DDF = calculate_DDF(movingReg_ptCloud, moving_ptCloud, size(moving));
% disp('DDF calculation is finished.')
%%

