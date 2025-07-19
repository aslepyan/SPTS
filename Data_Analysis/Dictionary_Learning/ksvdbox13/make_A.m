function [A] = make_A(dimension,numrows,numcols)

% could have made square matrix and cut it down instead...

sensor_num = numrows*numcols;
num_freqs_per_dim = zeros(1,dimension);
num_freqs_per_dim(:) = floor(sensor_num^(1/dimension));
for i=1:dimension
    if prod(num_freqs_per_dim)<sensor_num
        num_freqs_per_dim(i) = num_freqs_per_dim(i)+1;
    end
end

C = cell(1,dimension);
for i=1:dimension
    C{i} = 1:num_freqs_per_dim(i);
end

combos = combvec(C{:}); % [dim x sensor_num]
combos = combos(:,1:sensor_num); %remove extra columns

A = [];
for i=1:dimension
    temp = zeros(num_freqs_per_dim(i),sensor_num);
    bla = [combos(i,:);1:length(temp)];
    for j=1:length(temp)
        temp(bla(1,j),bla(2,j))=1;
    end
    A = [A; temp];
    %pre_sensor_array{i} = temp;
end
end