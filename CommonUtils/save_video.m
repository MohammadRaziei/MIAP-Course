function save_video(video)
    if not(isempty(video.fig))
        frame = getframe(video.fig);
        writeVideo(video.stream, frame);
    end
end