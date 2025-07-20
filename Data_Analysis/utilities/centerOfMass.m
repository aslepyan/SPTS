function distance = centerOfMass(x,x_gt,y_gt)
    % CENTEROFMASS calculates the center of mass of a 10x10 matrix.
    % Rounds the center of mass to the nearest integer.

    % Create coordinate grids
    matrix = reshape(x,[10,10])';
    [X, Y] = meshgrid(1:10, 1:10);
    % Calculate the weighted average for each axis
    total_mass = sum(matrix(:));
    if(total_mass) == 0; total_mass = 1; end
    x_com = sum(sum(X .* matrix)) / total_mass;
    y_com = sum(sum(Y .* matrix)) / total_mass;
    fprintf('Center of Mass: (%d, %d)\n', x_com, y_com);
    distance = sqrt((x_com - x_gt)^2 + (y_com - y_gt)^2);
end