clc; close all; clear all;
addpath('../../CommonUtils')
create_folder('results/nifti2mp4');
%%
for subject_num = 1:21
% subject_num = 10;
    [seg3D,raw3D] = readData('subject', subject_num, true); 
    save_to_filename = sprintf('results/nifti2mp4/partA1-S%02.0f', subject_num);
    title_text = sprintf('subject: %.0f', subject_num);
    img_labels = unique(seg3D);
    newmap = create_new_map(img_labels);
    newmap(1,:) = 0.8*ones(1,3);
    
    
    video = video_make(save_to_filename,25, [0 0 1 1]);
    set(video.fig, 'Color', 0.1*ones(1,3))
    for i = 1:size(raw3D, 3)
        pause(0.001); clf; 
        seg2D = seg3D(:,:,i);
        alpha = 0.5*logical(seg2D);
        seg2D = reshape(newmap(seg2D+1,:), [size(seg2D) 3]);
        raw2D = raw3D(:,:,i);
        img = (1-alpha).*(raw2D)+(alpha).*seg2D;
        subplot(131); imshow(rot90(raw2D)); 
        title([title_text, ' (raw)'], 'Color', 'w')
        subplot(132); imshow(uint8(rot90(seg3D(:,:,i))), 'Colormap', newmap); 
        colorbar('ylim', [img_labels(2) img_labels(end)+1]-0.1, ...
                'XTick',0.4+(img_labels(2):img_labels(end)+1),...
                'XTickLabel',whiteTickLabel(img_labels(2):img_labels(end)+1));
        title([title_text, ' (label)'], 'Color', 'w')
        subplot(133); imshow(rot90(img)); 
        title([title_text, ' (raw+label)'], 'Color', 'w')
        save_video(video);
    end
    close(video.stream);
    close(video.fig)

end

