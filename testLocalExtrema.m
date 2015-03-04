function testLocalExtrema


%     Y = [5 4 3 2 1 2 3 4 3 2 1 2 1];
%     i1 = findLocalMinima_old(Y);    
%     i2 = findLocalExtrema_Matlab('min', Y);    
%     assert(isequal(i1, i2))    
    
    smths = .1:.1:5;
    ws = 1:5;

    show = false;
    B = 1;
    k = 5;
    doMin = 1;
    doMax = 1;
    
%     Y0 = randn(1,30);
    for sm_i = 1:length(smths)
        sm = smths(sm_i);
        
        for wi = 1:length(ws);
            w = ws(wi);

            for i = 1:2
                Y0 = randn(1,100);
                Y = gaussSmooth(Y0, sm)';
              
                if show
                    figure(1); clf; plot(Y, 'bo-');
                end
                    
                if doMin
                    % all minima
                    
                    tic; for b = 1:B, i_min1 = findLocalExtrema_Matlab('min', Y, w); end; t2 = toc;
                    tic; for b = 1:B, [i_min2, v3] = findLocalMinima(Y, w); end; t3 = toc;
                    assert(isequal( Y(i_min2), v3));
                    assert(isequal(i_min1, i_min2));
                    if B > 1
                        fprintf('All %.2f, %.2f\n', t1/t3, t2/t3)
                    end                        
                    
                    % first 5, min                     
                    tic; for b = 1:B, i_min1_5f = findLocalExtrema_Matlab('min', Y, w, k, 'first');    end; t2 = toc;
                    tic; for b = 1:B, [i_min2_5f, v] = findLocalMinima(Y, w, k, 'first');    end; t3 = toc;
                    assert(isequal( Y(i_min2_5f), v));
                    assert(isequal(i_min1_5f, i_min2_5f));
                    if B > 1
                        fprintf('Only 5 %.2f, %.2f\n', t1/t3, t2/t3)
                    end

                    % last 5, min
                    i_min1_5l = findLocalExtrema_Matlab('min', Y, w, k, 'last');                    
                    [i_min2_5l, v3] = findLocalMinima(Y, w, k, 'last');
                    assert(isequal( Y(i_min2_5l), v3));
                    assert(isequal(i_min1_5l, i_min2_5l));
                    if show
                        hold on; plot(i_min1, Y(i_min1), 'r*');
                    end
                end
                
                if doMax
                    % all maxima
                    i_max1 = findLocalExtrema_Matlab('max', Y, w);    
                    [i_max2, v3] = findLocalMaxima(Y, w);    
                    assert(isequal( Y(i_max2), v3));
                    assert(isequal(i_max1, i_max2));


                    % first 5, max
                    i_max1_5f = findLocalExtrema_Matlab('max', Y, w, k, 'first');    
                    [i_max2_5f, v3] = findLocalMaxima(Y, w, k, 'first');  
                    assert(isequal( Y(i_max2_5f), v3));
                    assert(isequal(i_max1_5f, i_max2_5f));

                    % last 5, max
                    i_max1_5l = findLocalExtrema_Matlab('max', Y, w, k, 'last');                    
                    [i_max2_5l, v3] = findLocalMaxima(Y, w, k, 'last');       
                    assert(isequal( Y(i_max2_5l), v3));
                    assert(isequal(i_max1_5l, i_max2_5l));
                    if show
                        hold on; plot(i_max1, Y(i_max1), 'ks');
                    end                    
                end
                
                if show && (~isempty(i_min1) || ~isempty(i_max1))
                    title(sprintf('sm = %.2f. w = %d', sm, w));
                    3;
                end
                
            end
        end
    end
            

    






end