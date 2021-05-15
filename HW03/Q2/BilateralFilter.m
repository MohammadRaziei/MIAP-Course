function image_filt = BilateralFilter(image, hx, hg)
    [M,N] = size(image);
    windowSize = ceil(3*hx);
    image_filt = zeros(M, N);
    tqdm = ProgressBar(M*N, 'Title', 'Bilateral Filtering');
    for row = 1:M
        for col = 1:N
            X = [row, col];
            neighbors = Examin_Neighbors(image, X, windowSize);
            sum_kernel = 0;
            sum_g_kernel = 0;
            for i = 1:size(neighbors, 1)
                Y = neighbors(i,:);
                Gx = image(X(1),X(2));
                Gy = image(Y(1),Y(2));
                kernel = Kernel(X, Y, Gx, Gy, hx, hg);
                sum_kernel = sum_kernel + kernel;
                sum_g_kernel = sum_g_kernel + kernel * Gy;
            end
            image_filt(row,col) = sum_g_kernel / sum_kernel;
            tqdm([], [], []);
        end
    end
    tqdm.release();
end
function out = Kernel(X,Y,Gx,Gy, hx, hg)
    out = exp(-0.5 * norm(X-Y)^2 / hx) * exp(-0.5 * norm(Gx-Gy)^2 / hg); 
end
function neighbors = Examin_Neighbors(image, X, halfWindowSize)
    [M,N] = size(image);
    x = X(1); y = X(2);
    neighbors = zeros(0,2);
    for i = (x-halfWindowSize):(x+halfWindowSize)
        if i < 1 || i > M || i == x, continue; end
        for j = (y-halfWindowSize):(y+halfWindowSize)
            if j < 1 || j > N || i == y, continue; end
            neighbors = [neighbors;[i,j]];
        end
    end
end

