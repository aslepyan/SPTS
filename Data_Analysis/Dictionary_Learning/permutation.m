load("dictionary.mat")
Dksvd_new = [];
for i = 1:50
    dict_entry = reshape(Dksvd(:,i),[10,10])';
    % Loop through possible row shifts (-3 to +3)
    for row_shift = -3:3
        for col_shift = -3:3
            % Create a new blank matrix
            new_matrix = zeros(10, 10);
            
            % Loop through each pixel in the original matrix
            for row = 1:10
                for col = 1:10
                    % Compute new position after shifting
                    new_row = row + row_shift;
                    new_col = col + col_shift;
                    
                    % Check if new position is inside valid bounds
                    if new_row >= 1 && new_row <= 10 && new_col >= 1 && new_col <= 10
                        new_matrix(new_row, new_col) = dict_entry(row,col);
                    end
                end
            end
            dict_column = reshape(new_matrix',[100,1]);
            Dksvd_new = [Dksvd_new,dict_column];
        end
    end
end



% Generate a random 100×2450 matrix (Example)
matrix_size = size(Dksvd_new);
% Initialize shuffled matrix
Dksvd_new_shuffled = zeros(matrix_size);

% Loop through each column and shuffle independently
for col = 1:matrix_size(2)
    Dksvd_new_shuffled(:, col) = Dksvd_new(randperm(matrix_size(1)), col);
end

% Display a before/after comparison of the first 10 columns for verification
disp('Original Matrix (First 10 columns):');
imagesc(Dksvd_new(1:10, 1:10));

disp('Shuffled Matrix (First 10 columns):');
imagesc(Dksvd_new_shuffled(1:10, 1:10));

save("permuted_dictionary.mat","Dksvd_new_shuffled")