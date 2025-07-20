function [A_new,y_new] = transpose_Ay(A,y,z_size)
    A_new = permute(A, [1, 3, 2]); 
    A_new = reshape(A_new, [100*z_size, 100]);
    y_new = permute(y, [1, 3, 2]); 
    y_new = reshape(y_new, [100*z_size, 1]);
end