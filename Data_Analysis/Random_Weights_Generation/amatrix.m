function [A,seedHis] = amatrix(seeds, frame_num, M)
% Constructs the A matrix (voltage weights) for the OMP function.
% Each row represents one measurement, and each column represents one
% sensor. Note that sensor mode 1 is never used in the actual result.

% Inputs:
% seeds : row vector containing all the initial seeds for sensors (#cols).
% type: uint32 array

% num_iterations: number or measurements used for reconstruction (#rows).
% type: double

% M: dummy variable for sensor mode. 1 if 0-255, 2 if binary.
% type: double

% Outputs:
% res_matrix: the resulting #measurements * #sensors input matrix for OMP.
% type: double array

% seedHis: last row of generated weights
% type: uint32 array

% Rudy Zhang, 9/7/2024
    A = zeros(100,100,frame_num);
    num_seeds = numel(seeds);
    num_iterations =100;
    for j = 1:frame_num
        res_matrix = zeros(num_iterations,num_seeds); %construct empty A matrix
        for i = 1:100
            seeds = lcgRandom(seeds); %constructs one row of new seeds
            if(M == 1) %conform to 0-255 if SPTS mode
                res_matrix(i,:) = floorDiv(seeds,16777216);
            elseif(M == 2) %conform to binary if SPTS mode
                res_matrix(i,:) = floorDiv(seeds,16777216) >= 128;
            end
        end
        A(:,:,j) = res_matrix;
    end
    seedHis = seeds;
end
