function image_filt = TotalVariation(image)
%%% Parameters:
dt = 0.01; 
numIter = 10;
lambda = 10;
Eps = 1e-4;
%%%
[M,N] = size(image);
%%% Functions:
m = @(dp,dn) 0.5*(sign(dp)+sign(dn))*min(abs(dp), abs(dn));
Dpx = @(u, x1,x2) u(min(x1+1,M), max(x2,1)) - u(max(x1,1),max(x2,1));
Dpy = @(u, x1,x2) u(max(x1,1), min(x2+1,N)) - u(max(x1,1),max(x2,1));
Dnx = @(u, x1,x2) u(max(x1,1), max(x2,1)) - u(max(x1-1,1),max(x2,1));
Dny = @(u, x1,x2) u(max(x1,1), max(x2,1)) - u(max(x1,1),max(x2-1,1));

f = image;
u = f; 
u_new = f; 
tqdm = ProgressBar(numIter, 'Title', 'Total Variation Filtering');
% fig = create_figure;
for t = 1:numIter
    for i = 1:M-1
        for j = 1:N-1
            g = +Dnx(u,i,j)/(Eps+hypot(Dnx(u,i,j),m(Dpy(u,i,j),Dny(u,i,j))))...
                -Dnx(u,i-1,j)/(Eps+hypot(Dnx(u,i-1,j),m(Dpy(u,i-1,j),Dny(u,i-1,j))))...
                +Dpy(u,i,j)/(Eps+hypot(Dny(u,i,j),m(Dpx(u,i,j),Dnx(u,i,j))))...
                -Dpy(u,i,j-1)/(Eps+hypot(Dny(u,i,j-1),m(Dpx(u,i,j-1),Dnx(u,i,j-1))));
            u_new(i,j) = u(i,j) + dt * g + lambda*dt*(f(i,j)-u(i,j));
        end
    end
    u = u_new;
    tqdm([],[],[]);
%     clf; imshowpair(image,u,'montage')
end
image_filt = u;
tqdm.release();
end