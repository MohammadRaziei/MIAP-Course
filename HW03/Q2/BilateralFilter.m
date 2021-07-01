function image_filt = BilateralFilter(image, hx, hg)
[M,N] = size(image);
halfWindowSize = ceil(3*hx);
image_filt = zeros(M, N);
tqdm = ProgressBar(M*N, 'Title', 'Bilateral Filtering');
for row = 1:M
    for col = 1:N
        X = [row, col];
        sum_kernel = 0;
        sum_g_kernel = 0;
        % Loop for neighbors:
        for i = (X(1)-halfWindowSize):(X(1)+halfWindowSize)
            if i < 1 || i > M || i == X(1), continue; end
            for j = (X(2)-halfWindowSize):(X(2)+halfWindowSize)
                if j < 1 || j > N || i == X(2), continue; end
                Y = [i,j]; % Y: neighbors
                Gx = image(X(1),X(2));
                Gy = image(Y(1),Y(2));
                kernel = Kernel(X, Y, Gx, Gy, hx, hg);
                sum_kernel = sum_kernel + kernel;
                sum_g_kernel = sum_g_kernel + kernel * Gy;
            end
        end
        image_filt(row,col) = sum_g_kernel / sum_kernel;
        tqdm([], [], []);
    end
end
tqdm.release();
end
function out = Kernel(X,Y,Gx,Gy, hx, hg)
out = exp(-0.5 * norm(X-Y)^2 / hx^2) * exp(-0.5 * norm(Gx-Gy)^2 / hg^2);
end


