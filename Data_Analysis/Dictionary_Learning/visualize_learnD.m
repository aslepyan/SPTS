%% Import and Visualize Raster Entries of all 17 objects 
close all
load("Raster_Entries.mat")
numT = length(Y(:,1)); % Y are raster scans, number of raster scans by number of pixels of each raster scan
plot_Y = reshape(Y, [numT, 10 10]);
reorderedDataR = single(zeros(size(Y)));

for i = 1:numT
    %img = squeeze(plot_Y(i,:,:));
    % Un-comment to visualize
    %imagesc(img',[-1,1]); axis equal %uncomment for plotting
    %drawnow
end

all_data = double(Y);
%% Pre-processing before Dictionary Learning
close all
% add ksvd box to path
addpath 'ksvdbox13'
% add omp box to path
addpath 'ksvdbox13/ompbox10'

% remove small data
all_data = all_data(randperm(size(all_data, 1)),:); %shuffle the order
avgs = max(all_data');
thresh = 0.25; %can be 10 or lower
indices_good = find(avgs > thresh);
good_data = all_data(indices_good,:);

% remove similar data
coherence = normr(good_data) * normr(good_data)' - eye(length(good_data(:,1)));
coherenceT = triu(coherence);
[v,h] = find(coherenceT>0.95);
u = unique(v);
unique_data = good_data(setdiff(1:length(good_data(:,1)),u),:);

% Look at unique data
maxval = max(unique_data');
minval = min(unique_data');
unique_data_N = unique_data';
%unique_data_N = (unique_data'-minval) ./ (maxval-minval);

uniqueImg = showdict(unique_data',[10 10],floor(sqrt(length(unique_data(:,1)))),floor(sqrt(length(unique_data(:,1)))),'lines');
figure()
imagesc(uniqueImg); axis equal
title('Unique Data')

% figure()
% for i = 1:length(unique_data(:,1))
%    imagesc(reshape(unique_data(i,:), [64 16])) %uncomment for plotting
%    axis equal
%    title(i)
%    drawnow
%    pause(0.03)
% end

%% Dictionary Learning
close all
% Perform KSVD 
params.data = unique_data';
params.Tdata = 20 ; %desired sparsity
params.dictsize = 100; %size of dictionary
[Dksvd,g,err] = ksvd(params,''); %Dksvd is dictionary by ksvd

% Normaization Step
maxval = max(Dksvd);
minval = min(Dksvd);
Dksvd_norm = (Dksvd-minval) ./ (maxval-minval);

% Display Learned Dictionary
dictimg = showdict(Dksvd,[10 10],floor(sqrt(params.dictsize)),floor(sqrt(params.dictsize)),'lines');
imagesc(dictimg); axis equal
title('Learned dictionary')

save("dictionary.mat","Dksvd")