function colorAxes(ax,color)
if nargin < 1, ax = gca; end
if nargin < 2, color = ones(1,3); end
colorComp = 1-color;
set(ax, 'XColor', colorComp, 'YColor', colorComp, 'ZColor', colorComp)
set(ax,'color',color);
set(ax.Parent,'color',color);
end