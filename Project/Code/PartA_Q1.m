clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results');
data_dir = '../data/';
%%
C_color = colororder;
C = @(ind) C_color(1 + mod(ind-1,size(C_color,1)),:);
for subject_num = 1:21
% subject_num = 10;
    img_pack_label = double(niftiread(fullfile(data_dir, sprintf('S%02.0f/pat%.0f_label.nii', subject_num, subject_num))));
    img_pack = double(niftiread(fullfile(data_dir, sprintf('S%02.0f/pat%.0f.nii', subject_num, subject_num))));
    max_img = max(img_pack(:));
    img_pack = img_pack / max_img;
    save_to_filename = sprintf('results/partA_Q1-S%02.0f', subject_num);
    title_text = sprintf('subject: %.0f', subject_num);
    img_unique_labels = unique(img_pack_label);
    newmap = create_new_map(img_unique_labels);
    newmap(1,:)=1*ones(1,3);
    
    video = video_make(save_to_filename,25);
    set(video.fig, 'Color', 0.1*ones(1,3))
    for i = 1:size(img_pack, 3)
        pause(0.001); clf; 
        subplot(121); imshow(rot90(img_pack(:,:,i)));
        title([title_text, ' (raw)'], 'Color', 'w')
        subplot(122); imshow(uint8(rot90(img_pack_label(:,:,i))), 'Colormap', newmap); 
        colorbar(...
                'ylim', [img_unique_labels(2) img_unique_labels(end)+1]-0.1, ...
                'XTick',0.4+(img_unique_labels(2):img_unique_labels(end)+1),...
                'XTickLabel',whiteTickLabel(img_unique_labels(2):img_unique_labels(end)+1));
        title([title_text, ' (label)'], 'Color', 'w')
        save_video(video);
    end
    close(video.stream);
    close(video.fig)

end

