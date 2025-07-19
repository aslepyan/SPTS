function res = lcgRandom(seed)
% LCG for reconstruction. One Calculation only.
% Using input seed (32bit int) and calculate the next random number. 
% Requires trimming after this function call.

% Inputs:
% seed: the old random number in 32bit int array

% Outputs: 
% res: the new random number in 32bit int array

% Dian, 5/31/2024
    a =  1664525; % Multiplier
    c =  1013904223; % Increment
    res = mod((a * seed + c),4294967296); 
end

