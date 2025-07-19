seeds = 8:107; % initial seeds for lcg, for 100 pixels
frame_num = 100000; % generate this number of random weights
M = 2; % binary mode, used throughout this work

[A_rand2,A_rand2_seedHis] = amatrix(seeds, frame_num, M);
save("A_rand2.mat","A_rand2")