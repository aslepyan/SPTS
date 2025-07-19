%% Export measurement data from serial port into matlab
% Rudy Zhang, 7/8/20

% serial port setting 
port = '/dev/cu.usbmodem130785001'; % change to your own port
s = serialport(port,9600);
writeline(s, char(42)); % signal teensy that the loop can begin

frameSize = 100; %total number of sensors
frameCount =1000; %total number of frames
framePosition = [];
Ymatrix = zeros(frameSize,frameCount); %measurements
C = [];
% raw data (anolog volatgego) extraction loop
numNoData = 2; %! for first 2 string in serial port are 'sending' and 'sent'.
j=1;

while true
    % for first 2 strings in serial port are 'sending' and 'sent'.
    if j<numNoData+1
        str = readline(s);
        j=j+1;
        % in case the msg is not sent to arduino successfully
        if isempty(str)
            j=1;
            writeline(s, char(42));
            continue;
        end
        disp(str);
        continue;
    end

    % extract voltage reading 
    str = readline(s);
    parts = strsplit(str,',');
    measurements = str2double(parts); 
    if (max(size(measurements)) ~= 100001)
        error("Transmitted Array Incorrect!");
    end
    % record voltage reading and convert
    framePosition = [framePosition, measurements(1)];
    measurements = measurements(2:100001);
    Ymatrix = reshape(measurements,[frameSize,frameCount]);
    % old version
    Ymatrix = Ymatrix/1023*3.3;
    Ymatrix = Ymatrix*508/165 - 4.3; % old version
    %Ymatrix = Ymatrix*11140/570 - 32;
    Ymatrix = -Ymatrix;
    % % plot the Ymatrix 
    % imagesc(Ymatrix,[-1,1]);
    % colorbar;
    % pause(eps);
    
    C = cat(3,C,Ymatrix);
    
end
