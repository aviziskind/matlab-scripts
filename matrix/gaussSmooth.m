function Y2 = gaussSmooth(Y1, w, dim, circularFlag, useFFT_flag)
    if (w == 0)
        Y2 = Y1;
        return;
    end
    
    is_vec = isvector(Y1);
    if is_vec
        Y1 = Y1(:);
    else
        if ~exist('dim', 'var') || isempty(dim)
            dim = 1;
        end
        sizeY1 = size(Y1);
        Y1 = permuteReshapeData(Y1, dim); 
    end
    
    N = size(Y1, 1);
    n_std_gaussians = 4; % how many std deviations of gaussian to actually implement
    n_g = max(ceil(n_std_gaussians*w), 2); 
    
    circularSmooth = exist('circularFlag', 'var') && isequal(circularFlag, 1);
    useFFT = exist('useFFT_flag', 'var') && isequal(useFFT_flag, 1);

    g = gaussian(-n_g:n_g, 0, w);
    g = g/sum(g);

    N_g = length(g);
    N_g_half = round(N_g/2);
    % for convolutions, have to add buffering either way: 
    %       for circular, add circular buffer
    %       for non-circular, add extended value
    % when using FFT, 
    %       for circular, don't need to add buffer;
    %       for non-cicular, add extended value buffer
    
    addBuffer = ~(useFFT && circularSmooth);
    
    if addBuffer
        
        if circularSmooth
            idx_pre  = mod1(N-n_g+1:N, N);
            idx_post = mod1(1:n_g,     N);
            %         Y1 = [Y1(idx_pre); Y1; Y1(idx_post)];
            Y1 = [Y1(idx_pre,:); Y1; Y1(idx_post,:)];
        else
            %         Y1 = [bsxfun(@times, ones(n_g, 1), rowsOfX(Y1, 1));
            %               Y1;
            %               bsxfun(@times, ones(n_g, 1), rowsOfX(Y1, N))];
            Y1 = [ones(n_g, 1) * Y1(1,:); Y1; ones(n_g, 1) * Y1(N,:)];
        end
        
        if useFFT
            idx_use = n_g + N_g_half + [0 : N-1];
        else
            idx_use = n_g + N_g_half  + [0 : N-1];
        end
    else
        idx_use = mod1([1 : N]+n_g, N);
    end
        
        
        
        
    if useFFT 
        Y1_f = fft(Y1);
        g_f = fft(g(:), length(Y1_f));
        
        Y1_conv_g_f = Y1_f .* g_f;
        Y2 = ifft(Y1_conv_g_f, 'symmetric');
    else
        Y2 = myConv(Y1, g, 1);
        
    end
        
    
   
%     N2 = length(g)-N_g_half;

%     N_y2 = size(Y2,1);
    
%     idx_use = [n_g + N_g_half  :  N_y2-N2-n_g];
    
    Y2 = Y2(idx_use,:);
    
    if ~is_vec        
        Y2 = permuteReshapeData(Y2, dim, sizeY1);         
    end
    
end


% function Y = myConv(X, c)
% 
%     sizeX = size(x);
%     [L, ncols] = size(X);
%     rshp = length(size(X)) > 2;
%     Ly = L+length(c)-1;
%     
%     if rshp        
%         X = reshape(X, [L, ncols]);                
%     end
%     
%     Y = convmtx(c(:),L)*X;
% 
%     if rshp
%         Y = reshape(X, [Ly, sizeX(2:end)]);
%     end    
%     
% end

% function Y = rowsOfX(X, rowIdx)
%     [n, ncols] = size(X);
%     sizeX = size(X);
%     X = reshape(X, [n, ncols]);
%     Y = X(rowIdx, :);
%     Y = reshape(Y, [length(rowIdx), sizeX(2:end)]);
% end
