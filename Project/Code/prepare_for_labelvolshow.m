function [compareC, cmap] = prepare_for_labelvolshow(fixed, movingReg)
fixedC = logical(fixed)*4;
movingRegC = logical(movingReg)*6;
color_fixed = [0,1,0];
color_movingReg = [1,0,0];
compareC = 0.5 * fixedC + 0.5 * movingRegC;
compareC_unique = unique(compareC);
cmap = zeros(6,3); cmap(1,:) = [0 0 1];% dummy
cmap(3,:) = color_fixed; cmap(4,:) = color_movingReg; cmap(6,:) = 0.5*color_movingReg + 0.5 * color_fixed;
cmap = cmap(compareC_unique+1,:);
end