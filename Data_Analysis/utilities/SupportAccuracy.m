function [pctSame,pctDiff] = supportAccuracy(x,d)

% label pixels as 1 or 0 and compare reconstructed tactile signal with
% groud truth raster signal for pixel wise binary agreement. Calculates
% accuracy by number_of_pixels_agreed / total_number_of_pixels

% Inputs:
% x : reconstructed tactile signal (100 pixels) from OMP
% d : ground truth raster scanned tactile signal
%
% Outputs:
% pctSame: resulting support accuracy
% pctDiff: 1 - pctSame

    % Take the max voltage and classify each pixel as 1 or 0
    maxRand= max(x);
    %x(x<0.1) = 0;
    x(x<0.23*maxRand) = 0;
    x(x>0.23*maxRand) = 1;

    %imagesc(reshape(x,10,10)',[-1,1])
    
    % Separate function for comparing support accuracy with raster data 
    maxRaster = max(d);
    %d(d<0.1) = 0;
    d(d<0.23*maxRaster) = 0;
    d(d>0.23*maxRaster) = 1;

    % imagesc(reshape(d,10,10)',[-1,1])
    
    % Count total elements
    nTotal = numel(x);
    
    % Count how many match
    nMatch = sum(x(:) == d(:));
    
    % Count how many differ
    nDiff = nTotal - nMatch;  % or sum(x(:) ~= D(:))
    
    % Compute percentages
    pctSame = (nMatch / nTotal);
    pctDiff = (nDiff  / nTotal);
    
    % Display results
    %fprintf('Percent same: %.2f%%\n', pctSame);
    %fprintf('Percent different: %.2f%%\n', pctDiff);
end

