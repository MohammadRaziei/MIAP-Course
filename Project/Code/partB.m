clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
%%
offset = 5;
atlas = readData('atlas', true);
img3d_true = atlas;
img3d_pred = circshift(atlas, offset);
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
%%
fig = create_figure('partB-pcshowpair-indices', [0.2, 0.2,0.6,0.6]);
pcshowpair(ptCloud_true, ptCloud_pred); view(-25,35);
colorAxes
xlabel('X');ylabel('Y');zlabel('Z')
title(sprintf('Dice score: %.3f,    Jaccard Index: %.3f,    Hausdorff Distance: %.2f,     Average Surface Distance: %.2f', DS, JS, HD, ASD), 'Color', 'k')
legend({'TRUE segments','PREDICTED segments'},'TextColor','k', 'Location','southoutside')
save_figure(fig, 'results/partB-pcshowpair-indices.png')

%%

atlas = readData('atlas', true);
img3d_true = atlas;

table_csv = [];
for offset = [0 1 3 5 7 10]
    img3d_pred = circshift(atlas, offset);
    ptCloud_true = extractCloudPoints(img3d_true, 0.5); ptCloud_true.Color = uint8([]);
    ptCloud_pred = extractCloudPoints(img3d_pred, 0.5); ptCloud_pred.Color = uint8([]);
    
    BDS = calc_loss(@binary_dice_loss,      img3d_true, img3d_pred);
    DS  = calc_loss(@dice_loss,             img3d_true, img3d_pred);
    BJS = calc_loss(@binary_jaccard_loss,   img3d_true, img3d_pred);
    JS  = calc_loss(@jaccard_loss,          img3d_true, img3d_pred);
    ASD = calc_loss(@AverageSurfaceDist,    ptCloud_true, ptCloud_pred);
    HD = HausdorffDist(ptCloud_true.Location, ptCloud_pred.Location, 1);

    table_csv = [table_csv; [offset, round([HD, ASD],2), round([BDS, DS, BJS, JS],3)]];
end
save_csv('results/partB-table-indices1.csv', table_csv(:,1:3), ...
    {'offset', 'Hausdorff Distance', 'Average Surface Distance'})
save_csv('results/partB-table-indices2.csv', table_csv(:,4:end), ...
    {'Binary Dice score', 'Dice score', 'Binary Jaccard Index', 'Jaccard Index'})

%%

