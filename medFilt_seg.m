function [x_filt_out, abs_idx_out] = medFilt_seg(x_cur, w, dim, opt)
    % opt: can have fields : 
    %   -- "funcName" specifying an alternate median filter algorithm (must take in
    %       inputs in format funcName(x, w, dim) )
    %   -- "lastOne" (boolean) : if true, the buffer is flushed
    %   -- "freqMode" ('lowPass' (default) or 'highPass')

    persistent x_prev w_prev dim_prev abs_idx_prev;
            
    if (nargin == 0) || strcmp(x_cur, 'clear');
        x_prev = [];
        abs_idx_prev = 0;
        w_prev = [];
        dim_prev = [];        
        return;
    end
    
    if (nargin >= 2) && ~isempty(w)   % w is specified
        if isempty(w_prev)
            w_prev = w;
        else
            if (w_prev ~= w)
                error('w must be the same');
            end
        end        
    else   % w is not specified - use previous one
        if ~isempty(w_prev)
            w = w_prev;
        else
            error('Must specify w');            
        end
    end
    assert(odd(w));
    L = floor(w/2);
    
       
    if (nargin >= 3) && ~isempty(dim)   % dim is specified
        if isempty(dim_prev)
            dim_prev = dim;
        else
            if (dim_prev ~= dim)
                error('dim must be the same');
            end
        end        
    else % dim not specified        
        if ~isempty(dim_prev) 
            dim = dim_prev;
        else
            x_sample = iff(~isempty(x_prev), x_prev, x_cur);  % find first non-sing dimension            
            dim = find(size(x_sample) > 1, 1);
            dim_prev = dim;
        end            
        
    end
    
    if (nargin >= 4) && ~isempty(opt) && isstruct(opt) && isfield(opt, 'funcName')        
        medFiltFunc = opt.funcName;
    else
        medFiltFunc = @fastmedfilt1;
    end

    if (nargin >= 4) && ~isempty(opt) && isstruct(opt) && isfield(opt, 'lastOne')        
        lastOne = opt.lastOne;
    else
        lastOne = false;
    end

    if (nargin >= 4) && ~isempty(opt) && isstruct(opt) && isfield(opt, 'freqMode')        
        freqMode = opt.freqMode;
    else
        freqMode = 'lowPass';
    end
    
    
    nPrev = size(x_prev, dim);
    nCur = size(x_cur, dim);               
    
    if (nPrev == 0) && (nCur < w)
        error('Must have at least w elements in starting segment');
    end
    
    if ~isempty(x_prev)
        idx_prevStart = nPrev - w+1;
        idx_prev_use = max(1, idx_prevStart) : nPrev;
        
        x_withPrev = cat(dim, select_dim(x_prev, idx_prev_use, dim), x_cur);
    else
        x_withPrev = x_cur;
    end
    nTot = size(x_withPrev, dim);

    
    if (w >= floor(nTot/2))
        medFiltFunc = @(x_, w_, dim_) medfilt1(x_, w_, [], dim_);
    end
    
    % do the filtering
    x_withPrev_filt = medFiltFunc( x_withPrev , w, dim);

    if strcmp(freqMode, 'highPass')
        x_withPrev_filt = x_withPrev - x_withPrev_filt;        
    end
    
%     if xor(isrow(x_cur) || isrow(x_prev), isrow(x_withPrev_filt));
%         x_withPrev_filt = x_withPrev_filt';
%     end
    
    
    if isempty(x_prev)
        idx_out_start = 1;
    else    
        idx_out_start = L+2;
    end
    
    if isempty(x_cur) || lastOne
        idx_out_end  = nTot;
    else
        idx_out_end  = nTot-L;
    end
            
    x_filt_out = select_dim(x_withPrev_filt, idx_out_start:idx_out_end, dim);
    abs_idx_out = abs_idx_prev + [1:size(x_filt_out, dim)];
    
    if ~lastOne
        if nCur > w
            x_prev = x_cur;
        else
            nToKeep = w - nCur;
            nToKeep = min(nToKeep, nPrev);
            x_prev = cat(dim, select_dim(x_prev, [nPrev-nToKeep+1:nPrev], dim),  x_cur);        
        end

    else
        x_prev = [];
            
    end
        
    abs_idx_prev = abs_idx_out(end);
end

function x_sel = select_dim(x, idx, dim)
    if dim == 1
        x_sel = x(idx, :);
    elseif dim == 2
        x_sel = x(:, idx);        
    end

end