% List of all MAT-file (variable) names without '.mat' extension
fnames = {
    'brain_lib'
    'center_lib'
    'circle_lib'
    'comb_lib'
    'cornor_lib'
    'eraser_lib'
    'fish_lib'
    'gel_lib'
    'line_lib'
    'perfume_lib'
    'rectangle_lib'
    'smallT_lib'
    'T_lib'
    'tape_lib'
    'tennis_lib'
    'triangle_lib'
    'X_lib'
};

% Pre-allocate final array: 
% 100 rows, 17+1 groups (extra one for empty frame), each group has 10 columns => total 180 columns
final_array = zeros(100, 18 * 10);

for i = 1:length(fnames)
    % Current filename without extension
    library_name = fnames{i};
    
    % Load the .mat file (assumes it has a variable of the same name)
    S = load([library_name, '.mat']);
    
    % Extract the data from the structure,
    % e.g. for 'brain_lib.mat', the variable is 'brain_lib'
    data = S.(library_name);
    
    % data is size 100 x n. Let's find n:
    [numRows, numCols] = size(data);
    
    % Randomly select 10 columns out of the total available columns
    selectedCols = randperm(numCols, 10);
    selectedData = data(:, selectedCols);  % 100 x 10
    
    % Calculate where to place these 10 columns in final_array
    start_col = i * 10 + 1;
    end_col   = (i + 1) * 10;
    
    % Place the 100 x 10 block into the appropriate columns of final_array
    final_array(:, start_col:end_col) = selectedData;
end

% Now final_array is size 100 x 170
disp(size(final_array))

%%
for i = 1:180
    imagesc(reshape(final_array(:,i),10,10)',[-1,1]);
    pause()
end



