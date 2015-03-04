function testFunctionCallSpeeds
    N = 2e5;
    x = randn(1,1);
    
    function p = gaussian_local(x, mu, sigma)
        p = 1./(sqrt(2*pi*sigma^2)) .* exp( -((x-mu).^2)./(2*sigma^2));       
    end

    gaussian_anon = @(x, mu, sigma)  1./(sqrt(2*pi*sigma^2)) .* exp( -((x-mu).^2)./(2*sigma^2));

    gauss_hybrid = @(x, m, s) gaussian(x, m, s);
    
    tic;
    for i = 1:N
        gaussian(x, 1, 1);
    end
    t = toc;
    disp(['Remote function call : ' num2str(t)]);
    
    tic;
    for i = 1:N
        gaussian_local(x, 1, 1);
    end
    t = toc;
    disp(['Local function call : ' num2str(t)]);

	tic;
    for i = 1:N
        gaussian_anon(x, 1, 1);
    end
    t = toc;
    disp(['Anonymous function call : ' num2str(t)]);

	tic;
    for i = 1:N
        gauss_hybrid(x, 1, 1);
    end
    t = toc;
    disp(['Hybrid (Anonymous call of remote function) : ' num2str(t)]);

end

