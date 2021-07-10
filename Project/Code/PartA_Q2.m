clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
%%
subject_num = 6;
[seg3D, raw3D] = readData('subject', subject_num, true);
atlas = readData('atlas', true);
img3D = seg3D;
secondLine = '\newline\fontsize{8}';
%% method 1
close all
p = 0.08;
fig = create_figure('method 1 : isosurface', [0,0.3,1.1,0.4]);
sgtitle(sprintf('method 1 (using isosurface) for subject: %i',subject_num))

subplot(131);
timerStart = tic;
[tri, pos] = isosurface(img3D,0);
elapsedTime = toc(timerStart);
trisurf(tri, pos(:,1), pos(:,2), pos(:,3)); view(-1,45);
title(['isosurface', secondLine, ...
    sprintf('[time: %0.1f (ms)]',elapsedTime*1e3)], ...
    'Color', 'k', 'Interpreter','tex')

subplot(132);
timerStart = tic;
[tri, pos] = reducepatch(tri, pos, p, 'fast');
elapsedTime = toc(timerStart);
trisurf(tri, pos(:,1), pos(:,2), pos(:,3)); view(-1,45);
title(['reducepatch', secondLine, ...
    sprintf('[time: %0.1f (ms)]',elapsedTime*1e3)], ...
    'Color', 'k', 'Interpreter','tex')

subplot(133);
wpcshow(pos); view(-1,45);
title(sprintf('chosen point cloud (%.0f points)', size(pos, 1)), 'Color', 'k')
save_figure(fig, 'results/method1-isosurface.png')
pos = pos(:,[2 1 3]); % Mathworks isosurface indexes differently

%% method 2
close all;clc
p = 0.08;
fig = create_figure('method 2 : isosurface', [0,0.3,1.1,0.4]);
sgtitle(sprintf('method 2 (using isosurface) for subject: %i',subject_num))

subplot(131);
view(-1,45);
pan = uipanel(fig, 'Position', get(gca, 'Position').*[1,1,1,0.75]);
CameraPosition =  get(gca, 'CameraPosition');
axis('off')
volshow(uint32(img3D), 'Parent', pan, 'BackGroundColor', 'w', ...
    'CameraPosition', CameraPosition*0.25, 'CameraTarget', [-0.1,0,0], 'CameraViewAngle', 10); 
title('volshow', 'Color', 'k')

subplot(132);
timerStart1 = tic;%
[~, pos] = isosurface(img3D,0);
elapsedTime1 = toc(timerStart1);%
timerStart = tic;%
ptCloud = pointCloud(pos);
elapsedTime = toc(timerStart);%
wpcshow(ptCloud); view(-1,45);
title([sprintf('dense point cloud (%.0f points)', size(ptCloud.Location, 1)), secondLine, ...
    sprintf('[time: %0.1f + %0.1f (ms)]',elapsedTime1*1e3, elapsedTime*1e3)], ...
    'Color', 'k', 'Interpreter','tex')

subplot(133);
timerStart = tic;%
ptCloud = pcdownsample(ptCloud, 'gridAverage', 1/sqrt(0.75*p));
elapsedTime = toc(timerStart);%
wpcshow(ptCloud); view(-1,45);
title([sprintf('chosen point cloud (%.0f points)', size(ptCloud.Location, 1)), secondLine, ...
    sprintf('[time: %0.1f (ms)]', elapsedTime*1e3)], ...
    'Color', 'k', 'Interpreter','tex')

save_figure(fig, 'results/method2-isosurface.png')
pos = pos(:,[2 1 3]); % Mathworks isosurface indexes differently

%% method 3
close all
p = 0.1;
fig = create_figure('method 3 : bwperim3', [0.1,0.3,0.8,0.35]);
sgtitle(sprintf('method 3 (using bwperim3) for subject: %i',subject_num))

subplot(121);
timerStart = tic;%
img3D_BW = bwperim3(img3D);
[x,y,z] = ind2sub(size(img3D), find(img3D_BW>0));
ptCloud = pointCloud([x,y,z]);
elapsedTime = toc(timerStart);%
wpcshow(ptCloud);
view(-91,65)
title([sprintf('dense point cloud (%.0f points)', size(ptCloud.Location, 1)), secondLine, ...
    sprintf('[time: %0.1f (ms)]', elapsedTime*1e3)], ...
    'Color', 'k', 'Interpreter','tex')

subplot(122);
timerStart = tic;%
ptCloud = pcdownsample(ptCloud, 'random', p);
elapsedTime = toc(timerStart);%
wpcshow(ptCloud); view(-91,65)
title([sprintf('chosen point cloud (%.0f points)', size(ptCloud.Location, 1)), secondLine, ...
    sprintf('[time: %0.1f (ms)]', elapsedTime*1e3)], ...
    'Color', 'k', 'Interpreter','tex');
save_figure(fig, 'results/method3-bwperim3.png')

%% method 4
addpath('../Modules/iso2mesh')

fig = create_figure('method 4 : iso2mesh', [0,0.3,1.1,0.33]);
sgtitle('method 4 (using iso2mesh) for atlas')

subplot(131);
view(-1,45);
pan = uipanel(fig, 'Position', get(gca, 'Position').*[1,1,1,0.75]);
CameraPosition =  get(gca, 'CameraPosition');
axis('off')
labelvolshow(uint32(atlas), 'Parent', pan, 'BackGroundColor', 'w', ...
    'CameraPosition', CameraPosition*0.25, 'CameraTarget', [-0.2,+0.2,0], 'CameraViewAngle', 10); 
title('volshow', 'Color', 'k')

subplot(132)
timerStart = tic;%
opt = struct;
opt.radbound = 3; % set the target surface mesh element bounding sphere be <3 pixels in radius
opt.maxnode  = 5000;
opt.maxsurf  = 0;
method = 'cgalsurf';
isovalues = 0.5;
[pos, tri, regions, holes] = v2s(atlas, isovalues, opt, method);
pos = pos + 0.5; % undo the shift that has been introduced in vol2restrictedtri
tri = tri(:,1:3);
elapsedTime = toc(timerStart);%
trisurf(tri, pos(:,1), pos(:,2), pos(:,3)); view(-91,65);
title(['surf2mesh', secondLine, ...
    sprintf('[time: %0.1f (ms)]',elapsedTime*1e3)], ...
    'Color', 'k', 'Interpreter','tex')

subplot(133);
wpcshow(pos); view(-91,65);
title(sprintf('chosen point cloud (%.0f points)', size(pos, 1)), 'Color', 'k')
save_figure(fig, 'results/method4-iso2mesh.png')
pos = pos(:,[2 1 3]); % Mathworks isosurface indexes differently