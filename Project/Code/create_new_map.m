function out = create_new_map(unique_labels)
    C_color = colororder;
    C = @(ind) C_color(1 + mod(ind-1,size(C_color,1)),:);
    out = repmat(0.9,256,3);
    out(1,:) = zeros(1,3);
    for i = 2:length(unique_labels)
        out(unique_labels(i)+1,:) = C(i);
    end
end