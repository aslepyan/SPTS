function y_new = downsample(y,sample_level)
% downsamples the input tactile signal frame by evenly keeping one pixel in
% every consecutive n pixels. All the deleted pixels are then linearly
% interpolated from those that are kept

% Inputs:
% y : reconstructed tactile signal (100 pixels) from OMP
% sample_level : determining how many pixels are kept 
%
% Outputs:
% y_new : new tactile signal frame after downsampling and interpolation

    % selectively keeping a total of "sample_level" pixels evenly through
    % the frame
    non_zero_idz = round(linspace(0,101,sample_level+2));
    non_zero_idz = non_zero_idz(2:end-1);
    v = y(non_zero_idz);
    non_zero_x = mod(non_zero_idz,10)';
    non_zero_x(non_zero_x==0) = 10;
    non_zero_y = ceil(non_zero_idz/10)';

    % repopulating deleted pixels via linear interpolation
    F = scatteredInterpolant(non_zero_x,non_zero_y,v);
    [xq,yq] = meshgrid(1:1:10);
    F.Method = 'linear';
    vq1 = F(xq,yq);
    
    % shaping back to 1*100 vector array used everywhere else
    y_new = reshape(vq1',100,1);
end