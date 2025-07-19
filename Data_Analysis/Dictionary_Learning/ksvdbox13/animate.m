function [] = animate(time, scale, varargin)
% time = time delay between frames
% varargin = video1,video2,video3,...
%           each video is R x C x T in dimension

numvids = length(varargin);

video = varargin{1};
sz = size(video);
if length(sz)==3
    t = length(video(1,1,:));
end
if length(sz)==2
    t = length(video(1,:));
end

close all

for i = 1:t
    for j=1:numvids
        subplot(numvids,1,j)
        video = varargin{j};
        
        sz = size(video);
        if length(sz)==2
            img = reshape(video(:,i),[sqrt(sz(1)) sqrt(sz(1))]);
            img = squeeze(img);
        end
        if length(sz)==3
            img = squeeze(video(:,:,i));
        end
        if scale == 1
            imagesc(img)
        end
        if scale == 0
            image(img)
        end
        title(i)
        drawnow
        pause(time)
end
end