%% parameters setting
press_range = 3:12; %make sure there're 10 presses!!!!!
frame_range = 551:750; %ending frame number for each press
% calculate SRC accuracy
Same_tot = zeros(1,100);
for press_no = press_range % iterate through touch events
    Same_avg = zeros(1,100);
    for frame_no = frame_range % iterate through all frames of a touch event
        d = D(:,frame_no,press_no); % ground truth
        Same_list = zeros(1,100);
        for sample_level = 3:100 %iterate through all measurements levels to reconstruct this press
            y = D(:,frame_no,press_no); %get the measurements with this starting position 
            x = downsample(y,sample_level); %reconstruct the touch signal as x
            x(x<0) = 0;
            x(x>1) = 1;
            %hold on
            %imagesc(reshape(x,10,10)',[-1,1]);
            Error = mean_squared_error(x,d); % calculate support accuracy 
            Same_list(sample_level) = Error; % save for each measurement level of this frame
        end
       Same_avg = Same_avg + Same_list;
    end
    Same_avg = Same_avg / size(frame_range,2); % average across frames of this touch event
    Same_tot = Same_tot + Same_avg; % combine across all touch events 
end
Same_tot = Same_tot / size(press_range,2); % average across all touch events

figure(1)
plot(Same_tot)
%% save the accuracies into a file
total_res_R = [total_res_R;Same_tot];
mean_res_R = mean(total_res_R);
plot(3:100,mean_res_R(3:100));

%% backup measurement result frame by frame visualizer
for i = 700
    imagesc(reshape(D(:,i,10),10,10)',[-1,1])
    sgtitle(sprintf("i = %d", i))
    pause(eps)
    hold on
end
hold off
%% back up ground truth picker visualizer
figure(2)
d = D(:,600,10);
maxRaster = max(d);
d(d<0.23*maxRaster) = 0;
d(d>0.23*maxRaster) = 1;
imagesc(reshape(d,10,10)',[-1,1]);
%%
x = 1:100;
[p,S] = polyfit(1:100,mean_res,4);
[y_fit,delta] = polyval(p,x,S);
plot(x,y_fit,'-')
%plot(x,y_fit+2*delta,'m--',x,y_fit-2*delta,'m--')
