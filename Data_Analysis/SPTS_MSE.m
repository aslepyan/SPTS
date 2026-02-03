%% load necessary random weight matrices and last saved progress
load("A_rand1.mat")
load("A_rand2.mat")
load("Dictionary.mat")

%% parameters setting
OMP_sparsity = 20;
press_range = 5:14;
frame_range = 501:700;
A_randtype = A_rand2;
if A_randtype == A_rand1 res_scale = 255; else res_scale = 1; end
% calculate support accuracy
d = D(:,600,10); % ground truth
Same_tot = zeros(1,100);
for press_no = press_range % iterate through touch events
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
            res = OMP(A*Dksvd,y,OMP_sparsity) * res_scale; % perform OMP
            x = Dksvd * res; % Dksvd is dictionary matrix
            %pause(0.001);
            %hold on
            %imagesc(reshape(x,10,10)',[-1,1])
            %title(sample_count)

            x = x/2; % cause reconstrcuted frames tend to have 2x intensity than rasters
            x(x<0) = 0; % eliminate negative pixels
            x(x>1) = 1; % eliminate extreme pixels
            Error = mean_squared_error(x,d); % calculate support accuracy 
            Same_list(sample_count) = Error; % save for each measurement level of this frame
        end
        Same_avg = Same_avg + Same_list; % combine across frames of this touch event
    end
    Same_avg = Same_avg / size(frame_range,2); % average across frames of this touch event
    Same_tot = Same_tot + Same_avg; % combine across all touch events 
end
Same_tot = Same_tot / size(press_range,2); % average across all touch events

figure(1)
plot(Same_tot)
%% save the accuracies into a file
total_res_S = [total_res_S;Same_tot];
mean_res_S = mean(total_res_S);
plot(mean_res_S);

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
%maxRaster = max(d);
%d(d<0.23*maxRaster) = 0;
%d(d>0.23*maxRaster) = 1;
imagesc(reshape(d,10,10)',[-1,1]);
