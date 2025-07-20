%% load necessary random weight matrices and last saved progress
load("A_rand2.mat") % Binary Random Weights large lookup table
load("rbt_arm/random2.mat") % application data
load("rbt_arm/raster.mat") % application data
%% set parameters
framePosition = [1000,2000,3000,4000,5000,6000]; % Application data take per 1000 frames continuously
OMP_sparsity = 3; 

%% recon
E = [];
for sample_level = 25
    recon_total = floor(100*1000/sample_level);
    for press_no = 1:6
        x_press = [];
        A_rand_ID = framePosition(press_no) - 1000; % find starting position of this frame.
        A = A_rand2(:,:,A_rand_ID+1:A_rand_ID+1000); % get the all random weights of frames from frame_start to frame_end
        y = C(:,:,framePosition(press_no)/1000); % get the corresponding measurements of frames from frame_start to frame_end
        [A,y] = transpose_Ay(A,y,1000); % reshape into long vertical matrices
        
        % reconstruction steps
        for recon_number = 1:recon_total
            recon_start = (recon_number-1)*sample_level+1;
            recon_end = recon_number*sample_level;
            res = OMP(A(recon_start:recon_end,:),y(recon_start:recon_end),OMP_sparsity); % perform OMP
            x = res; % Dksvd is dictionary matrix
            x(x<-0.25) = 0; % eliminate below 0 values
            x_press = [x_press,x];
        end
        E = cat(3,E,x_press);
    end
end

%%
for i = 1:4000
    imagesc(reshape(E(:,i,6),10,10)',[-5,5])
    %sgtitle(sprintf("i = %d", i))
    pause(0.05)
    hold on
end
hold off

%%
for i = 1:1000
    imagesc(reshape(D(:,i,1),10,10)',[-2.2,1.8])
    %sgtitle(sprintf("i = %d", i))
    pause(0.2)
    hold on
end
hold off