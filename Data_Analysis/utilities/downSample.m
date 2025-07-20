function y_new = downsample(y,sample_level)
    non_zero_idz = round(linspace(0,101,sample_level+2));
    non_zero_idz = non_zero_idz(2:end-1);
    v = y(non_zero_idz);
    non_zero_x = mod(non_zero_idz,10)';
    non_zero_x(non_zero_x==0) = 10;
    non_zero_y = ceil(non_zero_idz/10)';

    F = scatteredInterpolant(non_zero_x,non_zero_y,v);
    [xq,yq] = meshgrid(1:1:10);
    F.Method = 'linear';
    vq1 = F(xq,yq);
    %plot3(non_zero_x,non_zero_y,v,'mo')
    %hold on
    %mesh(xq,yq,vq1)
    y_new = reshape(vq1',100,1);
end