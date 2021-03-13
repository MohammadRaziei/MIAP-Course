function create_text(txt, pos, rot)
if nargin < 3, rot = 0; end
text(pos(1), pos(2),txt, 'Units', 'normalized', 'HorizontalAlignment', 'center', 'Rotation',rot)
end