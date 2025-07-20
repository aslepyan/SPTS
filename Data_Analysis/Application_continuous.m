%% load necessary random weight matrices and last saved progress
load("A_rand2.mat") % Binary Random Weights large lookup table
load("permuted_dictionary.mat") % OMP reconstruction dictionary
load("norm_src_library.mat") % SRC accuracy library
load("data/random2_tennis.mat") % application data

%% set parameters
framePosition = [1000,2000,2000,3000,3000,4000]; % Application data take per 1000 frames continuously
OMP_sparsity = 5; 
%press_no = 4;
frame_start = [599,70,574,50,546,453];
frame_end = [607,78,582,58,554,461];
% For Location Accuracy only
% location_accuracy = zeros(6,100);
% x_gt = 4;
% y_gt = 7;
%% recon
max_diff = zeros(1,100);
for sample_level = 25
    recon_total = floor(100*(frame_end(1)-frame_start(1)+1) / (sample_level));
    temp = zeros(6,recon_total);
    for press_no = 1:6
        A_rand_ID = framePosition(press_no) - 1000; % find starting position of this frame.
        A = A_rand2(:,:,A_rand_ID+frame_start(press_no):A_rand_ID+frame_end(press_no)); % get the all random weights of frames from frame_start to frame_end
        y = C(:,frame_start(press_no):frame_end(press_no),framePosition(press_no)/1000); % get the corresponding measurements of frames from frame_start to frame_end
        [A,y] = transpose_Ay(A,y,frame_end(press_no)-frame_start(press_no)+1); % reshape into long vertical matrices
        
        % reconstruction steps
        for recon_number = 1:recon_total
            recon_start = (recon_number-1)*sample_level+1;
            recon_end = recon_number*sample_level;
            res = OMP(A(recon_start:recon_end,:)*Dksvd_new,y(recon_start:recon_end),OMP_sparsity); % perform OMP
            x = Dksvd_new*res; % Dksvd is dictionary matrix
            x(x<-0.25) = 0; % eliminate below 0 values
            temp(press_no,recon_number) = max(x);
    
            % temp = [temp,centerOfMass(x,x_gt,y_gt)]; % For Location Accuracy Only
        end
    end
    avg = mean(temp);
    % max_diff(sample_level) = max(abs(diff(avg)));
    % location_accuracy(6,sample_level) = mean(temp); % For Location Accuracy Only
end

%%
for i = 606:1000
    imagesc(reshape(C(:,i,6),10,10)',[-1,1])
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
