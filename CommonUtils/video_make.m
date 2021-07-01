function video = video_make(name,frameRate,pos)
    if nargin < 3, pos = []; end
    video.name = name;
    try close(video.stream); close(video.fig); catch,end
    if isempty(pos)
        video.fig = figure('Color','w','ToolBar','none','MenuBar','none');
    else
        video.fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',pos);
    end
    video.stream = VideoWriter(video.name,'MPEG-4'); %open video file
    video.stream.FrameRate = frameRate;  
    try close(video.stream); catch,end
    open(video.stream)
end