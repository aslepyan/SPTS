function distance = centerOfMass(x,x_gt,y_gt)
% Calculates the center of mass of a reconstructed tactile signal frame
% using weighted averaging. Then calculates the distance between that of
% the reconstructed signal and the ground truth location.

% Inputs:
% x : reconstructed tactile signal (100 pixels) from OMP
% x_gt, y_gt : ground truth center of mass coordinates
%
% Outputs:
% distance: distance between the calculated center of mass of the
% reconstructed signal frame and the ground truth coordinates

    % Create coordinate grids
    matrix = reshape(x,[10,10])';
    [X, Y] = meshgrid(1:10, 1:10);
    % Calculate the weighted average for each axis
    total_mass = sum(matrix(:));
    if(total_mass) == 0; total_mass = 1; end
    x_com = sum(sum(X .* matrix)) / total_mass;
    y_com = sum(sum(Y .* matrix)) / total_mass;
    % Calculate the distance between the above result with the ground truth
    distance = sqrt((x_com - x_gt)^2 + (y_com - y_gt)^2);
end