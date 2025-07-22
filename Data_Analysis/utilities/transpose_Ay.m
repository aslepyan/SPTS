function [A_new,y_new] = transpose_Ay(A,y,z_size)
% transposes 3d A and y arrays into 2d array by piecing each frame in z
% direction to the end of its predecessor.

% Inputs:
% A : original 3d matrix for random weights (multiple 100*100 weight arrays
% stacked in z direction)
% y : original 2d matrix for measurements (multiple 100 pixel columns
% stacked in y direction)
% z_size: number of frames inside the z direction for A and y
%
% Outputs:
% A : new 2d matrix for random weights (one array that is long in vertical
% direction)
% y : new 1d matrix for measurements (one long column)
    A_new = permute(A, [1, 3, 2]); 
    A_new = reshape(A_new, [100*z_size, 100]);
    y_new = permute(y, [1, 3, 2]); 
    y_new = reshape(y_new, [100*z_size, 1]);
end