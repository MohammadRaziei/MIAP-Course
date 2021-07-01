function merge_videos(srcName1, srcName2, dstName)

vid1 = VideoReader(srcName1);
vid2 = VideoReader(srcName2);

videoPlayer = vision.VideoPlayer;

% new video
outputVideo = VideoWriter(dstName,'MPEG-4');
outputVideo.FrameRate = vid1.FrameRate;
open(outputVideo);

while hasFrame(vid1) && hasFrame(vid2)
    img1 = readFrame(vid1);
    img2 = readFrame(vid2);

    imgt = horzcat(img1, img2);

    % play video
    step(videoPlayer, imgt);

    % record new video
    writeVideo(outputVideo, imgt);
end

release(videoPlayer);
close(outputVideo);