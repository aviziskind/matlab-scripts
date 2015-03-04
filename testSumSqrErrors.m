function testSumSqrErrors
    
    nPix = 2000;
    nTemplates = 300;
    nUse = 10;
    
    nn = 10;

    tmplates_d = randn(nPix, nTemplates);
    imag_d = randn(nPix, 1);
    
    tmplates_s = single(tmplates_d);
    imag_s = single(imag_d);
    
    tic;
    for i = 1:nn
        sse1_all_dbl = sumSqrErrors_MATLAB(tmplates_d, imag_d);
        sse1_all_flt = sumSqrErrors_MATLAB(tmplates_s, imag_s);
        sse1_n_dbl = sumSqrErrors_MATLAB(tmplates_d, imag_d, nUse);
        sse1_n_flt = sumSqrErrors_MATLAB(tmplates_s, imag_s, nUse);
    end
    t1 = toc;
    
    tic;
    for i = 1:nn
        sse2_all_dbl = sumSqrErrors(tmplates_d, imag_d);
        sse2_all_flt = sumSqrErrors(tmplates_s, imag_s);
        sse2_n_dbl = sumSqrErrors(tmplates_d, imag_d, nUse);
        sse2_n_flt = sumSqrErrors(tmplates_s, imag_s, nUse);
    end
    t2 = toc;
    
    t1/t2
    
    assert( max(abs(sse1_all_dbl(:)-sse2_all_dbl(:))) < 1e-10);
    assert( max(abs(sse1_all_flt(:)-sse2_all_flt(:))) < 1e-10);
    assert( max(abs(sse1_n_dbl(:)-sse2_n_dbl(:))) < 1e-10);
    assert( max(abs(sse1_n_flt(:)-sse2_n_flt(:))) < 1e-10);
%     assert( max(abs(sse1b(:)-sse2b(:))) < 1e-10);

    fprintf('Passed Test\n');

end


function sse = sumSqrErrors_MATLAB(tmp, imag, nUse)
    if nargin < 3
        nUse = size(tmp, 1);
    end
    sse = sum(bsxfun(@minus, tmp(1:nUse,:), imag(1:nUse)).^2, 1);
    


end