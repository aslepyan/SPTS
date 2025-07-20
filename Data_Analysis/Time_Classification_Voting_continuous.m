%% load necessary random weight matrices and last saved progress
load("A_rand2.mat") % Binary Random Weights large lookup table
load("Dictionary.mat") % OMP reconstruction dictionary
load("norm_src_library.mat") % SRC accuracy library
% set parameters
OMP_sparsity = 5;
press_range = 4:13; %make sure there're 10 presses!!!!!
frame_range = 100;
A_randtype = A_rand2;
frame_start_list = [220,305,345,140,295,300,195,155,295,285,280,195,220,355,195,280,285];
fileList = [
    "Final data/brain/brain_random2"
    "Final data/center/center_random2"
    "Final data/circle/circle_random2"
    "Final data/comb/comb_random2"
    "Final data/corner/corner_random2"
    "Final data/eraser/eraser_random2"
    "Final data/fish/fish_random2"
    "Final data/gel/gel_random2"
    "Final data/line/line_random2"
    "Final data/perfume/perfume_random2"
    "Final data/rec/rec_random2"
    "Final data/smallT/smallT_random2"
    "Final data/T/T_random2"
    "Final data/tape/tape_random2"
    "Final data/tennis/tennis_random2"
    "Final data/trig/trig_random2"
    "Final data/X/X_random2"
];

%% calculate SRC accuracy
Time_SRC_accuracy = cell(100,3); % storage cell array for results

for sample_level = [25,50,75,100] % iterate through all measurements levels to reconstruct this frame
    recon_total = floor(100*frame_range/sample_level);

    for object_ID = [1:13,15:17] % iterate through objects
        disp(object_ID);
        true_label = object_ID;
        load(sprintf("%s%s", fileList(object_ID),".mat"))
        load(sprintf("%s%s", fileList(object_ID),"_time.mat"))
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
                res = OMP(A(recon_start:recon_end,:)*norm_src_library,y(recon_start:recon_end),OMP_sparsity); % perform OMP
                x = norm_src_library * res; % Dksvd is dictionary matrix                
                classification = SRCAccuracy(x, norm_src_library, true_label); % calculate support accuracy 
                group_classification = [group_classification, classification]; % save for each measurement level of this frame
                group_vote = mode(group_classification); % combine across frames of this touch event
                press_time_accuracy = [press_time_accuracy, (group_vote == true_label)];
            end
            obj_time_accuracy = obj_time_accuracy + press_time_accuracy;
        end
        obj_time_accuracy = obj_time_accuracy / 10;
        if isempty(Time_SRC_accuracy{sample_level,3})
            Time_SRC_accuracy{sample_level,3} = obj_time_accuracy;
        else
            Time_SRC_accuracy{sample_level,3} = Time_SRC_accuracy{sample_level,3} + obj_time_accuracy;
        end
    end
end

figure()
hold on
for sample_level = [25,50,75,100]
    stairs((0:sample_level:1000)/60000,[0,Time_SRC_accuracy{sample_level,3}/16])
end
set(gca, 'XScale', 'log');
legend(["25","50","75","100"])
ylim([0,1])

%% backup measurement result frame by frame visualizer
fileList = [
    "Final data/brain/brain_random2";    "Final data/center/center_random2";    "Final data/circle/circle_random2"
    "Final data/comb/comb_random2";    "Final data/corner/corner_random2";    "Final data/eraser/eraser_random2"
    "Final data/fish/fish_random2";    "Final data/gel/gel_random2";    "Final data/line/line_random2"
    "Final data/perfume/perfume_random2";    "Final data/rec/rec_random2";    "Final data/smallT/smallT_random2"
    "Final data/T/T_random2";    "Final data/tape/tape_random2";    "Final data/tennis/tennis_random2"
    "Final data/trig/trig_random2";    "Final data/X/X_random2"
];
load(sprintf("%s%s", fileList(5),".mat"))
load(sprintf("%s%s", fileList(5),"_time.mat"))
%%
for i = 1:1000
    imagesc(reshape(C(:,i,1),10,10)',[-1,1])
    sgtitle(sprintf("i = %d", i))
    pause()
    hold on
end
hold off
%% 
hold on
idx = [4:13];
for i = 1:1000
    for j = 1:4
        subplot(2,2,j)
        imagesc(reshape(C(:,i,idx(j)),10,10)',[-1,1])
        title(sprintf("idx = %d", idx(j)))
    end
    sgtitle(sprintf("i = %d", i))
    pause()
end
hold off
