%% load necessary random weight matrices and last saved progress
shape = "brain"; % change to the name of the object you want to measure support accuracy on, must be the same with folder names in Measurement_Collected

addpath("utilities/")
load(append("Measurements_Collected/",shape,"/",shape,"_raster.mat"))
D = C;
load("Random_Weights_Generation/A_rand2.mat") % generate random weights first!

%% parameters setting
press_range = 6:15; %make sure there're 10 presses!!!!!
frame_range = 501:700; %ending frame number for each press
A_randtype = A_rand2;

%% calculate SRC accuracy
Same_tot = zeros(1,100);
for press_no = press_range % iterate through touch events
    disp(press_no);
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
    Same_avg = Same_avg / size(frame_range,2); % average across frames of this touch event
    Same_tot = Same_tot + Same_avg; % combine across all touch events 
end
Same_tot = Same_tot / size(press_range,2); % average across all touch events

%figure(1)
%plot(Same_tot)

%% save the accuracies into total_res. 
% Create a empty array called total_res before running this cell for the first time!
total_res = [total_res;Same_tot];
mean_res = mean(total_res);
plot(mean_res);

