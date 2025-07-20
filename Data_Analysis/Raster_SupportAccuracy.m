%% load necessary random weight matrices and last saved progress
addpath("utilities/")
shape = "brain"; % change to the name of the object you want to measure support accuracy on, must be the same with folder names in Measurement_Collected
load(append("Measurements_Collected/",shape,"/",shape,"_raster.mat"))

%% parameters setting
D = C; 
press_range = 3:12; %make sure there're 10 presses!!!!!
frame_range = 551:750; %ending frame number for each press

%% calculate SRC accuracy
Same_tot = zeros(1,100);
for press_no = press_range % iterate through touch events
    Same_avg = zeros(1,100);
    for frame_no = frame_range % iterate through all frames of a touch event
        d = D(:,frame_no,press_no); % ground truth
        Same_list = zeros(1,100);
        for sample_level = 3:100 %iterate through all measurements levels to reconstruct this press
            y = D(:,frame_no,press_no); %get the measurements with this starting position 
            x = downSample(y,sample_level); %reconstruct the touch signal as x
            
            %hold on
            %imagesc(reshape(x,10,10)',[-1,1]);
            [pctSame,pctDiff] = supportAccuracy(x,d); % calculate support accuracy 
            Same_list(sample_level) = pctSame; % save for each measurement level of this frame
        end
       Same_avg = Same_avg + Same_list;
    end
    Same_avg = Same_avg / 200; % average across frames of this touch event
    Same_tot = Same_tot + Same_avg; % combine across all touch events 
end
Same_tot = Same_tot / 10; % average across all touch events

plot(Same_tot)
%% save the accuracies into a file
total_res = [total_res;Same_tot];
mean_res = mean(total_res);
plot(mean_res);
ylim([50,100])

