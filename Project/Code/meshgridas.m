function [X,Y,Z] = meshgridas(V)
[xs,ys,zs] = size(V);
[X,Y,Z]=meshgrid(1:ys,1:xs, 1:zs);
end