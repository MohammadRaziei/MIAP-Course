function [common_labels, moving] = fix_labels(subject_num, fixed_labels, moving_labels, moving)
switch subject_num
    case {561, 631}
        common_labels = intersect(fixed_labels, moving_labels);
        moving = bsxfun(@times, double(ismember(moving, common_labels)), moving); 
    case {593, 605}
        moving = moving - 1; moving_labels = moving_labels - 1;
        common_labels = intersect(fixed_labels, moving_labels);
        moving = bsxfun(@times, double(ismember(moving, common_labels)), moving); 
    otherwise
        error('this file is not represented');
end

end



