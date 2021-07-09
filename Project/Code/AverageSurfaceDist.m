function asd = AverageSurfaceDist(P,Q)
% Calculates the Average Surface Distance between P and Q
%
% hd = HausdorffDist(P,Q)
% [hd D] = HausdorffDist(P,Q)
%
% Calculates the Average Surface Distance, hd, between two sets of points, P and
% Q (which could be two trajectories). Sets P and Q must be matrices with
% an equal number of columns (dimensions), though not necessarily an equal
% number of rows (observations).
%
% D is the matrix of distances where D(n,m) is the distance of the nth
% point in P from the mth point in Q.
%
if isa(P, 'pointCloud'), P = P.Location; end
if isa(Q, 'pointCloud'), Q = Q.Location; end
sP = size(P); sQ = size(Q);
if ~(sP(2)==sQ(2))
    error('Inputs P and Q must have the same number of columns')
end

    % we cannot save all distances, so loop through every point saving only
    % those that are the best value so far
    sumP = 0;           % initialize our max value
    % loop through all points in P looking for maxes
    for p = 1:sP(1)
        % calculate the minimum distance from points in P to Q
        minP = min(sum( bsxfun(@minus,P(p,:),Q).^2, 2));
        % we've discovered a new largest minimum for P
        sumP = sumP + sqrt(minP);
    end
    % repeat for points in Q
    sumQ = 0;
    for q = 1:sQ(1)
        minQ = min(sum( bsxfun(@minus,Q(q,:),P).^2, 2));
        sumQ = sumQ + sqrt(minQ);
    end
    
    asd = (sumP+sumQ)/(sP(1)+sQ(1));
end

