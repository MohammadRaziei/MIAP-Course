function use_gvf(I, r, numIter, save_name_prefix)
if nargin < 3, numIter = 50; end
if nargin < 4, save_name_prefix = ''; end
% Compute its edge map
disp(' Compute edge map ...');
f = edge(I,'canny');
% f = (I > 0.5);
% imshow(f,[])
%%
% Compute the GVF of the edge map f
disp(' Compute GVF ...');
[u,v] = GVF(f, 0.2, 80); 
disp(' Nomalizing the GVF external force ...');
mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10); 

% display the results
fig= figure; 
subplot(221); imdisp(I); title('test image');
subplot(222); imdisp(f); title('edge map');

% display the gradient of the edge map
[fx,fy] = gradient(f); 
subplot(223); quiver(fx,fy); 
axis off; axis equal; axis 'ij';     % fix the axis 
title('edge map gradient');

% display the GVF 
subplot(224); quiver(px,py);
axis off; axis equal; axis 'ij';     % fix the axis 
title('normalized GVF field');
% 
% snake deformation
disp(' Press any key to start GVF snake deformation');
% pause;
subplot(221);
image(((1-f)+1)*40); 
axis('square', 'off');
colormap(gray(64)); 
t = 0:0.05:6.28;

image_size = size(I);
x = image_size(2)*0.5 +   image_size(2)/2*r*cos(t);
y = image_size(1)*0.5 +   image_size(1)/2*r*sin(t);
% [x,y] = snakeinterp(x,y,3,1); % this is for student version
% % for professional version, use 
  [x,y] = snakeinterp(x,y,2,0.5);
% 
snakedisp(x,y,'r') 
% pause(1);
% 
a = floor(numIter/15);
for i=1:numIter
[x,y] = snakedeform(x,y,0.05,0,1,0.6,px,py,5);
[x,y] = snakeinterp(x,y,3,1); % this is for student version
% for professional version, use 
%   [x,y] = snakeinterp(x,y,2,0.5);
if mod(i,a)==0,pause(0.5); snakedisp(x,y,'r'); end 
title(['Deformation in progress,  iter = ' num2str(i*5)])
end
save_figure(fig, sprintf('%s-GVF-subplots.png',save_name_prefix));
% 
% disp(' Press any key to display the final result');
% pause;
% cla;
%%
fig = create_figure;
% colormap(gray(64)); image(((1-f)+1)*40); axis('square', 'off');
imshow(I,[])
snakedisp(x,y,'r') 
title(['Final result,  iter = ' num2str(i*5)]);
save_figure(fig,sprintf('%s-GVF-finalResults.png', save_name_prefix));
% disp(' ');
% disp(' Press any key to run the next example');
% pause;
% 
% 
% % ==== Example 2: Room like object ====     
% 
% % Read in the 64x64 room image
% [I,map] = rawread('../images/room.pgm');  
% 
% % Compute its edge map
% disp(' Compute edge map ...');
% f = 1 - I/255; 
% 
% % Compute the GVF of the edge map f
% disp(' Compute GVF ...');
% [px,py] = GVF(f, 0.2, 80); 
% 
% % display the results
% figure(1); 
% subplot(221); imdisp(I); title('test image');
% subplot(222); imdisp(f); title('edge map');
% 
% % display the gradient of the edge map
% [fx,fy] = gradient(f); 
% subplot(223); quiver(fx,fy); 
% axis off; axis equal; axis 'ij';     % fix the axis 
% title('edge map gradient');
% 
% % display the GVF 
% subplot(224); quiver(px,py);
% axis off; axis equal; axis 'ij';     % fix the axis 
% title('GVF field');
% 
% % snake deformation
% disp(' Press any key to start GVF snake deformation');
% pause;
% figure(1); subplot(221);
% colormap(gray(64)); 
% image(((1-f)+1)*40); axis('square', 'off');
% t = 0:0.5:6.28;
% x = 32 + 3*cos(t);
% y = 32 + 3*sin(t);
% [x,y] = snakeinterp(x,y,2,0.5);
% snakedisp(x,y,'r'); 
% pause(1);
% 
% for i=1:15,
% [x,y] = snakedeform(x,y,0.05,0,1,2,px,py,5);
% [x,y] = snakeinterp(x,y,2,0.5);
% snakedisp(x,y,'r') 
% title(['Deformation in progress,  iter = ' num2str(i*5)])
% pause(0.5);
% end
% 
% disp(' Press any key to display the final result');
% pause;
% figure(1); subplot(221);
% colormap(gray(64)); 
% image(((1-f)+1)*40); axis('square', 'off');
% snakedisp(x,y,'r'); 
% title(['Final result,  iter = ' num2str(i*5)]);
% 
% 
% 
% 
% 
% 
