function fig = create_figure(name, pos)
if nargin < 1 || isempty(name), name='figure'; end
if nargin < 2, pos=[0.2,0.2,0.6,0.6]; end
fig = figure('Color','white', 'ToolBar', 'none', 'MenuBar', 'none', 'Units', 'normalized','NumberTitle', 'off', ...
    'outerposition',pos, 'Name', name);
end