function testGaussSmooth_nu 
    X = 1;
    rand('state', 0);
    randn('state', 0);

    t1 = 0:.01:10;
    N = 30;
    y = 100*randn(1, N);
    x_uniform = 1:N;
    x_nonuniform = x_uniform + (rand(1, N)-.5)/4;
    
    y_u1 = gaussSmooth(y, 1.5);
    y_u2 = gaussSmooth_nu(x_uniform, y, 1.5);

    figure(1);
    plot(x_uniform, y, 'o', x_uniform, y_u1, 'r:', x_uniform, y_u2, 'g');
%     plot(x_uniform, y, 'o', x_uniform, y_u2, 'g');
    
    
    y_nu = gaussSmooth_nu(x_nonuniform, y, 1.5);
        
    figure(2);
    plot(x_nonuniform, y, 'o', x_nonuniform, y_nu);
        
end













