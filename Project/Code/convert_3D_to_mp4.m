function convert_3D_to_mp4(img_pack, rate, save_to_filename, title_name, fnshow)
if nargin < 5, fnshow =@(im) imshow(im); end
video = video_make(save_to_filename,rate);
set(video.fig, 'Color', 0.1*ones(1,3))
for i = 1:size(img_pack, 3)
    pause(0.001); clf; 
    fnshow(rot90(img_pack(:,:,i)))
    title(title_name, 'Color', 'w')
    save_video(video);
end
close(video.stream);
close(video.fig)
end