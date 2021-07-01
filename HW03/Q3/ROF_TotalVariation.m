function u = ROF_TotalVariation(Image)
%%% parameters:
dt = 0.01; 
numIter = 100;
lambda = 10;
%%%
Image = double(Image);
[M, N] = size(Image); 
p = zeros(M,N,2);
d = zeros(M,N,2);
g = 1;
div_p = zeros(M,N);
for it = 1:numIter
    for x = 1:N
        for y = 2:M-1
            div_p(y,x) = p(y,x,1) - p(y-1,x,1);
        end
    end
    for x = 2:N-1
        for y = 1:M
            div_p(y,x) = div_p(y,x) + p(y,x,2) - p(y,x-1,2);
        end
    end
    
    %%% Handle boundaries
    div_p(:,1) = p(:,1,2);
    div_p(:,N) = -p(:,N-1,2);
    div_p(1,:) = p(1,:,1);
    div_p(M,:) = -p(M-1,:,1);
    %%% Update u
    u = Image-lambda*div_p;
    %%% Calculate forward derivatives
    du(:,:,2) = u(:,[2:N, N])-u;
    du(:,:,1) = u([2:M, M],:)-u;
    %%% Iterate
    d(:,:,1) = (1+(dt/lambda/g).*abs(sqrt(du(:,:,1).^2+du(:,:,2).^2)));
    d(:,:,2) = (1+(dt/lambda/g).*abs(sqrt(du(:,:,1).^2+du(:,:,2).^2)));
    p = (p-(dt/lambda).*du)./d;
    
end
end