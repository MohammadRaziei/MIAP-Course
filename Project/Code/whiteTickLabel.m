function out = whiteTickLabel(arr)
out = arrayfun(@(n)"\color[rgb]{1,1,1}"+string(n),arr,'UniformOutput',false);
end