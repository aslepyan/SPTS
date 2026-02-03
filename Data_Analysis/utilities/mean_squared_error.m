% December 13th 
% Comparing reconstructed results with raster 
% Calculate mean squared error (raster is gnd truth)

function mean_error = mean_squared_error(x,d)
    %maxRand= max(x);
    %maxRaster = max(d);

    % Count total elements
    nTotal = numel(x);

    % Sum squares of errors for all pixels
    sum_error = 0;
    for i = 1:nTotal
        sum_error = sum_error + (x(i)-d(i))^2;
    end
    
    % Compute mean
    mean_error = sum_error / nTotal;
    
end

