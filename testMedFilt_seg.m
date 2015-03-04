function testMedFilt_seg

    show = 1;
    doTiming = 0;
    
    doFlushing = 1;
    doHighPass = 0;
    
    dim = 2;
    M = 1;    

    L = 10;
    W = 2*L+1;
    N_tot = 200;
    
    N_seg = 40;
    nseg = ceil(N_tot/N_seg);
    
    X = randn(M, N_tot)+10;
    if dim == 1
        X = X';
    end
        
    tic;
    x_filt_all = fastmedfilt1(X, W, dim);
    t_fast = toc;
    if doHighPass
        x_filt_all = X-x_filt_all;
    end
    
    tic;
    x_filt_all_matlab = medfilt1(X, W, [], dim);
    t_mat = toc;
    if doHighPass
        x_filt_all_matlab = X-x_filt_all_matlab;
    end    
    
    assert(isequal(x_filt_all, x_filt_all_matlab));
    
    if doTiming
        fprintf('Fast together is %.2f faster than matlab\n', t_mat/t_fast);
    end    
    flipX = iff(dim == 1, @(x) x, @(x) x');
    if show
        figure(1); clf;    
        plot(flipX(x_filt_all), '.-'); hold on;
    end
    
    tic;
    medFilt_seg('clear');
    
    idx_seg = 1;
    
    x_filt_seg = [];%zeros(size(x_filt_all));
    x_filt_seg2 = zeros(size(X));
    
    opt = struct;
    if doHighPass
        opt.freqMode = 'highPass';
    end
    
    for i = 1:nseg
        idx_i = [1:N_seg] + (i-1)*N_seg;
        
        lastOne = any(idx_i >= N_tot);
        if lastOne
            idx_i(idx_i > N_tot) = [];
        end
        if doFlushing
            opt.lastOne = lastOne;
        end
        [x_next, idx_next_out] = medFilt_seg( select_dim(X, idx_i, dim), W, dim, opt);
        
        idx_next = idx_seg + [0:size(x_next, dim)-1];
        assert(isequal(idx_next, idx_next_out));
       
        if show
            plot(idx_next, flipX(x_next), 'ro:');
        end
        idx_seg = idx_seg+ size(x_next, dim);
        
        
        x_filt_seg = cat(dim, x_filt_seg, x_next);    
        if dim == 1
            x_filt_seg2(idx_next, :) = x_next;
        else
            x_filt_seg2(:, idx_next) = x_next;
        end
            
        3;
    end

    if ~doFlushing
        [x_end, idx_end] = medFilt_seg([], W, dim);
        x_filt_seg = cat(dim, x_filt_seg, x_end);                
        if dim == 1
            x_filt_seg2(idx_end, :) = x_end;
        else
            x_filt_seg2(:, idx_end) = x_end;
        end    
    end
    
    t_seg = toc;    
    assert(isequal(x_filt_seg, x_filt_seg2));
    
    if doTiming
        fprintf('Fast together is %.2f faster than fast segmented\n', t_seg/t_fast);
    end
    
    if show
        plot(flipX(x_filt_seg), 'o');

        ok = isequal(x_filt_all, x_filt_seg);
        title(iff(ok, 'MATCH', 'DO NOT MATCH'));
    end

    3;
end

function x_sel = select_dim(x, idx, dim)
    if dim == 1
        x_sel = x(idx, :);
    elseif dim == 2
        x_sel = x(:, idx);        
    end

end