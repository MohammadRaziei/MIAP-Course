function output_image = butterworthlpf(input_image)
% Saving the size of the input_image in pixels-
% M : no of rows (height of the image)
% N : no of columns (width of the image)
[M, N] = size(input_image);
  
% Getting Fourier Transform of the input_image
% using MATLAB library function fft2 (2D fast fourier transform)
FT_img = fft2(double(input_image));
  
% Assign the order value
n = 2; % one can change this value accordingly
  
% Assign Cut-off Frequency
D0 = 20; % one can change this value accordingly
  
% Designing filter
u = 0:(M-1);
v = 0:(N-1);
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;
  
% MATLAB library function meshgrid(v, u) returns 
% 2D grid which contains the coordinates of vectors 
% v and u. Matrix V with each row is a copy of v 
% and matrix U with each column is a copy of u 
[V, U] = meshgrid(v, u);
  
% Calculating Euclidean Distance
D = sqrt(U.^2 + V.^2);
  
% determining the filtering mask
H = 1./(1 + (D./D0).^(2*n));
  
% Convolution between the Fourier Transformed 
% image and the mask
G = H.*FT_img;
  
% Getting the resultant image by Inverse Fourier Transform 
% of the convoluted image using MATLAB library function  
% ifft2 (2D inverse fast fourier transform)   
output_image = real(ifft2(double(G))); 
   
end