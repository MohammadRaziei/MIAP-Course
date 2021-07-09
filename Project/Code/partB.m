clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
%%
atlas = readData('atlas', true);
img3d_true = atlas;
img3d_pred = circshift(atlas, 5);
ptCloud_true = extractCloudPoints(img3d_true, 0.5); ptCloud_true.Color = uint8([]);
ptCloud_pred = extractCloudPoints(img3d_pred, 0.5); ptCloud_pred.Color = uint8([]);

BDS = calc_loss(@binary_dice_loss,      img3d_true, img3d_pred);
DS  = calc_loss(@dice_loss,             img3d_true, img3d_pred);
BJS = calc_loss(@binary_jaccard_loss,   img3d_true, img3d_pred);
JS  = calc_loss(@jaccard_loss,          img3d_true, img3d_pred);
ASD = calc_loss(@AverageSurfaceDist,    ptCloud_true, ptCloud_pred);
% NOTE: enable this line to visulize HausdorffDist
% HD = HausdorffDist(ptCloud_true.Location, ptCloud_pred.Location, [], 'vis');
HD = HausdorffDist(ptCloud_true.Location, ptCloud_pred.Location, 1);

save_csv('results/partB-table-indices1.csv', [round([BDS, DS],3), round([HD, ASD],2)], ...
    {'Binary Dice score', 'Dice score', 'Hausdorff Distance', 'Average Surface Distance'})
save_csv('results/partB-table-indices2.csv', round([BJS, JS],3), ...
    {'Binary Jaccard Index', 'Jaccard Index'})

%%
fig = create_figure('partB-pcshowpair-indices', [0.2, 0.2,0.6,0.6]);
pcshowpair(ptCloud_true, ptCloud_pred); view(-25,35);
colorAxes
xlabel('X');ylabel('Y');zlabel('Z')
title(sprintf('Dice score: %.3f,    Jaccard Index: %.3f,    Hausdorff Distance: %.2f,     Average Surface Distance: %.2f', DS, JS, HD, ASD), 'Color', 'k')
legend({'TRUE segments','PREDICTED segments'},'TextColor','k', 'Location','southoutside')
save_figure(fig, 'results/partB-pcshowpair-indices.png')