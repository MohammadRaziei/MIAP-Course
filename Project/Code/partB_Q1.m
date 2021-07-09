clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
%%
atlas = readData('atlas', true);
img3d_true = atlas;
img3d_pred = circshift(atlas, 5);
ptCloud_true = extractCloudPoints(img3d_true, 0.5);
ptCloud_true.Color = uint8([]);
ptCloud_pred = extractCloudPoints(img3d_pred, 0.5);
ptCloud_pred.Color = uint8([]);
% 


DS = binary_dice_loss(img3d_true, img3d_pred);
JS = binary_jaccard_loss(img3d_true, img3d_pred);

% NOTE: enable this line to visulize HausdorffDist
% HD = HausdorffDist(ptCloud_true.Location, ptCloud_pred.Location, [], 'vis');
HD = HausdorffDist(ptCloud_true.Location, ptCloud_pred.Location, 1);


pcshowpair(ptCloud_true, ptCloud_pred);
xlabel('X');ylabel('Y');zlabel('Z')
title('Point clouds before registration')