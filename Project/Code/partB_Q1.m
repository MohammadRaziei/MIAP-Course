clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
%%
atlas = readData('atlas', true);
img3d_true = atlas;
img3d_pred = circshift(atlas, 5);
% ptCloud_true = extractCloudPoints(img3d_true);
% ptCloud_true.Color = uint8([]);
% ptCloud_pred = extractCloudPoints(img3d_pred);
% ptCloud_pred.Color = uint8([]);
% pcshowpair(ptCloud_true, ptCloud_pred);
% 


DS = binary_dice_loss(img3d_true, img3d_pred);
JS = binary_jaccard_loss(img3d_true, img3d_pred);



