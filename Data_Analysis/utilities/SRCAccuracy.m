function classification = SRCAccuracy(x, src_library, true_label)

% Perform OMP to find the x_hat matrix that sparsly represents the input 
% tactile signal x using the library. The classification result is
% determined by finding the class within the library whose representation
% of x has the minimum l2 difference with the actual x signal. 

% Inputs:
% x : tactile signal (100 pixels) to be classified
% src_library : library of raster scanned objects
% true_label: ground truth
%
% Outputs:
% classification: resulting class label

    class_weights = OMP(src_library,x,10); % perform OMP to find the weights for each object
    
    %calculate the residual 
    % Define the group size and number of groups
    group_size = 10;
    [~,num_groups] = size(src_library);
    num_groups = num_groups/10;
    
    % Preallocate array to store norms
    difference_l2 = zeros(num_groups,1);
    %imagesc(reshape(x,10,10)',[-1,1])
    for i = 1:num_groups
        % Indices for the current group of 10
        start_idx = (i-1)*group_size + 1;
        end_idx   = i*group_size;
        
        % Create a zero vector of the same size as class_weights
        class_weights_zeros = zeros(size(class_weights));
        
        % Copy over only the relevant 10 weights
        class_weights_zeros(start_idx:end_idx) = class_weights(start_idx:end_idx);
        
        % Elementwise multiply 'class_weights_zeros' with 'src_library'
        cw_zeros_mult = src_library * class_weights_zeros;
        
        % Now compute the difference x - (cw_zeros_mult)
        difference_mat = x - cw_zeros_mult;
        difference_l2(i) = norm(difference_mat);
    end
    
    % Calculate resulting classification label
    [temp, SRC_label] = min(difference_l2);
    classification = SRC_label - 1; % such that empty classifications will return 0 and class labels are consistent with object alphabetical places
end

