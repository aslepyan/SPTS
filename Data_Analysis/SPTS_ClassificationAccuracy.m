%% load necessary random weight matrices and measurements
shape = "brain"; % change to the name of the object you want to measure support accuracy on, must be the same with folder names in Measurement_Collected
true_label = 1; %change for each object! label for each object is their place among all 17 in alphabetical order. 

addpath("utilities/")
load("Random_Weights_Generation/A_rand2.mat") % generate random weights first!
load("Dictionary_learning/dictionary.mat")
load("SRC_Library/SRC_lib.mat")
load(append("Measurements_Collected/",shape,"/",shape,"_random2.mat"))
load(append("Measurements_Collected/",shape,"/",shape,"_random2_time.mat"))

%% parameters setting
OMP_sparsity = 20;
press_range = 6:7; 
frame_start = 501; %starting frame number for each press
frame_end = 700; %ending frame number for each press
vote_period = 20; %vote for every 20 reconstructions. Vote among all past reconstruction classifications of this press. 
A_randtype = A_rand2;

%% calculate SRC accuracy
total_acc = zeros(1,100); %storage array for SRC across all 10 presses
for press_no = press_range % iterate through touch events
    disp(press_no);
    press_acc = zeros(1,100); %storage array for src for each press (averaged into total_acc)
    A_rand_ID = framePosition(press_no) - 1000; %find starting position of this frame
    A = A_randtype(:,:,A_rand_ID+frame_start:A_rand_ID+frame_end); % get the all random weights of this frame from the random lookup table
    y = C(:,frame_start:frame_end,press_no); %get the measurements with this starting position 
    [A,y] = transpose_Ay(A,y,frame_end-frame_start+1); %transpose and stitch together all frames into one continuous A matrix/ y array

    for sample_level = 1:100 %iterate through all measurements levels to reconstruct this press
        vote_total = floor(100*(frame_end-frame_start+1) / (vote_period*sample_level)); %determine how many votes will be recorded
        if vote_total > 200; vote_total = 200; end %hard limit max number of votes to 200. 
        recon_total = vote_total * vote_period; %determine how many reconstructions needed to reconstruct from frame_start to frame_end
        group_classification = []; %temporary storage array for all the reconstruction classification labels within each press
        
        for recon_number = 1:recon_total %reconstruct and classify and vote cycle from frame_start to frame_end
            recon_start = (recon_number-1)*sample_level+1;
            recon_end = recon_number*sample_level;
            res = OMP(A(recon_start:recon_end,:)*Dksvd,y(recon_start:recon_end),OMP_sparsity); %perform OMP
            x = Dksvd * res; %reconstruct the touch signal as x
            classification = SRCAccuracy(x, lib_new, true_label); %calculate SRC classification result label
            group_classification = [group_classification, classification]; %save the label for each reconstruction 

            if mod(recon_number, vote_period) == 0 %vote every 20 reconstructions
                group_vote = mode(group_classification); %find the mode of all previously classified labels across frame of this press
                press_acc(sample_level) = press_acc(sample_level) + (group_vote == true_label); %save result (1 or 0) to press_acc, in corresponding sample level)
                %group_classification = [];
            end
        end
        press_acc(sample_level) = press_acc(sample_level) / vote_total; %average SRC accuracy for each press
    end
    total_acc = total_acc + press_acc; % combine across all presses
end
total_acc = total_acc / size(press_range,2); % average across all presses

%figure(1)
%plot(total_acc)

%% save the accuracies into total_res. 
% Create a empty array called total_res before running this cell for the first time!
total_res = [total_res;total_acc];
mean_res = mean(total_res);
plot(mean_res);