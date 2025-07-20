% This file plots reconstructed images of all 17 objects using 25, 50, 75 measurements
% versus a ground truth raster scan. 
%% load necessary random weight matrices
load("A_rand2.mat")
filename_list = ["brain","center","circle","comb","corner","eraser","fish","gel","line","perfume","rec","smallT","T","tape","tennis","trig","X"];
%% parameters setting %% calculate support accuracy
OMP_sparsity = 25;
press_range = 10;
frame_range = [550,475,450,752,410,  457,558,456,466,404,  483,572,603,601,553,  565,432];
graph_levels = [25,50,75];

low_lim = 16;
high_lim = 17;
for shape_no = low_lim:high_lim
    load(append("Final data/",filename_list(shape_no),"/",filename_list(shape_no),"_random2.mat"))
    load(append("Final data/",filename_list(shape_no),"/",filename_list(shape_no),"_random2_time.mat"))
    load(append("Processed Raster/",filename_list(shape_no),"_raster_processed.mat"))
    d = D(:,700,10)*1.5; % ground truth
    for press_no = press_range % iterate through touch events
        for frame_no = frame_range(shape_no) % iterate through all frames of a touch event
            for sample_no = 1:size(graph_levels,2) % iterate through all measurements levels to reconstruct this frame
                sample_count = graph_levels(sample_no);
                A_rand_ID = framePosition(press_no) + frame_no - 1000; % find starting position of this frame
                A = A_rand2(1:sample_count,:,A_rand_ID); % get the 100*100 random weights of this frame from the random lookup table
                y = C(1:sample_count,frame_no,press_no); % get the 100 measurements with this starting position 
    
                res = OMP(A*Dksvd,y,OMP_sparsity); % perform OMP
                x = Dksvd * res; % Dksvd is dictionary matrix
                %[pctSame,pctDiff] = SupportAccuracy(x,d); % calculate support accuracy 
                figure(1)
                subplot_idx = (shape_no-low_lim)*(size(graph_levels,2)+1)+sample_no;
                subplot(5,size(graph_levels,2)+1,subplot_idx) % Arrange plots in a 2×2 grid

                x(x<-0.1) = 0;
                imagesc(reshape(x,10,10)', [-1,1]); % Reshape and visualize
                %title(['Samples: ', num2str(sample_count)]);
                axis off; 
            end
        end
    end
    figure(1)
    subplot_idx = (shape_no-low_lim)*(size(graph_levels,2)+1)+4;
    subplot(5,size(graph_levels,2)+1,subplot_idx) % Arrange plots in a 2×2 grid
    imagesc(reshape(d,10,10)', [-1,1]); % Reshape and visualize
    %title(['Samples: ', num2str(sample_count)]);
    axis off; 
end

%% save the accuracies into a file
load(append("Processed Raster/",filename_list(2),"_raster_processed.mat"))
d = D(:,600,10); % ground truth
figure(2)
imagesc(reshape(d,10,10)',[-1,1])
%% backup measurement result frame by frame visualizer
for i = 1:1000
    imagesc(reshape(C(:,i,14),10,10)',[-1,1])
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
