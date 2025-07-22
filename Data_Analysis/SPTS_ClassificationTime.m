%% load necessary random weight matrices and measurements
addpath("utilities/")
load("Random_Weights_Generation/A_rand2.mat") % generate random weights first!
load("Dictionary_learning/dictionary.mat")
load("SRC_Library/SRC_lib.mat")
filename_list = ["brain","center","circle","comb","corner","eraser","fish","gel","line","perfume","rec","smallT","T","tape","tennis","trig","X"];

%% set parameters
OMP_sparsity = 5;
press_range = 4:13; %make sure there're 10 presses!!!!!
frame_range = 100;
A_randtype = A_rand2;
frame_start_list = [220,305,345,140,295,300,195,155,295,285,280,195,220,355,195,280,285];

%% calculate SRC accuracy
Time_SRC_accuracy = cell(100,3); % storage cell array for results

for sample_level = [25,50,75,100] % iterate through all measurements levels to reconstruct this frame
    recon_total = floor(100*frame_range/sample_level);

    for object_ID = [1:13,15:17] % iterate through objects
        disp(object_ID);
        true_label = object_ID;
        shape = filename_list(object_ID);
        load(append("Measurements_Collected/",shape,"/",shape,"_random2.mat"))
        load(append("Measurements_Collected/",shape,"/",shape,"_random2_time.mat"))
        obj_time_accuracy = zeros(1,recon_total);

        for press_no = 4:13 % iterate through touch events of each object
            press_time_accuracy = [];
            frame_start = frame_start_list(object_ID) + 100;
            frame_end = frame_start + frame_range;
            A_rand_ID = framePosition(press_no) - 1000; % find starting position of this frame.
            A = A_randtype(:,:,A_rand_ID+frame_start:A_rand_ID+frame_end); % get the all random weights of this frame from the random lookup table
            y = C(:,frame_start:frame_end,press_no); % get the 100 measurements with this starting position 
            [A,y] = transpose_Ay(A,y,frame_end-frame_start+1);

            group_classification = [];
            for recon_number = 1:recon_total
                recon_start = (recon_number-1)*sample_level+1;
                recon_end = recon_number*sample_level;
                res = OMP(A(recon_start:recon_end,:)*Dksvd,y(recon_start:recon_end),OMP_sparsity); % perform OMP
                x = Dksvd * res; % Dksvd is dictionary matrix                
                classification = SRCAccuracy(x, lib_new, true_label); % calculate support accuracy 
                group_classification = [group_classification, classification]; % save for each measurement level of this frame
                group_vote = mode(group_classification); % combine across frames of this touch event
                press_time_accuracy = [press_time_accuracy, (group_vote == true_label)]; % append each newly obtained accuracy data to the end of the whole accuracy v. time array of each press
            end
            obj_time_accuracy = obj_time_accuracy + press_time_accuracy; % add across all presses of the same object
        end
        obj_time_accuracy = obj_time_accuracy / size(press_range,2); % take average for each timestamp's accuracy of each obejct
        if isempty(Time_SRC_accuracy{sample_level,3})
            Time_SRC_accuracy{sample_level,3} = obj_time_accuracy;
        else
            Time_SRC_accuracy{sample_level,3} = Time_SRC_accuracy{sample_level,3} + obj_time_accuracy;
        end
    end
end

%% graphing SRC Accuracy v. Tine for different measurement levels
figure()
hold on
for sample_level = [25,50,75,100]
    stairs((0:sample_level:1000)/60000,[0,Time_SRC_accuracy{sample_level,3}/16])
end
set(gca, 'XScale', 'log');
legend(["25","50","75","100"])
ylim([0,1])
