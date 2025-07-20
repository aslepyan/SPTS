%% load necessary random weight matrices and last saved progress
shape = "brain"; % change to the name of the object you want to measure support accuracy on, must be the same with folder names in Measurement_Collected

addpath("utilities/")
load("Random_Weights_Generation/A_rand2.mat") % generate random weights first!
load("Dictionary_learning/dictionary.mat")
load(append("Measurements_Collected/",shape,"/",shape,"_raster.mat"))
D = C;
load(append("Measurements_Collected/",shape,"/",shape,"_random2.mat"))
load(append("Measurements_Collected/",shape,"/",shape,"_random2_time.mat"))

%% parameters setting
OMP_sparsity = 20;
press_range = 6:15;
frame_range = 501:700;
A_randtype = A_rand2;

%% calculate support accuracy
d = D(:,600,10); % ground truth
Same_tot = zeros(1,100);
for press_no = press_range % iterate through touch events
    disp(press_no);
    Same_avg = zeros(1,100);
    for frame_no = frame_range % iterate through all frames of a touch event
        Same_list = zeros(1,100);
        for sample_count = 100:-1:1 % iterate through all measurements levels to reconstruct this frame
            if sample_count == 100
                A_rand_ID = framePosition(press_no) + frame_no - 1000; % find starting position of this frame
                A = A_randtype(:,:,A_rand_ID); % get the 100*100 random weights of this frame from the random lookup table
                y = C(:,frame_no,press_no); % get the 100 measurements with this starting position 
            else 
                A = A(1:sample_count,:); % truncate directly from the 100*100 weights list from the beginning 
                y = y(1:sample_count); % truncate directly from the 100 measurements list from the beginning
            end

            res = OMP(A*Dksvd,y,OMP_sparsity); % perform OMP
            x = Dksvd * res; % Dksvd is dictionary matrix
            
            [pctSame,pctDiff] = supportAccuracy(x,d); % calculate support accuracy 
            Same_list(sample_count) = pctSame; % save for each measurement level of this frame
        end
        Same_avg = Same_avg + Same_list; % combine across frames of this touch event
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