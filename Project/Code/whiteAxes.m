function whiteAxes(ax)
if nargin < 1, ax = gca; end
if nargin < 1, ax = gca; end
set(ax, 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k')
set(ax,'color','w');
set(ax.Parent,'color','w');
end